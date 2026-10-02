export const CONSENT_COOKIE = "tkt_consent";
export const CONSENT_MAX_AGE = 60 * 60 * 24 * 182;
export const OPEN_CONSENT_EVENT = "tkt:open-cookie-settings";

export type ConsentChoice = "all" | "essential";

export function hasMarketingConsent(value: string | undefined | null): boolean {
  return value === "all";
}
