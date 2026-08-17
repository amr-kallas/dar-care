/**
 * Sanctum session storage.
 *
 * The admin id is needed to subscribe to the private inbox channel
 * (`user.user.{adminId}`), so it is persisted alongside the token.
 */
const TOKEN_KEY = "token";
const ADMIN_ID_KEY = "adminId";
const USER_NAME_KEY = "userName";

export type SessionAdmin = {
  id: number;
  name?: string;
  email?: string;
  role?: string;
};

export const getToken = () => localStorage.getItem(TOKEN_KEY);

export const getAdminId = (): number | null => {
  const raw = localStorage.getItem(ADMIN_ID_KEY);
  if (!raw) return null;
  const id = Number(raw);
  return Number.isFinite(id) ? id : null;
};

export const getAdminName = () => localStorage.getItem(USER_NAME_KEY);

export const setSession = (token: string, admin?: SessionAdmin) => {
  localStorage.setItem(TOKEN_KEY, token);
  if (admin?.id != null) {
    localStorage.setItem(ADMIN_ID_KEY, String(admin.id));
  }
  if (admin?.name) {
    localStorage.setItem(USER_NAME_KEY, admin.name);
  }
};

export const clearSession = () => {
  localStorage.removeItem(TOKEN_KEY);
  localStorage.removeItem(ADMIN_ID_KEY);
  localStorage.removeItem(USER_NAME_KEY);
};
