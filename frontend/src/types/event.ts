import type { FittedSource } from "@/lib/image-format";

export interface EventCardData {
  href: string;
  image: FittedSource | null;
  title: string;
  venue: string;
  date?: string;
  dateStart?: string | null;
  priceFrom?: string;
}

export interface HeroSlide {
  href: string;
  title: string;
  image: FittedSource | null;
  mobileImage?: FittedSource | null;
  date: string;
  location: string;
  priceFrom?: string;
}

export interface ResendEvent {
  id: string;
  name: string;
}
