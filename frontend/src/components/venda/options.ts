import { pad } from "@/lib/calendar";
import type { Caracteristica } from "./types";

export const CATEGORIA_KEYS = [
  "concerto",
  "festival",
  "teatro",
  "comedia",
  "desporto",
  "conferencia",
  "workshop",
  "familia",
  "outro",
] as const;

export const RESTRICAO_IDADE_KEYS = ["todas-idades", "m3", "m6", "m12", "m16", "m18"] as const;

export const PAIS_KEYS = [
  "Portugal",
  "Espanha",
  "França",
  "Reino Unido",
  "Brasil",
  "Angola",
  "Moçambique",
  "Cabo Verde",
  "Outro",
] as const;

export const CARACTERISTICAS_KEYS: Caracteristica[] = ["lugares-marcados", "acessos-especiais", "descontos"];

export const TIME_OPTIONS = Array.from({ length: 48 }, (_, i) => {
  const hours = Math.floor(i / 2);
  const minutes = i % 2 === 0 ? "00" : "30";
  const value = `${pad(hours)}:${minutes}`;
  return { value, label: value };
});
