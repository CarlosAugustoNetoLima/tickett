import "server-only";
import { apiGet, ApiError } from "./api-client";
import { formatEventDateLabel, formatEventTime } from "./calendar";
import { toHeroImages, type EventImageSources, type FittedSource } from "./image-format";
import { currencyCode, formatPrice } from "./price";
import { getYouTubeEmbedUrl } from "./youtube";
import { sanitizeHtml } from "./sanitize-html";
import { toPlainText } from "./seo";
import type { ApiEventCard, ApiEventoDetail, ApiEventoDetailResponse } from "@/types/api";

export interface EventoDetalhe {
  id: number;
  slug: string;
  title: string;
  startDate: string;
  imageUrls: string[];
  priceValue: number | null;
  /** ISO 4217, para o schema.org. */
  priceCurrency: string | null;
  category: string | null;
  city: string | null;
  image: FittedSource | null;
  mobileImage: FittedSource | null;
  dateLabel: string;
  timeLabel: string;
  doorsLabel: string | null;
  description: string | null;
  videoEmbedUrl: string | null;
  parentalRating: string | null;
  promoter: string | null;
  venueName: string;
  venueAddress: string;
  venuePlace: { street: string; postalCode: string; city: string; region: string };
  mapsQuery: string;
  priceFrom: string | undefined;
  checkoutUrl: string;
  salesClosed: boolean;
  /** display_in_cover = 1 e venda online ainda aberta. Os outros só abrem por link direto. */
  listed: boolean;
}

// A API manda a data sem fuso. Lida como UTC, e sendo a hora de Portugal UTC ou UTC+1,
// o botão desaparece no máximo uma hora depois do fecho real; nesse intervalo é o
// checkout que recusa, como já acontecia.
function hasPassed(localDateTime: string | null | undefined): boolean {
  if (!localDateTime) return false;
  const time = Date.parse(`${localDateTime.replace(" ", "T")}Z`);
  return Number.isFinite(time) && time < Date.now();
}

function toImageUrl(name: string): string {
  return `https://lebillet.eu/img/shows/${name}`;
}

function pickImageSources(event: ApiEventoDetail): EventImageSources {
  const bannerName = event.bannerPrincipal || event.banner;
  const first = event.images?.[0];
  return {
    banner: bannerName ? toImageUrl(bannerName) : null,
    thumbnail: first ? toImageUrl(first.name) : null,
  };
}

// Por pedido de página. No build há 7 workers em paralelo, e com 8 cada a API já
// respondia 503 (ver apiGet).
const DETAIL_LOOKUP_CONCURRENCY = 4;

async function mapWithConcurrency<T, R>(items: T[], limit: number, fn: (item: T) => Promise<R>): Promise<R[]> {
  const out = new Array<R>(items.length);
  let next = 0;
  const workers = Array.from({ length: Math.min(limit, items.length) }, async () => {
    while (next < items.length) {
      const i = next++;
      out[i] = await fn(items[i]);
    }
  });
  await Promise.all(workers);
  return out;
}

// Só entram nas listagens do site os eventos com display_in_cover = 1 e a venda online
// ainda aberta, como no site PHP antigo (`display_in_cover = '1' AND date_sales_end >
// NOW()`). A página do evento continua a abrir por link direto nos dois casos (também era
// assim, e é o que serve os eventos vendidos só por link ou já com a venda encerrada). A
// lista da API não traz nenhum dos dois campos nem filtra por eles, por isso lê-se do
// detalhe, o mesmo pedido que dá ao cartão a moeda e as imagens (ver toListedCard).
function isListedEvent(event: ApiEventoDetail): boolean {
  return String(event.display_in_cover) === "1" && !hasPassed(event.date_sales_end);
}

// Regra do Júnior: manda o producer_description e, em branco, o nome do organizador. O
// promotor não pode faltar na página (é passível de multa); todos os eventos têm organizador.
// Os dois são texto livre do backoffice, por isso passam a texto simples e sem cortes.
function promoterOf(event: ApiEventoDetail): string | null {
  return toPlainText(event.producer_description, Infinity) || toPlainText(event.organizer?.name, Infinity) || null;
}

// O backoffice guarda as palavras-chave num só texto, uma por linha, às vezes com linhas em
// branco pelo meio.
function tagsOf(event: ApiEventoDetail): string[] {
  return (event.tags ?? "")
    .split(/[\r\n]+/)
    .map((tag) => tag.trim())
    .filter(Boolean);
}

// Última resposta boa do detalhe de cada evento, para quando a API falha mesmo depois das
// repetições do apiGet. Sem ela o cartão ficava só com a imagem da lista, que é o banner
// quando o evento o tem, e cada regeneração da home punha o banner em eventos diferentes.
const lastGoodDetail = new Map<number, ApiEventoDetail>();

// A moeda, as duas imagens e as palavras-chave do evento também só vêm no detalhe, por isso
// o cartão sai daqui já com elas.
async function toListedCard(card: ApiEventCard): Promise<ApiEventCard | null> {
  // O detalhe é por id de evento; um grupo com o mesmo número seria outro registo.
  if (card.type !== "event") return card;
  let event = lastGoodDetail.get(card.id);
  try {
    ({ event } = await apiGet<ApiEventoDetailResponse>(`/eventos/${card.id}`));
    lastGoodDetail.set(card.id, event);
  } catch (err) {
    // Sem detalhe o link do cartão daria 404.
    if (err instanceof ApiError && err.code === "event_not_found") return null;
    console.warn(`[evento-data] detalhe do evento ${card.id} indisponível${event ? " (fica o último)" : ""}:`, err);
    // Já uma falha momentânea da API não pode esvaziar o site, por isso o evento fica.
    if (!event) return card;
  }
  return isListedEvent(event)
    ? { ...card, currency: event.type_currency, images: pickImageSources(event), tags: tagsOf(event) }
    : null;
}

export async function onlyListed(cards: ApiEventCard[]): Promise<ApiEventCard[]> {
  const listed = await mapWithConcurrency(cards, DETAIL_LOOKUP_CONCURRENCY, toListedCard);
  return listed.filter((card): card is ApiEventCard => card !== null);
}

const NUMERIC_ID = /^\d+$/;

// A rota /event/[id] aceita tanto o id numérico quanto o slug do evento. Quando não é
// numérico, resolve pro id primeiro (a API já responde por slug em /eventos/{slug}, só que
// num formato novo e ainda incompleto — ver docs/api-contract-home-eventos-evento.md #4) e
// segue pelo mesmo /eventos/{id} de sempre, pra manter o resto do mapeamento intacto.
async function resolveEventId(identifier: string): Promise<string | null> {
  if (NUMERIC_ID.test(identifier)) return identifier;
  try {
    const bySlug = await apiGet<{ id: number }>(`/eventos/${encodeURIComponent(identifier)}`);
    return String(bySlug.id);
  } catch (err) {
    if (err instanceof ApiError && err.code === "event_not_found") return null;
    throw err;
  }
}

export async function getEventoDetalhe(identifier: string, locale: string): Promise<EventoDetalhe | null> {
  const id = await resolveEventId(identifier);
  if (!id) return null;

  let data: ApiEventoDetailResponse;
  try {
    data = await apiGet<ApiEventoDetailResponse>(`/eventos/${id}`);
  } catch (err) {
    if (err instanceof ApiError && err.code === "event_not_found") return null;
    throw err;
  }

  const { event } = data;
  const images = pickImageSources(event);
  const address = [event.place.location, event.place.zipcode, event.place.city].filter(Boolean).join(", ");

  return {
    id: event.id,
    slug: event.slug,
    title: event.name,
    startDate: event.date_start.replace(" ", "T"),
    imageUrls: [images.banner, images.thumbnail].filter((url): url is string => !!url),
    priceValue: data.priceFrom,
    priceCurrency: currencyCode(event.type_currency),
    category: null,
    city: event.place.city || null,
    ...toHeroImages(images),
    dateLabel: formatEventDateLabel(event.date_start, locale),
    timeLabel: formatEventTime(event.date_start),
    doorsLabel: event.opening_doors || null,
    description: event.description ? sanitizeHtml(event.description) : null,
    videoEmbedUrl: getYouTubeEmbedUrl(event.video_url),
    parentalRating: event.parental_rating,
    promoter: promoterOf(event),
    venueName: event.place.name,
    venueAddress: address,
    venuePlace: {
      street: event.place.location,
      postalCode: event.place.zipcode,
      city: event.place.city,
      region: event.place.region,
    },
    mapsQuery: [event.place.name, event.place.location, event.place.city].filter(Boolean).join(", "),
    priceFrom: formatPrice(data.priceFrom, event.type_currency),
    checkoutUrl: `/checkout/${event.id}`,
    salesClosed: hasPassed(event.date_sales_end),
    listed: isListedEvent(event),
  };
}
