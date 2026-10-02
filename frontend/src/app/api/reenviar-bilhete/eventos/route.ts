import { NextRequest, NextResponse } from "next/server";
import { backendUrl } from "@/lib/backend";
import { EMAIL_RE } from "@/lib/validation";
import type { ResendEvent } from "@/types/event";

export async function GET(request: NextRequest) {
  const email = request.nextUrl.searchParams.get("email")?.trim() ?? "";

  if (!EMAIL_RE.test(email)) {
    return NextResponse.json({ success: false, code: "invalid_email" }, { status: 400 });
  }

  const upstream = await fetch(backendUrl(`index/getEventsResend/${encodeURIComponent(email)}`), {
    method: "POST",
    cache: "no-store",
  }).catch(() => null);

  if (!upstream?.ok) {
    return NextResponse.json({ success: false, code: "upstream_unreachable" }, { status: 502 });
  }

  const data = (await upstream.json().catch(() => null)) as
    | { success?: boolean; msg?: unknown }
    | null;

  if (!data) {
    return NextResponse.json({ success: false, code: "upstream_error" }, { status: 502 });
  }

  if (!data.success || !Array.isArray(data.msg)) {
    return NextResponse.json({ success: false, code: "email_not_found", events: [] });
  }

  const events: ResendEvent[] = data.msg
    .map((row) => row as { id?: unknown; name?: unknown })
    .filter((row) => row.id != null && typeof row.name === "string")
    .map((row) => ({ id: String(row.id), name: row.name as string }));

  return NextResponse.json({ success: true, events });
}
