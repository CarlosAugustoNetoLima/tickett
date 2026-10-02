import { NextRequest, NextResponse } from "next/server";
import { getTranslations } from "next-intl/server";
import { backendUrl } from "@/lib/backend";
import { EMAIL_RE } from "@/lib/validation";
import { buildReceiptText } from "@/components/venda/receipt";
import type { VendaFormData, VendaPayload } from "@/components/venda/types";

const HELPDESK_NO_EVENT = "0";
const MAX_BODY_CHARS = 60_000;

const text = (value: unknown, max: number) => (typeof value === "string" ? value.trim().slice(0, max) : "");
const names = (value: unknown) =>
  Array.isArray(value) ? value.filter((n): n is string => typeof n === "string").map((n) => n.slice(0, 120)) : [];

export async function POST(request: NextRequest) {
  const raw = await request.text();
  if (raw.length > MAX_BODY_CHARS) {
    return NextResponse.json({ success: false, code: "too_large" }, { status: 413 });
  }

  let data: VendaPayload;
  try {
    data = JSON.parse(raw);
  } catch {
    return NextResponse.json({ success: false, code: "invalid_input" }, { status: 400 });
  }

  const name = text(data?.promotor?.nomeResponsavel, 100);
  const email = text(data?.promotor?.email, 100);
  const eventName = text(data?.evento?.nome, 150);

  if (!name || !EMAIL_RE.test(email) || !eventName) {
    return NextResponse.json({ success: false, code: "invalid_input" }, { status: 400 });
  }

  const t = await getTranslations({ locale: "pt-PT", namespace: "venda" });
  let message: string;
  try {
    message = buildReceiptText(data as unknown as VendaFormData, t as never);
  } catch {
    return NextResponse.json({ success: false, code: "invalid_input" }, { status: 400 });
  }

  const files = [
    ["Imagem principal", names(data.evento.imagemPrincipal)],
    ["Banner", names(data.evento.banner)],
    ["Redes sociais", names(data.evento.redesSociais)],
  ] as const;
  message +=
    "\nImagens escolhidas no formulário (não seguem por este canal, pedir ao promotor):\n" +
    files.map(([label, list]) => `  ${label}: ${list.length ? list.join(", ") : "—"}`).join("\n");

  const upstream = await fetch(backendUrl("helpdesk/new"), {
    method: "POST",
    headers: { "content-type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      action: "new",
      name,
      email,
      event: HELPDESK_NO_EVENT,
      subject: `VENDA SEU EVENTO - ${eventName}`.slice(0, 240),
      message,
    }),
    redirect: "manual",
    cache: "no-store",
  }).catch(() => null);

  if (!upstream) {
    return NextResponse.json({ success: false, code: "upstream_unreachable" }, { status: 502 });
  }

  const ticket = upstream.headers.get("location")?.match(/helpdesk\/view\/(\d+)/)?.[1];
  if (upstream.status >= 300 && upstream.status < 400 && ticket) {
    return NextResponse.json({ success: true, ticket });
  }

  return NextResponse.json({ success: false, code: "upstream_rejected" }, { status: 502 });
}
