"use client";

import { useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import { TextInput, PhoneField } from "@/components/form";
import type { FieldErrors, PromotorData } from "../types";
import layout from "@/components/form/FormLayout.module.css";

interface StepPromotorProps {
  data: PromotorData;
  errors: FieldErrors;
  onChange: (data: PromotorData) => void;
}

export function StepPromotor({ data, errors, onChange }: StepPromotorProps) {
  const t = useTranslations("venda.stepPromotor");
  function set<K extends keyof PromotorData>(key: K, value: PromotorData[K]) {
    onChange({ ...data, [key]: value });
  }

  return (
    <section className={layout.section}>
      <h1 className={cx(layout.heading, "heading-h6")}>{t("heading")}</h1>
      <div className={layout.grid}>
        <div className={layout.row}>
          <div className={layout.rowItem}>
            <TextInput
              id="promotor-nome"
              label={t("nome.label")}
              required
              placeholder={t("nome.placeholder")}
              value={data.nomeResponsavel}
              error={errors.nomeResponsavel}
              onChange={(e) => set("nomeResponsavel", e.target.value)}
            />
          </div>
          <div className={layout.rowItem}>
            <TextInput
              id="promotor-entidade"
              label={t("entidade.label")}
              placeholder={t("entidade.placeholder")}
              value={data.entidade}
              onChange={(e) => set("entidade", e.target.value)}
            />
          </div>
        </div>

        <div className={layout.row}>
          <div className={layout.rowItem}>
            <TextInput
              id="promotor-nif"
              label={t("nif.label")}
              required
              placeholder={t("nif.placeholder")}
              inputMode="numeric"
              maxLength={9}
              value={data.nif}
              error={errors.nif}
              onChange={(e) => set("nif", e.target.value.replace(/\D/g, ""))}
            />
          </div>
          <div className={layout.rowItem}>
            <TextInput
              id="promotor-email"
              label={t("email.label")}
              required
              type="email"
              placeholder={t("email.placeholder")}
              value={data.email}
              error={errors.email}
              onChange={(e) => set("email", e.target.value)}
            />
          </div>
        </div>

        <div className={layout.row}>
          <div className={layout.rowItem}>
            <PhoneField
              id="promotor-telefone"
              label={t("telefone.label")}
              required
              dial={data.telefoneDial}
              number={data.telefoneNumero}
              error={errors.telefoneNumero}
              onDialChange={(dial) => set("telefoneDial", dial)}
              onNumberChange={(number) => set("telefoneNumero", number)}
            />
          </div>
          <div className={layout.rowItem}>
            <TextInput
              id="promotor-website"
              label={t("website.label")}
              placeholder={t("website.placeholder")}
              value={data.website}
              onChange={(e) => set("website", e.target.value)}
            />
          </div>
        </div>
      </div>
    </section>
  );
}
