import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

type FirebaseServiceAccount = {
  project_id: string;
  private_key: string;
  client_email: string;
  token_uri?: string;
};

const FIREBASE_SCOPE = "https://www.googleapis.com/auth/firebase.messaging";

function toBase64Url(input: string | Uint8Array): string {
  const bytes = typeof input === "string" ? new TextEncoder().encode(input) : input;
  let binary = "";
  for (let i = 0; i < bytes.length; i += 1) {
    binary += String.fromCharCode(bytes[i]);
  }
  return btoa(binary).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/g, "");
}

function pemToArrayBuffer(pem: string): ArrayBuffer {
  const base64 = pem
    .replace("-----BEGIN PRIVATE KEY-----", "")
    .replace("-----END PRIVATE KEY-----", "")
    .replace(/\s+/g, "");

  const binary = atob(base64);
  const bytes = new Uint8Array(binary.length);
  for (let i = 0; i < binary.length; i += 1) {
    bytes[i] = binary.charCodeAt(i);
  }
  return bytes.buffer;
}

async function getFirebaseAccessToken(account: FirebaseServiceAccount): Promise<string> {
  const tokenUri = account.token_uri ?? "https://oauth2.googleapis.com/token";
  const now = Math.floor(Date.now() / 1000);

  const jwtHeader = toBase64Url(JSON.stringify({ alg: "RS256", typ: "JWT" }));
  const jwtPayload = toBase64Url(
    JSON.stringify({
      iss: account.client_email,
      scope: FIREBASE_SCOPE,
      aud: tokenUri,
      iat: now,
      exp: now + 3600,
    }),
  );

  const unsignedJwt = `${jwtHeader}.${jwtPayload}`;
  const key = await crypto.subtle.importKey(
    "pkcs8",
    pemToArrayBuffer(account.private_key),
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );

  const signature = await crypto.subtle.sign(
    { name: "RSASSA-PKCS1-v1_5" },
    key,
    new TextEncoder().encode(unsignedJwt),
  );

  const assertion = `${unsignedJwt}.${toBase64Url(new Uint8Array(signature))}`;
  const tokenRes = await fetch(tokenUri, {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion,
    }),
  });

  const tokenBody = await tokenRes.text();
  if (!tokenRes.ok) {
    throw new Error(`OAuth token request failed: ${tokenBody.slice(0, 500)}`);
  }

  const tokenJson = JSON.parse(tokenBody);
  if (!tokenJson.access_token) {
    throw new Error("OAuth token response missing access_token");
  }

  return tokenJson.access_token as string;
}

Deno.serve(async (req) => {
  try {
    const webhookSecret = Deno.env.get("EDGE_WEBHOOK_SECRET");
    const headerSecret = req.headers.get("x-webhook-secret");
    if (!webhookSecret || headerSecret !== webhookSecret) {
      return new Response(JSON.stringify({ error: "Unauthorized" }), { status: 401 });
    }

    const { notification_id } = await req.json();
    if (!notification_id) {
      return new Response(JSON.stringify({ error: "notification_id is required" }), { status: 400 });
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const serviceRoleKey = Deno.env.get("SERVICE_ROLE_KEY")!;
    const serviceAccountJson = Deno.env.get("FIREBASE_SERVICE_ACCOUNT_JSON");

    if (!serviceAccountJson) {
      return new Response(JSON.stringify({ error: "FIREBASE_SERVICE_ACCOUNT_JSON is missing" }), { status: 500 });
    }

    let serviceAccount: FirebaseServiceAccount;
    try {
      serviceAccount = JSON.parse(serviceAccountJson) as FirebaseServiceAccount;
    } catch {
      return new Response(JSON.stringify({ error: "FIREBASE_SERVICE_ACCOUNT_JSON is not valid JSON" }), { status: 500 });
    }

    if (!serviceAccount.project_id || !serviceAccount.private_key || !serviceAccount.client_email) {
      return new Response(
        JSON.stringify({ error: "FIREBASE_SERVICE_ACCOUNT_JSON is missing required fields" }),
        { status: 500 },
      );
    }

    const accessToken = await getFirebaseAccessToken(serviceAccount);
    const firebaseProjectId = Deno.env.get("FIREBASE_PROJECT_ID") ?? serviceAccount.project_id;
    const supabase = createClient(supabaseUrl, serviceRoleKey);

    const { data: notification, error: nErr } = await supabase
      .from("notifications")
      .select("id, user_id, sender_id, chat_id, title, body, type, data")
      .eq("id", notification_id)
      .single();

    if (nErr || !notification) {
      return new Response(JSON.stringify({ error: "Notification not found", details: nErr?.message }), { status: 404 });
    }

    const { data: user, error: uErr } = await supabase
      .from("users")
      .select("fcm_token")
      .eq("id", notification.user_id)
      .single();

    if (uErr) {
      await supabase
        .from("notifications")
        .update({ delivery_status: "failed", failure_reason: uErr.message })
        .eq("id", notification_id);

      return new Response(JSON.stringify({ error: "Receiver lookup failed", details: uErr.message }), { status: 500 });
    }

    const fcmToken = user?.fcm_token;
    if (!fcmToken) {
      await supabase
        .from("notifications")
        .update({ delivery_status: "skipped_no_token", failure_reason: "No fcm_token for user" })
        .eq("id", notification_id);

      return new Response(JSON.stringify({ ok: true, skipped: "No fcm_token" }), { status: 200 });
    }

    const fcmRes = await fetch(
      `https://fcm.googleapis.com/v1/projects/${firebaseProjectId}/messages:send`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${accessToken}`,
        },
        body: JSON.stringify({
          message: {
            token: fcmToken,
            notification: {
              title: notification.title,
              body: notification.body,
            },
            data: {
              type: String(notification.type ?? "chat"),
              notification_id: String(notification.id),
              chat_id: String(notification.chat_id ?? ""),
              sender_id: String(notification.sender_id ?? ""),
              ...Object.fromEntries(
                Object.entries(notification.data ?? {}).map(([k, v]) => [k, String(v)]),
              ),
              click_action: "FLUTTER_NOTIFICATION_CLICK",
            },
            android: {
              priority: "high",
              notification: {
                click_action: "FLUTTER_NOTIFICATION_CLICK",
              },
            },
          },
        }),
      },
    );

    const fcmBody = await fcmRes.text();

    if (!fcmRes.ok) {
      await supabase
        .from("notifications")
        .update({ delivery_status: "failed", failure_reason: fcmBody.slice(0, 500) })
        .eq("id", notification_id);

      return new Response(JSON.stringify({ error: "FCM send failed", details: fcmBody }), { status: 502 });
    }

    await supabase
      .from("notifications")
      .update({
        delivery_status: "sent",
        delivered_at: new Date().toISOString(),
        failure_reason: null,
      })
      .eq("id", notification_id);

    return new Response(JSON.stringify({ ok: true }), { status: 200 });
  } catch (e) {
    return new Response(JSON.stringify({ error: String(e) }), { status: 500 });
  }
});
