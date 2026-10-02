import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { getTranslations } from "next-intl/server";
import type { Locale } from "@/i18n/routing";
import { Navbar } from "@/components/layout/Navbar";
import { MobileNavbar } from "@/components/mobile/Menu";
import { Footer } from "@/components/layout/Footer";
import { EventoDetalhe, EventoDetalheStickySpacer } from "@/components/evento/EventoDetalhe";
import { JsonLd } from "@/components/seo/JsonLd";
import { getEventoDetalhe, type EventoDetalhe as EventoData } from "@/lib/evento-data";
import { absoluteUrl, pageMetadata, SITE_NAME, SITE_URL, toPlainText } from "@/lib/seo";

export const revalidate = 60;

interface EventPageProps {
  // `id` aceita tanto o id numérico quanto o slug do evento (resolvido em getEventoDetalhe);
  // `slug` é o segmento opcional só pra URL ficar legível e não entra na busca.
  params: Promise<{ locale: Locale; id: string; slug?: string[] }>;
}

const eventPath = (event: EventoData) => `/event/${event.id}/${event.slug}`;

export async function generateMetadata({ params }: EventPageProps): Promise<Metadata> {
  const { id, locale } = await params;
  const event = await getEventoDetalhe(id, locale);
  if (!event) return {};
  const t = await getTranslations({ locale, namespace: "seo" });
  return pageMetadata({
    locale,
    path: eventPath(event),
    title: event.title,
    description: t("eventDescription", { title: event.title, date: event.dateLabel, venue: event.venueName }),
    images: event.imageUrls.slice(0, 1),
    // Fora das listagens (display_in_cover ≠ 1) a página só existe para quem tem o link.
    noindex: !event.listed,
  });
}

export default async function EventPage({ params }: EventPageProps) {
  const { id, locale } = await params;
  const event = await getEventoDetalhe(id, locale);
  if (!event) notFound();

  const [tSeo, tNav] = await Promise.all([
    getTranslations({ locale, namespace: "seo" }),
    getTranslations({ locale, namespace: "nav" }),
  ]);
  const path = eventPath(event);
  const url = absoluteUrl(`/${locale}${path}`);

  return (
    <>
      <JsonLd
        data={{
          "@context": "https://schema.org",
          "@graph": [
            {
              "@type": "Event",
              name: event.title,
              startDate: event.startDate,
              eventStatus: "https://schema.org/EventScheduled",
              eventAttendanceMode: "https://schema.org/OfflineEventAttendanceMode",
              url,
              image: event.imageUrls,
              description: toPlainText(event.description, 500),
              location: {
                "@type": "Place",
                name: event.venueName,
                address: {
                  "@type": "PostalAddress",
                  streetAddress: event.venuePlace.street,
                  postalCode: event.venuePlace.postalCode,
                  addressLocality: event.venuePlace.city,
                  addressRegion: event.venuePlace.region,
                },
              },
              // Com a venda online fechada a Tickett.com já não tem oferta para anunciar.
              ...(event.priceValue != null && event.priceCurrency != null && !event.salesClosed && {
                offers: {
                  "@type": "Offer",
                  url,
                  price: event.priceValue,
                  priceCurrency: event.priceCurrency,
                  availability: "https://schema.org/InStock",
                  seller: { "@type": "Organization", name: SITE_NAME, url: SITE_URL },
                },
              }),
            },
            {
              "@type": "BreadcrumbList",
              itemListElement: [
                { "@type": "ListItem", position: 1, name: tSeo("home"), item: absoluteUrl(`/${locale}`) },
                { "@type": "ListItem", position: 2, name: tNav("eventos"), item: absoluteUrl(`/${locale}/eventos`) },
                { "@type": "ListItem", position: 3, name: event.title, item: url },
              ],
            },
          ],
        }}
      />
      <Navbar />
      <MobileNavbar />
      <main>
        <EventoDetalhe event={event} path={path} />
      </main>
      <Footer />
      <EventoDetalheStickySpacer />
    </>
  );
}
