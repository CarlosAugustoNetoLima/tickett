import type { useTranslations } from "next-intl";
import { EMAIL_RE } from "@/lib/validation";
import type { BilhetesData, EventoData, FieldErrors, PromotorData, VendaFormData } from "./types";

type VendaT = ReturnType<typeof useTranslations<"venda">>;

const NIF_RE = /^\d{9}$/;

function validatePromotor(data: PromotorData, t: VendaT): FieldErrors {
  const errors: FieldErrors = {};

  if (!data.nomeResponsavel.trim()) errors.nomeResponsavel = t("validation.nomeResponsavel");
  if (!data.nif.trim()) {
    errors.nif = t("validation.nif");
  } else if (!NIF_RE.test(data.nif.trim())) {
    errors.nif = t("validation.nifFormato");
  }
  if (!data.email.trim()) {
    errors.email = t("validation.email");
  } else if (!EMAIL_RE.test(data.email.trim())) {
    errors.email = t("validation.emailFormato");
  }
  if (!data.telefoneNumero.trim()) errors.telefoneNumero = t("validation.telefone");

  return errors;
}

function validateEvento(data: EventoData, t: VendaT): FieldErrors {
  const errors: FieldErrors = {};

  if (!data.nome.trim()) errors.nome = t("validation.nomeEvento");
  if (!data.categoria) errors.categoria = t("validation.categoria");
  if (!data.descricao.trim()) errors.descricao = t("validation.descricao");
  if (!data.dataEvento) errors.dataEvento = t("validation.dataEvento");
  if (!data.horaInicio) errors.horaInicio = t("validation.horaInicio");
  if (!data.recinto.trim()) errors.recinto = t("validation.recinto");
  if (!data.cidade.trim()) errors.cidade = t("validation.cidade");
  if (!data.pais.trim()) errors.pais = t("validation.pais");
  if (data.imagemPrincipal.length === 0) errors.imagemPrincipal = t("validation.imagemPrincipal");
  if (data.banner.length === 0) errors.banner = t("validation.banner");

  return errors;
}

function validateBilhetes(data: BilhetesData, t: VendaT): FieldErrors {
  const errors: FieldErrors = {};

  data.tickets.forEach((ticket, ticketIndex) => {
    if (!ticket.nome.trim()) errors[`ticket-${ticketIndex}-nome`] = t("validation.nomeBilhete");
    ticket.lotes.forEach((lote, loteIndex) => {
      if (!lote.preco.trim() || Number.isNaN(Number(lote.preco))) {
        errors[`ticket-${ticketIndex}-lote-${loteIndex}-preco`] = t("validation.precoBilhete");
      }
      if (!lote.quantidade.trim() || Number(lote.quantidade) <= 0) {
        errors[`ticket-${ticketIndex}-lote-${loteIndex}-quantidade`] = t("validation.quantidadeBilhete");
      }
    });
  });

  if (!data.restricaoIdade) errors.restricaoIdade = t("validation.restricaoIdade");

  return errors;
}

function validateRevisao(aceitaTermos: boolean, t: VendaT): FieldErrors {
  return aceitaTermos ? {} : { aceitaTermos: t("validation.aceitaTermos") };
}

export function totalLotacao(data: BilhetesData): number {
  return data.tickets.reduce(
    (sum, ticket) => sum + ticket.lotes.reduce((s, lote) => s + (Number(lote.quantidade) || 0), 0),
    0
  );
}

export function validateStep(step: number, data: VendaFormData, t: VendaT): FieldErrors {
  switch (step) {
    case 0:
      return validatePromotor(data.promotor, t);
    case 1:
      return validateEvento(data.evento, t);
    case 2:
      return validateBilhetes(data.bilhetes, t);
    case 3:
      return validateRevisao(data.revisao.aceitaTermos, t);
    default:
      return {};
  }
}
