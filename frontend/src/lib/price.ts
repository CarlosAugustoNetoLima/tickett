// Cada evento é vendido na moeda que tem no backoffice (`type_currency`: "€", "CHF", "$"…),
// que é a que o checkout mostra. Os cartões sem ela (grupos, ou o detalhe em falha) ficam
// no euro, como a maior parte dos eventos.
const DEFAULT_CURRENCY = "€";

const ISO_CODES: Record<string, string> = { "€": "EUR", $: "USD", "£": "GBP", "R$": "BRL" };

function currencySymbol(currency: string | null | undefined): string {
  return currency?.trim() || DEFAULT_CURRENCY;
}

export function formatPrice(value: number | null, currency?: string | null): string | undefined {
  if (value == null) return undefined;
  const symbol = currencySymbol(currency);
  // Um código separa-se do valor ("CHF 50"); um símbolo não ("€50").
  return `${symbol}${/[a-z]$/i.test(symbol) ? " " : ""}${Math.round(value)}`;
}

/** Código ISO 4217 para o schema.org; null quando a moeda não tem um conhecido. */
export function currencyCode(currency: string | null | undefined): string | null {
  const symbol = currencySymbol(currency);
  return ISO_CODES[symbol] ?? (/^[A-Z]{3}$/.test(symbol) ? symbol : null);
}
