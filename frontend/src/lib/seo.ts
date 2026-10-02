import type { Metadata } from "next";
import { getTranslations } from "next-intl/server";
import { defaultLocale, locales, type Locale } from "@/i18n/routing";

export const SITE_URL = (process.env.NEXT_PUBLIC_SITE_URL ?? "https://tickett.com").replace(/\/+$/, "");
export const SITE_NAME = "Tickett.com";

const OG_LOCALES: Record<Locale, string> = { "pt-PT": "pt_PT", "en-GB": "en_GB", es: "es_ES", fr: "fr_FR" };

export function absoluteUrl(path: string): string {
  return `${SITE_URL}${path}`;
}

export function localeAlternates(path: string): Record<string, string> {
  return {
    ...Object.fromEntries(locales.map((locale) => [locale, `/${locale}${path}`])),
    "x-default": `/${defaultLocale}${path}`,
  };
}

export function toPlainText(html: string | null | undefined, maxLength = 160): string {
  const text = (html ?? "")
    .replace(/<[^>]+>/g, " ")
    .replace(/&nbsp;/g, " ")
    .replace(/&amp;/g, "&")
    .replace(/\s+/g, " ")
    .trim();
  return text.length > maxLength ? `${text.slice(0, maxLength - 1).replace(/\s+\S*$/, "")}…` : text;
}

interface PageMetadataOptions {
  locale: Locale;
  path: string;
  title: string;
  description: string;
  absoluteTitle?: boolean;
  images?: string[];
  noindex?: boolean;
}

export function pageMetadata({
  locale,
  path,
  title,
  description,
  absoluteTitle,
  images,
  noindex,
}: PageMetadataOptions): Metadata {
  const fullTitle = absoluteTitle ? title : `${title} — ${SITE_NAME}`;
  const shareImages = images?.length
    ? images
    : [{ url: `/${locale}/opengraph-image`, width: 1200, height: 630, alt: SITE_NAME }];
  return {
    title: absoluteTitle ? { absolute: title } : title,
    description,
    alternates: { canonical: `/${locale}${path}`, languages: localeAlternates(path) },
    openGraph: {
      type: "website",
      siteName: SITE_NAME,
      locale: OG_LOCALES[locale],
      alternateLocale: locales.filter((l) => l !== locale).map((l) => OG_LOCALES[l]),
      url: `/${locale}${path}`,
      title: fullTitle,
      description,
      images: shareImages,
    },
    twitter: { card: "summary_large_image", title: fullTitle, description, images: shareImages },
    ...(noindex && { robots: { index: false, follow: true } }),
  };
}

type TranslatedPage = "venda" | "reenviarBilhete";

export function translatedPageMetadata(namespace: TranslatedPage, path: string) {
  return async function generateMetadata({ params }: { params: Promise<{ locale: Locale }> }): Promise<Metadata> {
    const { locale } = await params;
    const t = await getTranslations({ locale, namespace });
    return pageMetadata({ locale, path, title: t("title"), description: t("description") });
  };
}
