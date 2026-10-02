"use client";

import { ButtonHTMLAttributes } from "react";
import { Link } from "@/i18n/navigation";
import { cx } from "@/lib/cx";
import styles from "./Chip.module.css";

interface ChipProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  active?: boolean;
  href?: string;
}

export function Chip({ active = false, href, className, children, ...rest }: ChipProps) {
  const classes = cx(styles.chip, "caption-md-medium", active && styles.active, className);

  if (href) {
    return (
      <Link href={href} className={classes}>
        {children}
      </Link>
    );
  }

  return (
    <button className={classes} {...rest}>
      {children}
    </button>
  );
}
