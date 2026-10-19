import { NextRequest, NextResponse } from "next/server";
import { backendUrl } from "@/lib/backend";

export const dynamic = "force-dynamic";

export async function POST(request: NextRequest) {
  try {
    const formData = await request.formData();

    const upstream = await fetch(backendUrl("index/sendMailEvent"), {
      method: "POST",
      body: formData,
      redirect: "manual",
      cache: "no-store",
    }).catch(() => null);

    if (!upstream) {
      return NextResponse.json(
        { success: false, code: "upstream_unreachable" },
        { status: 502 }
      );
    }

    const text = await upstream.text().catch(() => "");

    let json: { success?: boolean; msg?: string } | null = null;
    try {
      json = JSON.parse(text) as { success?: boolean; msg?: string };
    } catch {
      json = null;
    }

    if (json && typeof json.success === "boolean") {
      return NextResponse.json(json, { status: upstream.status });
    }

    return NextResponse.json(
      { success: upstream.ok },
      { status: upstream.ok ? 200 : upstream.status }
    );
  } catch {
    return NextResponse.json(
      { success: false, code: "invalid_input" },
      { status: 400 }
    );
  }
}
