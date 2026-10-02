import type { MetadataRoute } from "next";
import { locales } from "@/i18n/routing";
import { getUpcomingEvents } from "@/lib/eventos-data";
import { absoluteUrl, localeAlternates } from "@/lib/seo";

export const revalidate = 3600;

const PAGES: { path: string; priority: number; changeFrequency: "daily" | "weekly" | "monthly" }[] = [
  { path: "", priority: 1, changeFrequency: "daily" },
  { path: "/eventos", priority: 0.9, changeFrequency: "daily" },
  { path: "/venda", priority: 0.6, changeFrequency: "monthly" },
  { path: "/reenviar-bilhete", priority: 0.5, changeFrequency: "monthly" },
  { path: "/sobre", priority: 0.4, changeFrequency: "monthly" },
  { path: "/termos", priority: 0.2, changeFrequency: "monthly" },
  { path: "/privacidade", priority: 0.2, changeFrequency: "monthly" },
  { path: "/cookies", priority: 0.2, changeFrequency: "monthly" },
  { path: "/acessibilidade", priority: 0.2, changeFrequency: "monthly" },
];

function localized(path: string, priority: number, changeFrequency: "daily" | "weekly" | "monthly"): MetadataRoute.Sitemap {
  const languages = Object.fromEntries(
    Object.entries(localeAlternates(path)).map(([lang, href]) => [lang, absoluteUrl(href)])
  );
  return locales.map((locale) => ({
    url: absoluteUrl(`/${locale}${path}`),
    changeFrequency,
    priority,
    alternates: { languages },
  }));
}

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const events = await getUpcomingEvents().catch(() => []);
  return [
    ...PAGES.flatMap((page) => localized(page.path, page.priority, page.changeFrequency)),
    ...events.map((event) => event.href).flatMap((href) => localized(href, 0.8, "daily")),
  ];
}
