"use client";

import { useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import { Icon } from "@/components/ui/Icon";
import { Field, Input, useFieldControl } from "@/components/ui/Input";
import { COUNTRY_CODES } from "@/lib/countries";
import styles from "./Field.module.css";

interface PhoneFieldProps {
  label?: string;
  required?: boolean;
  error?: string;
  dial: string;
  number: string;
  onDialChange: (dial: string) => void;
  onNumberChange: (number: string) => void;
  placeholder?: string;
  id?: string;
}

export function PhoneField({
  label,
  required,
  error,
  dial,
  number,
  onDialChange,
  onNumberChange,
  placeholder,
  id,
}: PhoneFieldProps) {
  const t = useTranslations("form.fields");
  const tCountries = useTranslations("form.countries");
  const control = useFieldControl({ id, error, required });
  const selected = COUNTRY_CODES.find((c) => c.dial === dial) ?? COUNTRY_CODES[0];

  const dialPicker = (
    <span className={styles.phonePrefix}>
      <span className={cx(styles.phoneDisplay, "body-sm-medium")} aria-hidden="true">
        <span>{selected.flag}</span>
        <span>{selected.dial}</span>
        <Icon name="arrow-down" size={16} />
      </span>
      <select
        aria-label={t("dialAria")}
        className={styles.phoneSelect}
        value={selected.dial}
        onChange={(e) => onDialChange(e.target.value)}
      >
        {COUNTRY_CODES.map((c) => (
          <option key={c.code} value={c.dial}>
            {c.flag} {c.dial} {tCountries(c.name as never)}
          </option>
        ))}
      </select>
    </span>
  );

  return (
    <Field id={control.id} label={label} required={required} error={error}>
      <Input
        {...control}
        invalid={!!error}
        start={dialPicker}
        type="tel"
        inputMode="tel"
        autoComplete="tel-national"
        placeholder={placeholder ?? t("phonePlaceholder")}
        value={number}
        onChange={(e) => onNumberChange(e.target.value)}
      />
    </Field>
  );
}
