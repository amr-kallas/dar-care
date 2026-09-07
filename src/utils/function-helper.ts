import { BACKEND_BASE_URL } from "@constants/env";

export function toisoString(date: any) {
  var tzo = -date.getTimezoneOffset(),
    dif = tzo >= 0 ? "+" : "-",
    pad = function (num: any) {
      return (num < 10 ? "0" : "") + num;
    };

  return (
    date.getFullYear() +
    "-" +
    pad(date.getMonth() + 1) +
    "-" +
    pad(date.getDate()) +
    "T" +
    pad(date.getHours()) +
    ":" +
    pad(date.getMinutes()) +
    ":" +
    pad(date.getSeconds()) +
    dif +
    pad(Math.floor(Math.abs(tzo) / 60)) +
    ":" +
    pad(Math.abs(tzo) % 60)
  );
}

/**
 * Laravel stores uploads with a disk-relative path (e.g.
 * `providers/identity/x.jpg`) and serves them from `/storage` via the
 * `storage:link` symlink. Absolute URLs are passed through untouched.
 */
export function storageUrl(path?: string | null): string | undefined {
  if (!path) return undefined;
  if (/^https?:\/\//i.test(path)) return path;
  return `${BACKEND_BASE_URL}/storage/${path.replace(/^\/+/, "")}`;
}
