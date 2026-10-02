export const EMAIL_RE = /^[^\s@"'`\\<>(),;:%]+@[^\s@"'`\\<>(),;:%]+\.[^\s@"'`\\<>(),;:%]+$/;

const PHONE_MIN_DIGITS = 6;
const PHONE_MAX_DIGITS = 15;

export function normalizePhone(dial: string, raw: string): { digits: string; typed: string } {
  const code = dial.replace(/\D/g, "");
  const typed = raw
    .trim()
    .replace(/\s+/g, " ")
    .replace(new RegExp(`^(?:\\+|00)${code}\\s*`), "");
  return { digits: typed.replace(/\D/g, ""), typed };
}

export function isValidPhone(dial: string, raw: string): boolean {
  const { digits } = normalizePhone(dial, raw);
  return digits.length >= PHONE_MIN_DIGITS && digits.length <= PHONE_MAX_DIGITS;
}
