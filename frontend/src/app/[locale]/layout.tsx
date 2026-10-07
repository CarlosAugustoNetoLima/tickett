import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { preload } from "react-dom";
import { NextIntlClientProvider, hasLocale } from "next-intl";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { routing } from "@/i18n/routing";
import { ChatbaseWidget } from "@/components/chat";
import { CookieConsent } from "@/components/consent";
import { SITE_NAME, SITE_URL } from "@/lib/seo";
import "../../styles/globals.css";

const PRELOADED_FONTS = ["/fonts/inter-v20-latin.woff2", "/fonts/bebas-neue-v16-latin.woff2"];

export function generateStaticParams() {
  return routing.locales.map((locale) => ({ locale }));
}

export async function generateMetadata({
  params,
}: LayoutProps<"/[locale]">): Promise<Metadata> {
  const { locale: requested } = await params;
  const locale = hasLocale(routing.locales, requested) ? requested : routing.defaultLocale;
  const t = await getTranslations({ locale, namespace: "metadata" });
  return {
    metadataBase: new URL(SITE_URL),
    title: { default: t("title"), template: `%s — ${SITE_NAME}` },
    description: t("description"),
    applicationName: SITE_NAME,
    formatDetection: { telephone: false, email: false, address: false },
  };
}

export default async function LocaleLayout({ children, modal, params }: LayoutProps<"/[locale]">) {
  const { locale } = await params;
  if (!hasLocale(routing.locales, locale)) {
    notFound();
  }

  setRequestLocale(locale);
  PRELOADED_FONTS.forEach((href) => preload(href, { as: "font", type: "font/woff2", crossOrigin: "anonymous" }));

  return (
    <html lang={locale}>
      <body>
        <NextIntlClientProvider>
          {children}
          {modal}
          <CookieConsent />
        </NextIntlClientProvider>
        <ChatbaseWidget />
      </body>
    </html>
  );
}
