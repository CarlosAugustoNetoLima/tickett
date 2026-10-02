import type { ReactNode } from "react";
import { cx } from "@/lib/cx";
import styles from "./Input.module.css";

export interface InputBoxProps {
  size?: "md" | "sm";
  invalid?: boolean;
  disabled?: boolean;
  multiline?: boolean;
  start?: ReactNode;
  end?: ReactNode;
  children: ReactNode;
}

export function InputBox({ size = "md", invalid, disabled, multiline, start, end, children }: InputBoxProps) {
  return (
    <div
      className={cx(
        styles.box,
        multiline ? styles.multiline : styles[size],
        invalid && styles.invalid,
        disabled && styles.disabled
      )}
    >
      {start && <span className={styles.adornment}>{start}</span>}
      {children}
      {end && <span className={styles.adornment}>{end}</span>}
    </div>
  );
}
