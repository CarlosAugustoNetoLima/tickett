import type { NextFetchEvent, NextRequest } from "next/server";
import createMiddleware from "next-intl/middleware";
import { routing } from "./i18n/routing";
import {
  logCampaignVisit,
  readTrackingParam,
  TRACKING_PARAMS,
  trackingCookie,
  type CampaignCodes,
} from "./lib/ref-tracking";

const intlProxy = createMiddleware(routing);

export default function proxy(req: NextRequest, event: NextFetchEvent) {
  const res = intlProxy(req);
  // Como o ControllerBase: o código da URL substitui o da sessão; sem ele na URL, vale o
  // que já está guardado (o cookie faz o papel da sessão PHP) e a página também conta.
  const codes: CampaignCodes = {};
  let tracked = false;
  for (const name of TRACKING_PARAMS) {
    const fromUrl = readTrackingParam(req.nextUrl.searchParams, name);
    const value = fromUrl ?? (req.cookies.get(trackingCookie(name))?.value || null);
    if (!value) continue;
    tracked = true;
    codes[name] = value;
    if (!fromUrl) continue;
    res.cookies.set(trackingCookie(name), fromUrl, {
      httpOnly: true,
      sameSite: "lax",
      secure: process.env.NODE_ENV === "production",
      path: "/",
    });
  }
  if (!tracked) return res;

  // Só conta a página aberta no navegador. Prefetch e navegação interna do Next chegam como
  // fetch (Sec-Fetch-Dest: empty) — os headers RSC o Next tira antes do proxy. Um link sem
  // locale é redirecionado e o pedido seguinte traz o mesmo ?ref/?mkt, que é o que conta.
  // Uma visita com ref e mkt é uma página vista só: uma linha no log, como no PHP.
  const dest = req.headers.get("sec-fetch-dest");
  const pageLoad =
    (dest === null || dest === "document") &&
    !/prefetch/i.test(req.headers.get("sec-purpose") ?? req.headers.get("purpose") ?? "");
  const redirected = res.status >= 300 && res.status < 400;
  // TEMPORÁRIO (debug): aparece no log do servidor Next. Remover depois de confirmar.
  console.log("[proxy]", req.nextUrl.pathname, codes, "dest:", dest, "pageLoad:", pageLoad, "status:", res.status);
  if (pageLoad && !redirected) event.waitUntil(logCampaignVisit(req, codes));

  return res;
}

export const config = {
  matcher: ["/((?!api|_next|.*\\..*).*)"],
};
