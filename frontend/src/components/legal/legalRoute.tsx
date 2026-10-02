import type { Metadata } from "next";
import type { ReactNode } from "react";
import type { Locale } from "@/i18n/routing";
import { getLegalDocument, type LegalSlug } from "@/content/legal";
import { pageMetadata, toPlainText } from "@/lib/seo";
import { LegalPage } from "./LegalPage";

interface LegalRouteProps {
  params: Promise<{ locale: Locale }>;
}

export function legalMetadata(slug: LegalSlug) {
  return async function generateMetadata({ params }: LegalRouteProps): Promise<Metadata> {
    const { locale } = await params;
    const { title, body } = getLegalDocument(slug, locale);
    return pageMetadata({ locale, path: `/${slug}`, title, description: toPlainText(body) });
  };
}

export function legalPage(slug: LegalSlug, aside?: ReactNode) {
  return async function LegalRoute({ params }: LegalRouteProps) {
    const { locale } = await params;
    return <LegalPage slug={slug} locale={locale} aside={aside} />;
  };
}
