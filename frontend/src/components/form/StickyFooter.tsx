"use client";

import { useTranslations } from "next-intl";
import { Button } from "@/components/ui/Button";
import styles from "./StickyFooter.module.css";

interface StickyFooterProps {
  label: string;
  onClick: () => void;
  loading?: boolean;
  disabled?: boolean;
}

export function StickyFooter({ label, onClick, loading = false, disabled = false }: StickyFooterProps) {
  const t = useTranslations("form");
  return (
    <footer className={styles.bar}>
      <Button className={styles.button} onClick={onClick} disabled={disabled || loading}>
        {loading ? t("submitting") : label}
      </Button>
    </footer>
  );
}
