import { NextRequest, NextResponse } from "next/server";
import { getEventosList } from "@/lib/eventos-data";
import { parseEventosFilters } from "@/lib/eventos-filters";

export async function GET(request: NextRequest) {
  const params = request.nextUrl.searchParams;
  const page = Math.max(1, Number(params.get("page")) || 1);
  const { events, totalPages, page: current } = await getEventosList(parseEventosFilters((key) => params.get(key)), page);
  return NextResponse.json({ events, page: current, totalPages });
}
