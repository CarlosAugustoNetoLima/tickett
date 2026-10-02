"use client";

import type { SelectHTMLAttributes } from "react";
import { useTranslations } from "next-intl";
import { Field, SelectControl, useFieldControl } from "@/components/ui/Input";

interface SelectProps extends Omit<SelectHTMLAttributes<HTMLSelectElement>, "className" | "size"> {
  label?: string;
  required?: boolean;
  optional?: boolean;
  error?: string;
  placeholder?: string;
  options: { value: string; label: string }[];
}

export function Select({ id, label, required, optional, error, placeholder, ...rest }: SelectProps) {
  const t = useTranslations("form.fields");
  const control = useFieldControl({ id, error, required });
  return (
    <Field id={control.id} label={label} required={required} optional={optional} error={error}>
      <SelectControl {...control} invalid={!!error} placeholder={placeholder ?? t("selectPlaceholder")} {...rest} />
    </Field>
  );
}
