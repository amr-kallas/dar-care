/**
 * Runtime configuration. Values may be overridden per-environment with a .env
 * file; the fallbacks target the local Laravel dev server.
 *
 * Only the *public* Pusher key belongs here. PUSHER_APP_SECRET, PUSHER_APP_ID
 * and the Firebase service account stay on the Laravel server.
 */
export const BACKEND_BASE_URL =
  import.meta.env.VITE_API_BASE_URL ?? "http://127.0.0.1:8000";

/**
 * Broadcasting auth is registered with prefix 'api' in bootstrap/app.php, so it
 * is NOT under /api/v1 like every other endpoint.
 */
export const BROADCASTING_AUTH_URL =
  import.meta.env.VITE_PUSHER_AUTH_ENDPOINT ??
  `${BACKEND_BASE_URL}/api/broadcasting/auth`;

export const PUSHER_APP_KEY =
  import.meta.env.VITE_PUSHER_APP_KEY ?? "82364372bfaf8dcdd482";

export const PUSHER_APP_CLUSTER =
  import.meta.env.VITE_PUSHER_APP_CLUSTER ?? "eu";
