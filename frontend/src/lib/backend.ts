import "server-only";

const BACKEND_ORIGIN = (process.env.BACKEND_ORIGIN ?? "https://lebillet.eu").replace(/\/+$/, "");

export function backendUrl(path: string): string {
  return `${BACKEND_ORIGIN}/${path.replace(/^\/+/, "")}`;
}
