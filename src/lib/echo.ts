import Echo from "laravel-echo";
import Pusher from "pusher-js";
import {
  BROADCASTING_AUTH_URL,
  PUSHER_APP_CLUSTER,
  PUSHER_APP_KEY,
} from "@constants/env";
import { getToken } from "./session";

declare global {
  interface Window {
    Pusher: typeof Pusher;
  }
}

window.Pusher = Pusher;

type EchoClient = Echo<"pusher">;

let echo: EchoClient | null = null;
let echoToken: string | null = null;

/**
 * One Echo instance per authenticated session. The instance is rebuilt when the
 * Sanctum token changes, because the token is baked into the channel-auth
 * headers at construction time.
 */
export const getEcho = (): EchoClient | null => {
  const token = getToken();
  if (!token) {
    disconnectEcho();
    return null;
  }

  if (echo && echoToken === token) return echo;

  disconnectEcho();

  echo = new Echo({
    broadcaster: "pusher",
    key: PUSHER_APP_KEY,
    cluster: PUSHER_APP_CLUSTER,
    forceTLS: true,
    authEndpoint: BROADCASTING_AUTH_URL,
    auth: {
      headers: {
        Authorization: `Bearer ${token}`,
        Accept: "application/json",
      },
    },
  });
  echoToken = token;

  return echo;
};

export const disconnectEcho = () => {
  if (!echo) return;
  echo.disconnect();
  echo = null;
  echoToken = null;
};
