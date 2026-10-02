import type { EventImageSources } from "@/lib/image-format";

type ApiEventType = "event" | "group";

interface ApiEventoPlace {
  id: string;
  name: string;
  location: string;
  city: string;
  region: string;
  zipcode: string;
}

interface ApiEventoImage {
  id: number;
  name: string;
}

export interface ApiEventoDetail {
  id: number;
  name: string;
  slug: string;
  date_start: string;
  opening_doors: string | null;
  /** Fim da venda online, "AAAA-MM-DD HH:MM:SS" sem fuso; depois disto o checkout só mostra "Vendas encerradas". */
  date_sales_end?: string | null;
  /** 1 = aparece nas listagens do site; qualquer outro valor (incluindo null) só abre por link direto. */
  display_in_cover?: string | number | null;
  description: string | null;
  parental_rating: string | null;
  place: ApiEventoPlace;
  images: ApiEventoImage[];
  banner: string | null;
  bannerPrincipal: string | null;
  video_url?: string | null;
  /** Moeda em que o evento é vendido, como o checkout a mostra: "€", "CHF", "$"… */
  type_currency?: string | null;
  /** Promotor escrito à mão no backoffice; quando preenchido, é o que o site mostra. */
  producer_description?: string | null;
  /** Organizador do evento (tabela organizers): é o promotor quando o producer_description está vazio. */
  organizer?: { id: number | string; name: string | null } | null;
  /** Palavras-chave do backoffice (campo tags), uma por linha. A busca do site também procura nelas. */
  tags?: string | null;
}

export interface ApiEventoDetailResponse {
  success: boolean;
  event: ApiEventoDetail;
  priceFrom: number | null;
  urlCheckout: string;
}

export interface ApiEventCard {
  id: number;
  slug: string;
  type: ApiEventType;
  href: string;
  title: string;
  /** A única imagem da lista: o banner quando o evento o tem, senão a imagem do evento. */
  image: string | null;
  city: string | null;
  region: string | null;
  venue: string | null;
  dateStart: string | null;
  dateLabel: string | null;
  priceFrom: number | null;
  /** Não vem na lista da API: é o `type_currency` do detalhe, que o onlyListed lhe junta. */
  currency?: string | null;
  /** As duas imagens, também do detalhe e também juntas pelo onlyListed. */
  images?: EventImageSources;
  /** As palavras-chave do detalhe, uma por item. Só servem à busca e não passam ao cartão do ecrã. */
  tags?: string[];
}

export interface ApiHomeResponse {
  hero: ApiEventCard[];
  destaques: ApiEventCard[];
  maisEventos: ApiEventCard[];
  totalEventosCount: number;
}

export interface ApiGenre {
  slug: string;
  label: string;
  count: number;
  active?: boolean;
}

interface ApiLocation {
  slug: string;
  label: string;
}

interface ApiSortOption {
  value: string;
  label: string;
}

interface ApiEventosFilters {
  genres: ApiGenre[];
  locations: ApiLocation[];
  sortOptions: ApiSortOption[];
}

interface ApiEventosSection {
  genre: string;
  title: string;
  count: number;
  events: ApiEventCard[];
}

interface ApiPagination {
  page: number;
  pageSize: number;
  total: number;
  totalPages: number;
}

export interface ApiEventosListResponse {
  filters: ApiEventosFilters;
  activeGenre: ApiGenre | null;
  destaques: ApiEventCard[] | null;
  sections: ApiEventosSection[] | null;
  events: ApiEventCard[] | null;
  pagination: ApiPagination | null;
}
