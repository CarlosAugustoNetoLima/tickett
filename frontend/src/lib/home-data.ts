import "server-only";
import { apiGet } from "./api-client";
import { toCardImage, toHeroImages } from "./image-format";
import { onlyListed } from "./evento-data";
import { getUpcomingEvents } from "./eventos-data";
import { formatVenue, imageSourcesOf, toEventCards } from "./event-cards";
import { formatPrice } from "./price";
import type { EventCardData, HeroSlide } from "@/types/event";
import type { ApiEventCard, ApiHomeResponse } from "@/types/api";

function toFeaturedGridCard(card: ApiEventCard): EventCardData {
  return {
    href: card.href,
    image: toCardImage(imageSourcesOf(card)),
    title: card.title,
    venue: [card.dateLabel, card.venue].filter(Boolean).join("  ·  "),
  };
}

function toHeroSlide(card: ApiEventCard): HeroSlide {
  return {
    href: card.href,
    title: card.title,
    ...toHeroImages(imageSourcesOf(card)),
    date: card.dateLabel ?? "",
    location: formatVenue(card),
    priceFrom: formatPrice(card.priceFrom, card.currency),
  };
}

interface HomeData {
  heroSlides: HeroSlide[];
  top10Events: EventCardData[];
  featuredGridEvents: EventCardData[];
}

function fetchHome(): Promise<ApiHomeResponse> {
  return apiGet<ApiHomeResponse>("/home");
}

// A grelha tem 9 lugares, e a API manda os 9 eventos seguintes por data que não estão no
// hero nem nos destaques. Se algum sair por não ser para listar, completa-se pela mesma
// ordem, para a grelha não ficar com um buraco.
async function listedMaisEventos(data: ApiHomeResponse): Promise<ApiEventCard[]> {
  const listed = await onlyListed(data.maisEventos);
  const missing = data.maisEventos.length - listed.length;
  if (missing <= 0) return listed;
  const taken = new Set([...data.hero, ...data.destaques, ...listed].map((card) => card.id));
  const next = (await getUpcomingEvents()).filter((card) => !taken.has(card.id));
  return [...listed, ...next.slice(0, missing)];
}

export async function getHomeData(): Promise<HomeData> {
  const data = await fetchHome();
  const [hero, destaques, maisEventos] = await Promise.all([
    onlyListed(data.hero),
    onlyListed(data.destaques),
    listedMaisEventos(data),
  ]);
  return {
    heroSlides: hero.map(toHeroSlide),
    top10Events: toEventCards(destaques),
    featuredGridEvents: toEventCards(maisEventos, toFeaturedGridCard),
  };
}

export async function getTop10Events(): Promise<EventCardData[]> {
  return toEventCards(await onlyListed((await fetchHome()).destaques));
}
