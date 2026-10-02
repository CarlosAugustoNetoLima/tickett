import { NextRequest, NextResponse } from "next/server";
import { backendUrl } from "@/lib/backend";
import { EMAIL_RE } from "@/lib/validation";

export async function POST(request: NextRequest) {
  const body = await request.json().catch(() => null);
  const email = typeof body?.email === "string" ? body.email.trim() : "";

  if (!EMAIL_RE.test(email)) {
    return NextResponse.json({ success: false, code: "invalid_email" }, { status: 400 });
  }

  const upstream = await fetch(backendUrl("company/newsletter"), {
    method: "POST",
    headers: { "content-type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({ email }),
    cache: "no-store",
  }).catch(() => null);

  if (!upstream?.ok) {
    return NextResponse.json({ success: false, code: "upstream_unreachable" }, { status: 502 });
  }

  const data = (await upstream.json().catch(() => null)) as { status?: string; msg?: string } | null;
  if (!data) {
    return NextResponse.json({ success: false, code: "upstream_error" }, { status: 502 });
  }

  return NextResponse.json({ success: data.status === "success", msg: data.msg ?? "" });
}
