import { defineRouting } from "next-intl/routing";

export const locales = ["pt-PT", "en-GB", "es", "fr"] as const;

export type Locale = (typeof locales)[number];

export const defaultLocale: Locale = "pt-PT";

export const localeLabels: Record<Locale, { flag: string; code: string; name: string }> = {
  "pt-PT": { flag: "🇵🇹", code: "PT", name: "Português" },
  "en-GB": { flag: "🇬🇧", code: "EN", name: "English" },
  es: { flag: "🇪🇸", code: "ES", name: "Español" },
  fr: { flag: "🇫🇷", code: "FR", name: "Français" },
};

export const routing = defineRouting({
  locales,
  defaultLocale,
  localePrefix: "always",
});
