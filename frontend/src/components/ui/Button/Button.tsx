"use client";

import { ButtonHTMLAttributes } from "react";
import { Link } from "@/i18n/navigation";
import { cx } from "@/lib/cx";
import { Icon, IconName } from "@/components/ui/Icon";
import styles from "./Button.module.css";

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: "primary" | "secondary";
  size?: "default" | "small";
  iconRight?: IconName;
  href?: string;
}

export function Button({
  variant = "primary",
  size = "default",
  iconRight,
  href,
  className,
  children,
  ...rest
}: ButtonProps) {
  const classes = cx(
    styles.button,
    "body-sm-medium",
    styles[variant],
    styles[size],
    className
  );
  const content = (
    <>
      {children}
      {iconRight && (
        <span className={styles.icon}>
          <Icon name={iconRight} size={16} />
        </span>
      )}
    </>
  );

  if (href && /^https?:/.test(href)) {
    return (
      <a href={href} className={classes} target="_blank" rel="noopener noreferrer">
        {content}
      </a>
    );
  }

  if (href) {
    return (
      <Link href={href} className={classes}>
        {content}
      </Link>
    );
  }

  return (
    <button className={classes} {...rest}>
      {content}
    </button>
  );
}
