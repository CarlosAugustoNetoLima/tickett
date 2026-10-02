"use client";

import { useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import { TextInput, PhoneField, Select } from "@/components/form";
import type { ResendEvent } from "@/types/event";
import styles from "@/components/form/FormLayout.module.css";

export interface ReenviarBilheteData {
  email: string;
  telefoneDial: string;
  telefoneNumero: string;
  evento: string;
}

export type ReenviarBilheteErrors = Partial<
  Record<"email" | "telefoneNumero" | "evento", string>
>;

export type EventsStatus = "idle" | "loading" | "loaded" | "notFound" | "error";

export function createInitialData(): ReenviarBilheteData {
  return { email: "", telefoneDial: "+351", telefoneNumero: "", evento: "" };
}

interface FormStepProps {
  data: ReenviarBilheteData;
  errors: ReenviarBilheteErrors;
  onChange: (data: ReenviarBilheteData) => void;
  events: ResendEvent[];
  eventsStatus: EventsStatus;
}

export function FormStep({ data, errors, onChange, events, eventsStatus }: FormStepProps) {
  const t = useTranslations("reenviarBilhete.form");

  function set<K extends keyof ReenviarBilheteData>(key: K, value: ReenviarBilheteData[K]) {
    onChange({ ...data, [key]: value });
  }

  const eventoPlaceholder =
    eventsStatus === "loading"
      ? t("evento.loading")
      : eventsStatus === "notFound"
        ? t("evento.notFound")
        : eventsStatus === "error"
          ? t("evento.error")
          : eventsStatus === "loaded" && events.length === 0
            ? t("evento.empty")
            : t("evento.placeholder");

  return (
    <section className={styles.section}>
      <h1 className={cx(styles.heading, "heading-h6")}>{t("heading")}</h1>
      <div className={styles.grid}>
        <div className={styles.row}>
          <div className={styles.rowItem}>
            <TextInput
              id="reenvio-email"
              label={t("email.label")}
              required
              type="email"
              placeholder={t("email.placeholder")}
              value={data.email}
              error={errors.email}
              onChange={(e) => set("email", e.target.value)}
            />
          </div>
          <div className={styles.rowItem}>
            <PhoneField
              id="reenvio-telefone"
              label={t("telefone.label")}
              required
              dial={data.telefoneDial}
              number={data.telefoneNumero}
              error={errors.telefoneNumero}
              onDialChange={(dial) => set("telefoneDial", dial)}
              onNumberChange={(number) => set("telefoneNumero", number)}
            />
          </div>
        </div>

        <div className={styles.row}>
          <div className={styles.rowItem}>
            <Select
              id="reenvio-evento"
              label={t("evento.label")}
              required
              placeholder={eventoPlaceholder}
              disabled={events.length === 0}
              options={events.map((event) => ({ value: event.id, label: event.name }))}
              value={data.evento}
              error={errors.evento}
              onChange={(e) => set("evento", e.target.value)}
            />
          </div>
        </div>

        <p className={cx(styles.hint, "caption-md-regular")}>{t("evento.hint")}</p>
      </div>
    </section>
  );
}
