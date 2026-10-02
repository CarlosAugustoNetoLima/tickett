"use client";

import { useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import { Checkbox } from "@/components/form";
import { totalLotacao } from "../validation";
import type { FieldErrors, VendaFormData } from "../types";
import layout from "@/components/form/FormLayout.module.css";
import styles from "./Steps.module.css";

interface StepRevisaoProps {
  data: VendaFormData;
  errors: FieldErrors;
  onToggleAceite: (checked: boolean) => void;
}

function SummaryRow({ label, value }: { label: string; value: string }) {
  return (
    <div className={styles.summaryRow}>
      <p className={cx(styles.summaryLabel, "body-sm-regular")}>{label}</p>
      <p className={cx(styles.summaryValue, "body-sm-regular")}>{value || "—"}</p>
    </div>
  );
}

export function StepRevisao({ data, errors, onToggleAceite }: StepRevisaoProps) {
  const t = useTranslations("venda.stepRevisao");
  const tOptions = useTranslations("venda.options");
  const { promotor, evento, bilhetes } = data;

  const categoriaLabel = evento.categoria ? tOptions(`categoria.${evento.categoria}` as never) : evento.categoria;
  const restricaoLabel = bilhetes.restricaoIdade
    ? tOptions(`restricaoIdade.${bilhetes.restricaoIdade}` as never)
    : bilhetes.restricaoIdade;
  const caracteristicasLabel = bilhetes.caracteristicas
    .map((c) => tOptions(`caracteristicas.${c}` as never))
    .filter(Boolean)
    .join(", ");
  const bilhetesLabel = bilhetes.tickets
    .map((ticket) => {
      const lotesLabel = ticket.lotes.map((l) => `${l.preco || "0"} € × ${l.quantidade || "0"}`).join(", ");
      return `${ticket.nome || "—"}: ${lotesLabel}`;
    })
    .join(" | ");
  const imagensRedesLabel =
    evento.redesSociais.length > 0 ? evento.redesSociais.map((f) => f.name).join(", ") : "";

  return (
    <section className={layout.section}>
      <h1 className={cx(layout.heading, "heading-h6")}>{t("heading")}</h1>

      <div className={styles.reviewCard}>
        <div className={styles.summaryBox}>
          <div className={styles.summarySection}>
            <p className={cx(styles.summaryTitle, "body-sm-medium")}>{t("promotor")}</p>
            <SummaryRow label={t("responsavel")} value={promotor.nomeResponsavel} />
            <SummaryRow label={t("nif")} value={promotor.nif} />
            <SummaryRow label={t("email")} value={promotor.email} />
            <SummaryRow
              label={t("telefone")}
              value={promotor.telefoneNumero ? `${promotor.telefoneDial} ${promotor.telefoneNumero}` : ""}
            />
          </div>

          <div className={styles.divider} />

          <div className={styles.summarySection}>
            <p className={cx(styles.summaryTitle, "body-sm-medium")}>{t("evento")}</p>
            <SummaryRow label={t("nome")} value={evento.nome} />
            <SummaryRow label={t("categoria")} value={categoriaLabel} />
            <SummaryRow label={t("descricao")} value={evento.descricao} />
            <SummaryRow label={t("data")} value={evento.dataEvento} />
            <SummaryRow label={t("horaInicio")} value={evento.horaInicio} />
            <SummaryRow label={t("local")} value={evento.recinto} />
            <SummaryRow
              label={t("cidadePais")}
              value={evento.cidade ? `${evento.cidade}, ${evento.pais}` : ""}
            />
          </div>

          <div className={styles.divider} />

          <div className={styles.summarySection}>
            <p className={cx(styles.summaryTitle, "body-sm-medium")}>{t("bilhetica")}</p>
            <SummaryRow label={t("bilhetes")} value={bilhetesLabel} />
            <SummaryRow label={t("lotacaoTotal")} value={`${totalLotacao(bilhetes)} ${t("bilhetesSuffix")}`} />
            <SummaryRow label={t("restricaoIdade")} value={restricaoLabel} />
            <SummaryRow label={t("caracteristicas")} value={caracteristicasLabel} />
            {bilhetes.caracteristicas.includes("acessos-especiais") && (
              <SummaryRow label={t("lotacaoReduzida")} value={bilhetes.lotacaoMobReduzida} />
            )}
          </div>

          <div className={styles.divider} />

          <div className={styles.summarySection}>
            <p className={cx(styles.summaryTitle, "body-sm-medium")}>{t("anexos")}</p>
            <SummaryRow label={t("imagemPrincipal")} value={evento.imagemPrincipal[0]?.name ?? ""} />
            <SummaryRow label={t("banner")} value={evento.banner[0]?.name ?? ""} />
            <SummaryRow label={t("redesSociais")} value={imagensRedesLabel} />
          </div>
        </div>

        <div className={styles.disclaimerRow}>
          <Checkbox variant="plain" checked={data.revisao.aceitaTermos} onChange={onToggleAceite}>
            <span className={cx(styles.disclaimerText, "body-sm-regular")}>
              {t.rich("disclaimer", {
                terms: (chunks) => <span className={styles.disclaimerLink}>{chunks}</span>,
              })}
            </span>
          </Checkbox>
        </div>
        {errors.aceitaTermos && (
          <p className={cx(styles.disclaimerError, "caption-md-regular")} role="alert">
            {errors.aceitaTermos}
          </p>
        )}
      </div>
    </section>
  );
}
