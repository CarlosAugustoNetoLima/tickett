import "server-only";

const BASE_URL = process.env.LEBILLET_API_URL ?? "https://lebillet.eu/api-eventos";
const TOKEN = process.env.LEBILLET_API_TOKEN ?? "";

export class ApiError extends Error {
  status: number;
  code: string;

  constructor(status: number, code: string, message: string) {
    super(message);
    this.name = "ApiError";
    this.status = status;
    this.code = code;
  }
}

type QueryParams = Record<string, string | number | boolean | undefined | null>;

function buildUrl(path: string, params?: QueryParams): string {
  const url = new URL(`${BASE_URL}${path}`);
  if (params) {
    for (const [key, value] of Object.entries(params)) {
      if (value !== undefined && value !== null && value !== "") {
        url.searchParams.set(key, String(value));
      }
    }
  }
  return url.toString();
}

// A API responde 503 a rajadas: no build, os 7 workers a pedir o detalhe de cada evento ao
// mesmo tempo davam dezenas de falhas. A 30/09, 27 pedidos de uma vez davam 7 falhas, e o
// mesmo pedido meio segundo depois já passava. São pedidos GET, por isso repetem-se com espera.
const RETRY_STATUS = new Set([429, 502, 503, 504]);
const RETRY_DELAYS_MS = [500, 1500, 3000];

function wait(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

export async function apiGet<T>(path: string, params?: QueryParams, revalidate = 60): Promise<T> {
  const url = buildUrl(path, params);
  let res: Response;
  for (let attempt = 0; ; attempt++) {
    res = await fetch(url, {
      headers: {
        Authorization: `Basic ${Buffer.from(`${TOKEN}:`).toString("base64")}`,
        Accept: "application/json",
        // Durante a renderização o Next memoriza cada fetch pela URL e pelos cabeçalhos,
        // também quando a resposta é um erro: sem isto, cada repetição recebia o mesmo 503
        // guardado, sem voltar à API. O `signal`, que é a saída documentada, o Next descarta
        // quando regenera uma página com a cache expirada, que é o caso da home.
        ...(attempt > 0 && { "X-Retry-Attempt": String(attempt) }),
      },
      next: { revalidate },
    });
    if (!RETRY_STATUS.has(res.status) || attempt >= RETRY_DELAYS_MS.length) break;
    await wait(RETRY_DELAYS_MS[attempt] + Math.random() * 250);
  }

  const body = await res.json().catch(() => null);

  if (!res.ok) {
    throw new ApiError(
      res.status,
      body?.error?.code ?? "unknown_error",
      body?.error?.message ?? `Lebillet API request failed with status ${res.status}`
    );
  }

  return body as T;
}
