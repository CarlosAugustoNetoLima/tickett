import "server-only";
import { isBannerImage, toCardImage, type EventImageSources } from "./image-format";
import { formatPrice } from "./price";
import type { EventCardData } from "@/types/event";
import type { ApiEventCard } from "@/types/api";

export function formatVenue(card: ApiEventCard): string {
  return [card.venue, card.city].filter(Boolean).join(" - ");
}

// O onlyListed junta ao cartão as duas imagens do detalhe. Sem elas (grupos, ou um evento
// cujo detalhe a API ainda não deu nenhuma vez) só há a imagem da lista, que é o banner
// quando o evento o tem.
export function imageSourcesOf(card: ApiEventCard): EventImageSources {
  if (card.images) return card.images;
  return isBannerImage(card.image)
    ? { banner: card.image, thumbnail: null }
    : { banner: null, thumbnail: card.image };
}

function toEventCardData(card: ApiEventCard): EventCardData {
  return {
    href: card.href,
    image: toCardImage(imageSourcesOf(card)),
    title: card.title,
    venue: formatVenue(card),
    date: card.dateLabel ?? undefined,
    dateStart: card.dateStart,
    priceFrom: formatPrice(card.priceFrom, card.currency),
  };
}

export function sortByDateAsc<T extends { dateStart?: string | null }>(cards: T[]): T[] {
  return [...cards].sort((a, b) => {
    if (!a.dateStart) return b.dateStart ? 1 : 0;
    if (!b.dateStart) return -1;
    return Date.parse(a.dateStart) - Date.parse(b.dateStart);
  });
}

export function toEventCards(
  cards: ApiEventCard[],
  map: (card: ApiEventCard) => EventCardData = toEventCardData
): EventCardData[] {
  return cards.map((card) => map(card));
}
