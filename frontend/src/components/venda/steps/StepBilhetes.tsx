"use client";

import { useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import { Button } from "@/components/ui/Button";
import { Icon } from "@/components/ui/Icon";
import { TextInput, Select, Checkbox, TextArea } from "@/components/form";
import { RESTRICAO_IDADE_KEYS, CARACTERISTICAS_KEYS } from "../options";
import { createTicketLote, createTicketType } from "../types";
import { totalLotacao } from "../validation";
import type { BilhetesData, Caracteristica, FieldErrors, TicketLote, TicketType } from "../types";
import layout from "@/components/form/FormLayout.module.css";
import styles from "./Steps.module.css";

interface StepBilhetesProps {
  data: BilhetesData;
  errors: FieldErrors;
  onChange: (data: BilhetesData) => void;
}

export function StepBilhetes({ data, errors, onChange }: StepBilhetesProps) {
  const t = useTranslations("venda.stepBilhetes");
  const tOptions = useTranslations("venda.options");
  const restricaoIdadeOptions = RESTRICAO_IDADE_KEYS.map((value) => ({
    value,
    label: tOptions(`restricaoIdade.${value}`),
  }));
  const caracteristicasOptions = CARACTERISTICAS_KEYS.map((value) => ({
    value,
    label: tOptions(`caracteristicas.${value}`),
  }));

  function updateTicket(ticketId: string, patch: Partial<TicketType>) {
    onChange({
      ...data,
      tickets: data.tickets.map((t) => (t.id === ticketId ? { ...t, ...patch } : t)),
    });
  }

  function updateLote(ticketId: string, loteId: string, patch: Partial<TicketLote>) {
    onChange({
      ...data,
      tickets: data.tickets.map((t) =>
        t.id === ticketId
          ? { ...t, lotes: t.lotes.map((l) => (l.id === loteId ? { ...l, ...patch } : l)) }
          : t
      ),
    });
  }

  function addTicket() {
    onChange({ ...data, tickets: [...data.tickets, createTicketType()] });
  }

  function removeTicket(ticketId: string) {
    onChange({ ...data, tickets: data.tickets.filter((t) => t.id !== ticketId) });
  }

  function addLote(ticketId: string) {
    onChange({
      ...data,
      tickets: data.tickets.map((t) =>
        t.id === ticketId ? { ...t, lotes: [...t.lotes, createTicketLote()] } : t
      ),
    });
  }

  function removeLote(ticketId: string, loteId: string) {
    onChange({
      ...data,
      tickets: data.tickets.map((t) =>
        t.id === ticketId ? { ...t, lotes: t.lotes.filter((l) => l.id !== loteId) } : t
      ),
    });
  }

  function toggleCaracteristica(value: Caracteristica, checked: boolean) {
    const next = checked
      ? [...data.caracteristicas, value]
      : data.caracteristicas.filter((c) => c !== value);
    onChange({ ...data, caracteristicas: next });
  }

  const mostraLotacaoReduzida = data.caracteristicas.includes("acessos-especiais");

  return (
    <section className={layout.section}>
      <h1 className={cx(layout.heading, "heading-h6")}>{t("heading")}</h1>

      <div className={layout.grid}>
        {data.tickets.map((ticket, ti) => (
          <div className={styles.ticketCard} key={ticket.id}>
            <TextInput
              label={t("nomeBilhete.label")}
              required
              placeholder={t("nomeBilhete.placeholder")}
              value={ticket.nome}
              error={errors[`ticket-${ti}-nome`]}
              onChange={(e) => updateTicket(ticket.id, { nome: e.target.value })}
            />

            <div className={styles.lotesWrap}>
              {ticket.lotes.map((lote, li) => (
                <div className={styles.loteRow} key={lote.id}>
                  <div className={styles.loteField}>
                    <TextInput
                      label={t("lote.label")}
                      placeholder={t("lote.placeholder")}
                      value={lote.lote}
                      onChange={(e) => updateLote(ticket.id, lote.id, { lote: e.target.value })}
                    />
                  </div>
                  <div className={styles.loteFieldFixed}>
                    <TextInput
                      label={t("preco.label")}
                      required
                      placeholder="0.00"
                      inputMode="decimal"
                      value={lote.preco}
                      error={errors[`ticket-${ti}-lote-${li}-preco`]}
                      onChange={(e) => updateLote(ticket.id, lote.id, { preco: e.target.value })}
                    />
                  </div>
                  <div className={styles.loteFieldFixed}>
                    <TextInput
                      label={t("quantidade.label")}
                      required
                      placeholder={t("quantidade.placeholder")}
                      inputMode="numeric"
                      value={lote.quantidade}
                      error={errors[`ticket-${ti}-lote-${li}-quantidade`]}
                      onChange={(e) =>
                        updateLote(ticket.id, lote.id, { quantidade: e.target.value.replace(/\D/g, "") })
                      }
                    />
                  </div>
                  {ticket.lotes.length > 1 && (
                    <button
                      type="button"
                      className={styles.removeLoteBtn}
                      onClick={() => removeLote(ticket.id, lote.id)}
                      aria-label={t("removerLoteAria")}
                    >
                      <Icon name="x" size={24} />
                    </button>
                  )}
                </div>
              ))}
              <div className={styles.lotesFooterRow}>
                <Button
                  type="button"
                  variant="secondary"
                  className={styles.addLoteBtn}
                  onClick={() => addLote(ticket.id)}
                >
                  {t("adicionarLote")}
                </Button>
                {data.tickets.length > 1 && (
                  <button
                    type="button"
                    className={cx(styles.removeTicketBtn, "caption-md-regular")}
                    onClick={() => removeTicket(ticket.id)}
                  >
                    {t("removerBilhete")}
                  </button>
                )}
              </div>
            </div>
          </div>
        ))}

        <div className={styles.addAndTotal}>
          <Button type="button" variant="secondary" className={styles.addTicketBtn} onClick={addTicket}>
            {t("adicionarTipo")}
          </Button>
          <span className={cx(styles.totalBadge, "caption-md-regular")}>
            {t("lotacaoTotal")}
            <span className={styles.totalBadgeStrong}>{totalLotacao(data)}</span> {t("bilhetesSuffix")}
          </span>
        </div>
      </div>

      <div className={layout.grid}>
        <Select
          label={t("restricaoIdade.label")}
          required
          options={restricaoIdadeOptions}
          value={data.restricaoIdade}
          error={errors.restricaoIdade}
          onChange={(e) => onChange({ ...data, restricaoIdade: e.target.value })}
        />

        <div className={layout.grid}>
          <p className="caption-md-medium">
            {t("caracteristicas")} <span className={styles.optionalSuffix}>{t("caracteristicasHint")}</span>
          </p>
          <div className={styles.charRow}>
            {caracteristicasOptions.map((option) => (
              <Checkbox
                key={option.value}
                checked={data.caracteristicas.includes(option.value)}
                onChange={(checked) => toggleCaracteristica(option.value, checked)}
              >
                {option.label}
              </Checkbox>
            ))}
          </div>
        </div>

        {mostraLotacaoReduzida && (
          <TextInput
            label={t("lotacaoReduzida.label")}
            placeholder={t("lotacaoReduzida.placeholder")}
            inputMode="numeric"
            value={data.lotacaoMobReduzida}
            onChange={(e) =>
              onChange({ ...data, lotacaoMobReduzida: e.target.value.replace(/\D/g, "") })
            }
          />
        )}

        <TextArea
          label={t("observacoes.label")}
          optional
          placeholder={t("observacoes.placeholder")}
          rows={4}
          value={data.observacoes}
          onChange={(e) => onChange({ ...data, observacoes: e.target.value })}
        />
      </div>
    </section>
  );
}
