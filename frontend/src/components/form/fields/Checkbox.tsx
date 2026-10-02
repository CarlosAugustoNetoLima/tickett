"use client";

import { ReactNode } from "react";
import { cx } from "@/lib/cx";
import { Icon } from "@/components/ui/Icon";
import styles from "./Field.module.css";

interface CheckboxProps {
  checked: boolean;
  onChange: (checked: boolean) => void;
  children: ReactNode;
  variant?: "pill" | "plain";
  id?: string;
}

export function Checkbox({ checked, onChange, children, variant = "pill", id }: CheckboxProps) {
  return (
    <label
      htmlFor={id}
      className={cx(
        styles.checkboxRow,
        variant === "pill" ? styles.checkboxPill : styles.checkboxRowPlain
      )}
    >
      <input
        id={id}
        type="checkbox"
        className={cx("sr-only", styles.checkboxInput)}
        checked={checked}
        onChange={(e) => onChange(e.target.checked)}
      />
      <span className={cx(styles.checkboxBox, checked && styles.checkboxBoxChecked)} aria-hidden="true">
        {checked && <Icon name="tick" size={12} />}
      </span>
      <span className={cx(variant === "pill" ? styles.checkboxText : styles.checkboxTextPlain, "body-sm-regular")}>
        {children}
      </span>
    </label>
  );
}
