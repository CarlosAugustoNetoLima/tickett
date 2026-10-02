import "server-only";
import type { Locale } from "@/i18n/routing";
import { defaultLocale } from "@/i18n/routing";
import content from "./legal.json";

export type LegalSlug = "sobre" | "termos" | "privacidade" | "cookies" | "acessibilidade";

interface LegalDocument {
  title: string;
  body: string;
}

// A política de privacidade está truncada de propósito, igual à publicada no lebillet.eu.
const documents = content as Record<LegalSlug, Record<string, LegalDocument>>;

export function getLegalDocument(slug: LegalSlug, locale: Locale): LegalDocument {
  const byLocale = documents[slug];
  return byLocale[locale] ?? byLocale[defaultLocale];
}
