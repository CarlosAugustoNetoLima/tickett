"use client";

import { useTranslations } from "next-intl";
import { Link } from "@/i18n/navigation";
import { Icon } from "@/components/ui/Icon";
import styles from "./TopBar.module.css";

interface TopBarProps {
  onClose: () => void;
}

export function TopBar({ onClose }: TopBarProps) {
  const t = useTranslations("reenviarBilhete.topBar");

  return (
    <header className={styles.wrap}>
      <Link href="/" className={styles.logo} aria-label="Tickett.com">
        <img className={styles.logoImg} src="/brand/logo.png" alt="Tickett.com" />
      </Link>

      <div className={styles.right}>
        <button type="button" className={styles.close} onClick={onClose} aria-label={t("close")}>
          <span className={styles.closeIcon}>
            <Icon name="x" size={32} />
          </span>
        </button>
      </div>
    </header>
  );
}
