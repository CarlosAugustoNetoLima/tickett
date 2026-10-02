import { NextRequest, NextResponse } from "next/server";
import { backendUrl } from "@/lib/backend";
import { COUNTRY_CODES } from "@/lib/countries";
import { EMAIL_RE, isValidPhone, normalizePhone } from "@/lib/validation";

const EVENT_RE = /^\d{1,10}$/;
const DIALS = new Set(COUNTRY_CODES.map((country) => country.dial));

export type ResendCode =
  | "sent"
  | "phone_mismatch"
  | "no_purchase"
  | "send_failed"
  | "recaptcha_required"
  | "invalid_input"
  | "upstream_unreachable"
  | "upstream_error"
  | "unknown";

function codeFor(success: boolean, msg: string): ResendCode {
  if (success) return "sent";
  if (/telefone não encontrado/i.test(msg)) return "phone_mismatch";
  if (/não possui compra/i.test(msg)) return "no_purchase";
  if (/problema ao enviar/i.test(msg)) return "send_failed";
  if (/robô|recaptcha/i.test(msg)) return "recaptcha_required";
  return "unknown";
}

type Upstream =
  | { ok: true; code: ResendCode; msg: string }
  | { ok: false; code: "upstream_unreachable" | "upstream_error" };

async function requestResend(fields: Record<string, string>): Promise<Upstream> {
  const res = await fetch(backendUrl("index/resendEmail"), {
    method: "POST",
    headers: { "content-type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams(fields),
    cache: "no-store",
  }).catch(() => null);

  if (!res?.ok) return { ok: false, code: "upstream_unreachable" };

  const data = (await res.json().catch(() => null)) as { success?: unknown; msg?: unknown } | null;
  if (!data) return { ok: false, code: "upstream_error" };

  const msg = typeof data.msg === "string" ? data.msg : "";
  return { ok: true, code: codeFor(data.success === true, msg), msg };
}

export async function POST(request: NextRequest) {
  const body = await request.json().catch(() => null);
  const text = (value: unknown) => (typeof value === "string" ? value.trim() : "");

  const email = text(body?.email);
  const mobileCountry = text(body?.mobileCountry);
  const cellNumber = text(body?.cellNumber);
  const event = text(body?.event);
  const recaptchaToken = text(body?.recaptchaToken);

  if (
    !EMAIL_RE.test(email) ||
    !DIALS.has(mobileCountry) ||
    !EVENT_RE.test(event) ||
    !isValidPhone(mobileCountry, cellNumber)
  ) {
    return NextResponse.json({ success: false, code: "invalid_input" }, { status: 400 });
  }

  if (!recaptchaToken) {
    return NextResponse.json({ success: false, code: "recaptcha_required" }, { status: 400 });
  }

  const { digits, typed } = normalizePhone(mobileCountry, cellNumber);
  const variants = [...new Set([digits, typed])];
  let mismatch: { code: ResendCode; msg: string } | null = null;

  for (const variant of variants) {
    const upstream = await requestResend({
      email,
      mobile_country: mobileCountry,
      cell_number: variant,
      event,
      "g-recaptcha-response": recaptchaToken,
    });

    if (!upstream.ok) {
      return NextResponse.json({ success: false, code: upstream.code }, { status: 502 });
    }

    if (mismatch && upstream.code === "recaptcha_required") break;

    // Só "telefone não bate" justifica tentar o outro formato; qualquer outra resposta é final, logo nunca há envio duplo.

    if (upstream.code !== "phone_mismatch") {
      return NextResponse.json({
        success: upstream.code === "sent",
        code: upstream.code,
        msg: upstream.msg,
      });
    }

    mismatch = { code: upstream.code, msg: upstream.msg };
  }

  return NextResponse.json({ success: false, ...mismatch });
}
