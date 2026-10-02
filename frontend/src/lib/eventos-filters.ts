export type SortKey = "populares" | "data" | "preco_asc" | "preco_desc";
export const SORT_KEYS: SortKey[] = ["populares", "data", "preco_asc", "preco_desc"];
const DEFAULT_SORT: SortKey = "data";

export type PrecoKey = "qualquer" | "gratuito" | "ate-25" | "25-50" | "50-100" | "100-200" | "acima-200";
export const PRECO_KEYS: PrecoKey[] = ["qualquer", "gratuito", "ate-25", "25-50", "50-100", "100-200", "acima-200"];

export interface FilterOption {
  slug: string;
  name: string;
}

export interface EventosFilters {
  categoria: string | null;
  cidade: string | null;
  preco: PrecoKey;
  ordenar: SortKey;
  data_inicio: string | null;
  data_fim: string | null;
  busca: string | null;
}

const SEARCH_MIN_LENGTH = 2;
export const SEARCH_MAX_LENGTH = 80;
const ISO_DATE = /^\d{4}-\d{2}-\d{2}$/;

export function normalizeSearchQuery(raw: string): string | null {
  const trimmed = raw.trim().slice(0, SEARCH_MAX_LENGTH);
  return trimmed.length >= SEARCH_MIN_LENGTH ? trimmed : null;
}

function oneOf<T extends string>(values: readonly T[], value: string | null, fallback: T): T {
  return values.includes(value as T) ? (value as T) : fallback;
}

export function parseEventosFilters(get: (key: string) => string | null): EventosFilters {
  const date = (key: string) => {
    const value = get(key);
    return value && ISO_DATE.test(value) ? value : null;
  };
  return {
    categoria: get("categoria") || null,
    cidade: get("cidade") || null,
    preco: oneOf(PRECO_KEYS, get("preco"), "qualquer"),
    ordenar: oneOf(SORT_KEYS, get("ordenar"), DEFAULT_SORT),
    data_inicio: date("data_inicio"),
    data_fim: date("data_fim"),
    busca: normalizeSearchQuery(get("busca") ?? ""),
  };
}

export function hasActiveFilters(filters: EventosFilters): boolean {
  return (
    filters.cidade != null ||
    filters.preco !== "qualquer" ||
    filters.ordenar !== DEFAULT_SORT ||
    filters.data_inicio != null ||
    filters.data_fim != null
  );
}

export function eventosQuery(filters: Partial<EventosFilters>): URLSearchParams {
  const params = new URLSearchParams();
  if (filters.categoria) params.set("categoria", filters.categoria);
  if (filters.cidade) params.set("cidade", filters.cidade);
  if (filters.preco && filters.preco !== "qualquer") params.set("preco", filters.preco);
  if (filters.ordenar && filters.ordenar !== DEFAULT_SORT) params.set("ordenar", filters.ordenar);
  if (filters.data_inicio) params.set("data_inicio", filters.data_inicio);
  if (filters.data_fim) params.set("data_fim", filters.data_fim);
  if (filters.busca) params.set("busca", filters.busca);
  return params;
}

export function buildEventosUrl(filters: Partial<EventosFilters>): string {
  const qs = eventosQuery(filters).toString();
  return qs ? `/eventos?${qs}` : "/eventos";
}

export function searchFold(value: string): string {
  return value
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase();
}
