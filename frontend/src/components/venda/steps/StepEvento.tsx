"use client";

import { useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import { TextInput, TextArea, Select, FileField, DateField } from "@/components/form";
import { CATEGORIA_KEYS, PAIS_KEYS, TIME_OPTIONS } from "../options";
import type { EventoData, FieldErrors } from "../types";
import layout from "@/components/form/FormLayout.module.css";
import styles from "./Steps.module.css";

interface StepEventoProps {
  data: EventoData;
  errors: FieldErrors;
  onChange: (data: EventoData) => void;
}

export function StepEvento({ data, errors, onChange }: StepEventoProps) {
  const t = useTranslations("venda.stepEvento");
  const tOptions = useTranslations("venda.options");
  const tCountries = useTranslations("form.countries");
  const categoriaOptions = CATEGORIA_KEYS.map((value) => ({ value, label: tOptions(`categoria.${value}`) }));
  const paisOptions = PAIS_KEYS.map((value) => ({ value, label: tCountries(value) }));

  function set<K extends keyof EventoData>(key: K, value: EventoData[K]) {
    onChange({ ...data, [key]: value });
  }

  return (
    <section className={layout.section}>
      <h1 className={cx(layout.heading, "heading-h6")}>{t("heading")}</h1>
      <div className={layout.grid}>
        <div className={layout.row}>
          <div className={layout.rowItem}>
            <TextInput
              id="evento-nome"
              label={t("nome.label")}
              required
              placeholder={t("nome.placeholder")}
              value={data.nome}
              error={errors.nome}
              onChange={(e) => set("nome", e.target.value)}
            />
          </div>
          <div className={layout.rowItem}>
            <Select
              id="evento-categoria"
              label={t("categoria.label")}
              required
              options={categoriaOptions}
              value={data.categoria}
              error={errors.categoria}
              onChange={(e) => set("categoria", e.target.value)}
            />
          </div>
        </div>

        <TextArea
          id="evento-descricao"
          label={t("descricao.label")}
          required
          placeholder={t("descricao.placeholder")}
          rows={4}
          value={data.descricao}
          error={errors.descricao}
          onChange={(e) => set("descricao", e.target.value)}
        />

        <div className={layout.row}>
          <div className={layout.rowItem}>
            <DateField
              id="evento-data"
              label={t("data.label")}
              required
              value={data.dataEvento}
              error={errors.dataEvento}
              onChange={(value) => set("dataEvento", value)}
            />
          </div>
          <div className={cx(styles.rowPair, styles.rowPairNested)}>
            <div className={layout.rowItem}>
              <Select
                id="evento-abertura"
                label={t("abertura.label")}
                options={TIME_OPTIONS}
                value={data.aberturaPortas}
                onChange={(e) => set("aberturaPortas", e.target.value)}
              />
            </div>
            <div className={layout.rowItem}>
              <Select
                id="evento-hora-inicio"
                label={t("horaInicio.label")}
                required
                options={TIME_OPTIONS}
                value={data.horaInicio}
                error={errors.horaInicio}
                onChange={(e) => set("horaInicio", e.target.value)}
              />
            </div>
          </div>
        </div>

        <div className={styles.rowPair}>
          <div className={layout.rowItem}>
            <DateField
              id="evento-fim-vendas-data"
              label={t("fimVendasData.label")}
              value={data.fimVendasData}
              onChange={(value) => set("fimVendasData", value)}
            />
          </div>
          <div className={layout.rowItem}>
            <Select
              id="evento-fim-vendas-hora"
              label={t("fimVendasHora.label")}
              options={TIME_OPTIONS}
              value={data.fimVendasHora}
              onChange={(e) => set("fimVendasHora", e.target.value)}
            />
          </div>
        </div>

        <div className={layout.row}>
          <div className={layout.rowItem}>
            <TextInput
              id="evento-recinto"
              label={t("recinto.label")}
              required
              placeholder={t("recinto.placeholder")}
              value={data.recinto}
              error={errors.recinto}
              onChange={(e) => set("recinto", e.target.value)}
            />
          </div>
          <div className={layout.rowItem}>
            <TextInput
              id="evento-morada"
              label={t("morada.label")}
              placeholder={t("morada.placeholder")}
              value={data.morada}
              onChange={(e) => set("morada", e.target.value)}
            />
          </div>
        </div>

        <div className={layout.row}>
          <div className={layout.rowItem}>
            <TextInput
              id="evento-cidade"
              label={t("cidade.label")}
              required
              placeholder={t("cidade.placeholder")}
              value={data.cidade}
              error={errors.cidade}
              onChange={(e) => set("cidade", e.target.value)}
            />
          </div>
          <div className={layout.rowItem}>
            <Select
              id="evento-pais"
              label={t("pais.label")}
              required
              options={paisOptions}
              value={data.pais}
              error={errors.pais}
              onChange={(e) => set("pais", e.target.value)}
            />
          </div>
        </div>

        <div className={layout.row}>
          <div className={layout.rowItem}>
            <FileField
              label={t("imagemPrincipal.label")}
              required
              accept="image/jpeg,image/png,image/webp"
              maxSizeMB={5}
              requiredDimensions={{ width: 1438, height: 959 }}
              files={data.imagemPrincipal}
              error={errors.imagemPrincipal}
              onChange={(files) => set("imagemPrincipal", files)}
              mobileHint={t("imagemPrincipal.mobileHint")}
            />
          </div>
          <div className={layout.rowItem}>
            <FileField
              label={t("banner.label")}
              required
              accept="image/jpeg,image/png,image/webp"
              maxSizeMB={5}
              requiredDimensions={{ width: 1430, height: 340 }}
              files={data.banner}
              error={errors.banner}
              onChange={(files) => set("banner", files)}
              mobileHint={t("banner.mobileHint")}
            />
          </div>
        </div>

        <FileField
          label={t("redesSociais.label")}
          optional
          multiple
          maxSizeMB={50}
          files={data.redesSociais}
          onChange={(files) => set("redesSociais", files)}
          mobileHint={t("redesSociais.mobileHint")}
        />

        <p className={cx(layout.hint, styles.hintDesktop, "caption-md-regular")}>{t("hintDesktop")}</p>
      </div>
    </section>
  );
}
