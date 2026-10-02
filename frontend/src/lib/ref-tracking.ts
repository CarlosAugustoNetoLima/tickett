import "server-only";
import { createHash } from "node:crypto";
import type { NextRequest } from "next/server";

// Códigos de campanha que chegam no link: ?ref= (comissário/indicação) e ?mkt= (marketing).
// Ficam na sessão do navegador (cookie tkt_ref / tkt_mkt) para seguirem até o checkout,
// como o site PHP fazia com a sessão dele. O ref acaba em orders.ref.
export const TRACKING_PARAMS = ["ref", "mkt"] as const;
export type TrackingParam = (typeof TRACKING_PARAMS)[number];

export const trackingCookie = (name: TrackingParam) => `tkt_${name}`;

// Endpoint do site PHP que grava a visita (VisitController::logAction), fixo no código.
const VISIT_LOG_URL = "https://www.tickett.com/visit/log";

// As campanhas usam minúsculas e maiúsculas (?REF=, ?MKT=); o PHP só lia em minúsculo.
export function readTrackingParam(params: URLSearchParams, name: TrackingParam): string | null {
  for (const [key, value] of params) {
    if (key.toLowerCase() === name && value.trim()) return value.trim();
  }
  return null;
}

export type CampaignCodes = Partial<Record<TrackingParam, string | null>>;

// Manda para o PHP o que o ControllerBase fazia em cada página vista:
// - a linha de _log_site_pages_views (ControllerBase::log());
// - a linha de rp_register do ref/mkt ativo (tipo REF / MKT), deduplicada no PHP por ip + código + url.
// codes = ref/mkt ativos (da URL ou do cookie); sem eles, usa só o que está na URL.
export async function logCampaignVisit(req: NextRequest, codes: CampaignCodes = {}): Promise<void> {
  const host = req.headers.get("x-forwarded-host") ?? req.headers.get("host") ?? req.nextUrl.host;
  // O site está atrás do Cloudflare: cf-connecting-ip é o IP real do visitante.
  const ip =
    req.headers.get("cf-connecting-ip")?.trim() ||
    req.headers.get("x-forwarded-for")?.split(",")[0].trim() ||
    req.headers.get("x-real-ip") ||
    "";
  const agent = req.headers.get("user-agent") ?? "";
  const referer = req.headers.get("referer") ?? "";
  const { pathname, search, searchParams } = req.nextUrl;
  // Sem sessão PHP aqui: agrupa o mesmo visitante (IP + navegador) por dia, no lugar do session_id().
  const day = new Date().toISOString().slice(0, 10);
  const session = createHash("sha256").update(`${ip}|${agent}|${day}`).digest("hex").slice(0, 26);
  const ref = codes.ref ?? readTrackingParam(searchParams, "ref") ?? "";
  const mkt = codes.mkt ?? readTrackingParam(searchParams, "mkt") ?? "";

  const res = await fetch(VISIT_LOG_URL, {
    method: "POST",
    headers: { "content-type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      url: `${host}${pathname}${search}`,
      ip,
      session,
      agent,
      request: JSON.stringify({ _url: pathname, ...Object.fromEntries(searchParams) }),
      url_refer: referer,
      ref,
      mkt,
    }),
    cache: "no-store",
  }).catch((err) => {
    console.warn("[ref-tracking] visita não registada:", err);
    return null;
  });

  // TEMPORÁRIO (debug): aparece no log do servidor Next. Remover depois de confirmar.
  console.log("[ref-tracking] enviado para", VISIT_LOG_URL, "ref:", ref, "mkt:", mkt, "ip:", ip, "status:", res?.status);

  if (res && !res.ok) {
    const body = await res.text().catch(() => "");
    console.warn("[ref-tracking] PHP respondeu", res.status, body.slice(0, 300));
  }
}
