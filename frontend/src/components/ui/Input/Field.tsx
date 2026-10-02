"use client";

import { useId, type ReactNode } from "react";
import { useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import styles from "./Input.module.css";

interface FieldControlOptions {
  id?: string;
  error?: string;
  required?: boolean;
}

export function useFieldControl({ id, error, required }: FieldControlOptions) {
  const autoId = useId();
  const controlId = id ?? autoId;
  return {
    id: controlId,
    "aria-invalid": error ? true : undefined,
    "aria-describedby": error ? `${controlId}-error` : undefined,
    "aria-required": required || undefined,
  };
}

interface FieldProps {
  id: string;
  label?: string;
  required?: boolean;
  optional?: boolean;
  error?: string;
  children: ReactNode;
}

export function Field({ id, label, required, optional, error, children }: FieldProps) {
  const t = useTranslations("form.fields");
  return (
    <div className={styles.field}>
      {label && (
        <div className={cx(styles.labelRow, "caption-md-medium")}>
          <label htmlFor={id} className={styles.label}>
            {label}
          </label>
          {required && (
            <span className={styles.required} aria-hidden="true">
              *
            </span>
          )}
          {optional && <span className={styles.optional}>{t("optional")}</span>}
        </div>
      )}
      {children}
      {error && (
        <p id={`${id}-error`} className={cx(styles.error, "caption-md-regular")} role="alert">
          {error}
        </p>
      )}
    </div>
  );
}
