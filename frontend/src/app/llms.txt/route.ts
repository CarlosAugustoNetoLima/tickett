import { getUpcomingEvents } from "@/lib/eventos-data";
import { SUPPORT_EMAIL } from "@/lib/contact";
import { formatPrice } from "@/lib/price";
import { absoluteUrl } from "@/lib/seo";

export const revalidate = 3600;

export async function GET() {
  const events = await getUpcomingEvents().catch(() => []);
  const eventLines = events.map((event) => {
    const price = formatPrice(event.priceFrom, event.currency);
    const details = [
      event.dateStart?.slice(0, 16).replace("T", " "),
      [event.venue, event.city].filter(Boolean).join(", "),
      price ? `from ${price}` : null,
    ].filter(Boolean);
    return `- [${event.title}](${absoluteUrl(`/en-GB${event.href}`)}): ${details.join(" · ")}`;
  });

  const body = [
    "# Tickett.com",
    "",
    "> Tickett.com is an online ticketing platform for concerts, parties, theatre, conferences and other live events in Portugal and across Europe. Tickets are bought online with secure payment and delivered by email and WhatsApp.",
    "",
    "The site is available in Portuguese (/pt-PT), English (/en-GB), Spanish (/es) and French (/fr). Prices are in euros unless another currency is shown.",
    "",
    "## Main pages",
    `- [Events](${absoluteUrl("/en-GB/eventos")}): all upcoming events, filterable by category, city, date and price`,
    `- [Sell your event](${absoluteUrl("/en-GB/venda")}): organisers submit an event to sell tickets on Tickett.com`,
    `- [Resend ticket](${absoluteUrl("/en-GB/reenviar-bilhete")}): buyers get their ticket sent again by email and WhatsApp`,
    `- [About](${absoluteUrl("/en-GB/sobre")})`,
    `- [Terms of sale](${absoluteUrl("/en-GB/termos")})`,
    `- [Privacy policy](${absoluteUrl("/en-GB/privacidade")})`,
    `- [Cookie policy](${absoluteUrl("/en-GB/cookies")})`,
    `- [Accessibility statement](${absoluteUrl("/en-GB/acessibilidade")})`,
    "",
    "## Contact",
    `- Email: ${SUPPORT_EMAIL}`,
    "",
    "## Upcoming events",
    ...eventLines,
    "",
  ].join("\n");

  return new Response(body, { headers: { "Content-Type": "text/plain; charset=utf-8" } });
}
