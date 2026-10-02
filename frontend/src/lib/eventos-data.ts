import "server-only";
import { apiGet, ApiError } from "./api-client";
import { formatVenue, toEventCards } from "./event-cards";
import { onlyListed } from "./evento-data";
import { searchFold, type EventosFilters, type FilterOption, type PrecoKey } from "./eventos-filters";
import type { EventCardData } from "@/types/event";
import type { ApiEventCard, ApiEventosListResponse, ApiGenre } from "@/types/api";

const PRECO_RANGE: Record<PrecoKey, { min?: number; max?: number }> = {
  qualquer: {},
  gratuito: { min: 0, max: 0 },
  "ate-25": { max: 25 },
  "25-50": { min: 25, max: 50 },
  "50-100": { min: 50, max: 100 },
  "100-200": { min: 100, max: 200 },
  "acima-200": { min: 200 },
};

const PAGE_SIZE = 60;
const MAX_MERGE_PAGES = 10;
const ALL_GENRES_SLUG = "todos";

interface EventosCatalog {
  categories: FilterOption[];
  cities: FilterOption[];
}

interface EventosList {
  events: EventCardData[];
  page: number;
  totalPages: number;
}

type ApiLocation = ApiEventosListResponse["filters"]["locations"][number];

interface CategoryEvents {
  category: FilterOption;
  events: EventCardData[];
  count: number;
}

function slugifyLabel(label: string): string {
  return label
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

function toCategory(genre: ApiGenre): FilterOption {
  return { slug: slugifyLabel(genre.label), name: genre.label };
}

function fetchEventos(filters: Partial<EventosFilters>, extra: Record<string, string | number> = {}) {
  const range = PRECO_RANGE[filters.preco ?? "qualquer"];
  return apiGet<ApiEventosListResponse>("/eventos", {
    dateFrom: filters.data_inicio,
    dateTo: filters.data_fim,
    location: filters.cidade,
    priceMin: range.min,
    priceMax: range.max,
    sort: filters.ordenar,
    pageSize: PAGE_SIZE,
    ...extra,
  });
}

function fetchFacets() {
  return fetchEventos({}, { pageSize: 1 });
}

// A API não pesquisa texto, por isso a busca filtra aqui os eventos já listados. Como no site
// antigo (`tags LIKE '%termo%'`), procura o termo inteiro no título, no local e nas
// palavras-chave do backoffice, sem contar maiúsculas nem acentos. As palavras-chave vêm do
// onlyListed e não passam aos cartões do ecrã.
function matchesBusca(busca: string | null): (card: ApiEventCard) => boolean {
  if (!busca) return () => true;
  const needle = searchFold(busca);
  return (card) => [card.title, formatVenue(card), ...(card.tags ?? [])].some((text) => searchFold(text).includes(needle));
}

// As contagens das categorias e a lista de locais vêm da API e incluem os eventos fora das
// listagens (ver onlyListed). Uma categoria ou um local só com esses levaria a uma página
// vazia, por isso saem. Só se confirma o que pode estar nesse caso: categorias com tantos
// eventos ou menos do que os escondidos no site inteiro, e locais onde há um escondido.
async function keepGenresWithListed(genres: ApiGenre[], hiddenCount: number): Promise<ApiGenre[]> {
  const keep = await Promise.all(
    genres.map(async (genre) => {
      if (genre.count > hiddenCount) return true;
      const data = await fetchEventos({}, { genre: genre.slug });
      return (await onlyListed(data.events ?? [])).length > 0;
    })
  );
  return genres.filter((_, i) => keep[i]);
}

function keepLocationsWithListed(locations: ApiLocation[], listed: ApiEventCard[], hidden: ApiEventCard[]): ApiLocation[] {
  const citySlugs = (cards: ApiEventCard[]) => new Set(cards.map((c) => slugifyLabel(c.city ?? "")));
  const listedCities = citySlugs(listed);
  const hiddenCities = citySlugs(hidden);
  return locations.filter((l) => !hiddenCities.has(l.slug) || listedCities.has(l.slug));
}

export async function getEventosCatalog(): Promise<EventosCatalog> {
  const [{ filters }, all] = await Promise.all([fetchFacets(), fetchAllRawCards({})]);
  const listed = await onlyListed(all);
  const listedIds = new Set(listed.map((c) => c.id));
  const hidden = all.filter((c) => !listedIds.has(c.id));

  const genres = filters.genres.filter((g) => g.slug !== ALL_GENRES_SLUG && g.count > 0);
  const categories = hidden.length ? await keepGenresWithListed(genres, hidden.length) : genres;
  const locations = hidden.length ? keepLocationsWithListed(filters.locations, listed, hidden) : filters.locations;
  return {
    categories: categories.map(toCategory),
    cities: locations.map((location) => ({ slug: location.slug, name: location.label })),
  };
}

export async function getEventosList(filters: EventosFilters, page = 1): Promise<EventosList> {
  const data = await fetchEventos(filters, { page });
  return {
    events: toEventCards(await onlyListed(data.events ?? [])),
    page: data.pagination?.page ?? page,
    totalPages: data.pagination?.totalPages ?? 1,
  };
}

// O total da paginação da API conta também os eventos fora das listagens.
export async function getEventosCount(filters: EventosFilters): Promise<number> {
  return (await fetchAllCards(filters)).length;
}

async function fetchAllRawCards(filters: Partial<EventosFilters>): Promise<ApiEventCard[]> {
  const first = await fetchEventos(filters);
  const totalPages = Math.min(first.pagination?.totalPages ?? 1, MAX_MERGE_PAGES);
  const rest = await Promise.all(
    Array.from({ length: totalPages - 1 }, (_, i) => fetchEventos(filters, { page: i + 2 }))
  );
  return [first, ...rest].flatMap((data) => data.events ?? []);
}

async function fetchAllCards(filters: Partial<EventosFilters>): Promise<ApiEventCard[]> {
  return onlyListed(await fetchAllRawCards(filters));
}

export async function getAllEvents(filters: EventosFilters): Promise<EventCardData[]> {
  return toEventCards((await fetchAllCards(filters)).filter(matchesBusca(filters.busca)));
}

export function getUpcomingEvents(): Promise<ApiEventCard[]> {
  return fetchAllCards({ ordenar: "data" });
}

async function fetchGenre(slug: string, filters: EventosFilters) {
  const data = await fetchEventos(filters, { genre: slug });
  return data.activeGenre ? { data, genre: data.activeGenre } : null;
}

async function resolveGenre(slug: string, filters: EventosFilters) {
  try {
    const found = await fetchGenre(slug, filters);
    if (found) return found;
  } catch (err) {
    if (!(err instanceof ApiError && err.code === "invalid_genre")) throw err;
  }
  const match = (await fetchFacets()).filters.genres.find((g) => slugifyLabel(g.label) === slug);
  return match ? fetchGenre(match.slug, filters).catch(() => null) : null;
}

export async function getCategoryEvents(slug: string, filters: EventosFilters): Promise<CategoryEvents | null> {
  if (slug === ALL_GENRES_SLUG) return null;
  const resolved = await resolveGenre(slug, filters);
  if (!resolved) return null;
  const events = resolved.data.events ?? [];
  const listed = await onlyListed(events);
  const shown = listed.filter(matchesBusca(filters.busca));
  return {
    category: toCategory(resolved.genre),
    events: toEventCards(shown),
    // Sem busca vale a contagem da API, menos os escondidos; com busca conta o que ficou.
    count: filters.busca ? shown.length : Math.max(0, resolved.genre.count - (events.length - listed.length)),
  };
}
