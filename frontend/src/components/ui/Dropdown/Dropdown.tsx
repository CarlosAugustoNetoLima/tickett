"use client";

import { ButtonHTMLAttributes } from "react";
import { cx } from "@/lib/cx";
import { Icon } from "@/components/ui/Icon";
import styles from "./Dropdown.module.css";

interface DropdownProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  active?: boolean;
  open?: boolean;
  onClear?: () => void;
  clearLabel?: string;
}

export function Dropdown({ active = false, open = false, onClear, clearLabel, className, children, ...rest }: DropdownProps) {
  const clearable = active && !!onClear;
  return (
    <span className={styles.wrap}>
      <button
        type="button"
        aria-expanded={open}
        aria-haspopup="true"
        className={cx(styles.dropdown, "caption-md-medium", active && styles.active, clearable && styles.clearable, className)}
        {...rest}
      >
        {children}
        <span className={cx(styles.icon, open && styles.iconActive)}>
          <Icon name="arrow-down" size={14} />
        </span>
      </button>
      {clearable && (
        <button type="button" className={styles.clear} onClick={onClear} aria-label={clearLabel}>
          <Icon name="close" size={14} />
        </button>
      )}
    </span>
  );
}
