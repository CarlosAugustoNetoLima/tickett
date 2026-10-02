"use client";

import { ButtonHTMLAttributes } from "react";
import { cx } from "@/lib/cx";
import { Icon, IconName } from "@/components/ui/Icon";
import styles from "./MenuItem.module.css";

interface MenuItemProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  label: string;
  selected?: boolean;
  icon?: IconName;
}

export function MenuItem({ label, selected = false, icon, className, ...rest }: MenuItemProps) {
  return (
    <button
      className={cx(styles.item, "body-sm-regular", selected && styles.selected, className)}
      {...rest}
    >
      {icon && (
        <span className={styles.icon}>
          <Icon name={icon} size={14} />
        </span>
      )}
      <span className={styles.label}>{label}</span>
      {selected && (
        <span className={styles.icon}>
          <Icon name="tick" size={14} />
        </span>
      )}
    </button>
  );
}
