"use client";

import { useEffect, useRef, useState, type FormEvent } from "react";
import { useTranslations } from "next-intl";
import { Link, useRouter } from "@/i18n/navigation";
import { cx } from "@/lib/cx";
import { Icon } from "@/components/ui/Icon";
import { Button } from "@/components/ui/Button";
import { Input } from "@/components/ui/Input";
import { LocaleSwitcher } from "@/components/layout/LocaleSwitcher";
import { buildEventosUrl, normalizeSearchQuery, SEARCH_MAX_LENGTH } from "@/lib/eventos-filters";
import styles from "./MobileNavbar.module.css";

type Panel = "search" | "menu" | null;

const MENU_LINKS = [
  { href: "/eventos", key: "eventos" },
  { href: "/venda", key: "venda" },
  { href: "/reenviar-bilhete", key: "reenviarBilhete" },
] as const;

export function MobileNavbar() {
  const t = useTranslations("mobileMenu");
  const router = useRouter();
  const [panel, setPanel] = useState<Panel>(null);
  const searchRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    if (!panel) return;
    function onKeyDown(e: KeyboardEvent) {
      if (e.key === "Escape") setPanel(null);
    }
    document.addEventListener("keydown", onKeyDown);
    return () => document.removeEventListener("keydown", onKeyDown);
  }, [panel]);

  function toggle(next: Exclude<Panel, null>) {
    setPanel((current) => (current === next ? null : next));
  }

  function handleSearchSubmit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const busca = normalizeSearchQuery(searchRef.current?.value ?? "");
    if (busca) router.push(buildEventosUrl({ busca }));
  }

  return (
    <header className={styles.navbar}>
      <div className={styles.row}>
        <Link href="/" className={styles.logo}>
          <img className={styles.logoImg} src="/brand/logo.png" alt="Tickett.com" />
        </Link>

        <div className={styles.spacer}>
          <button
            className={styles.iconButton}
            aria-label={t("searchAria")}
            aria-expanded={panel === "search"}
            aria-controls="mobile-search"
            onClick={() => toggle("search")}
          >
            <Icon name="search-normal" size={16} />
          </button>
        </div>

        <button
          className={styles.hamburger}
          aria-label={t("menuAria")}
          aria-expanded={panel === "menu"}
          aria-controls="mobile-menu"
          onClick={() => toggle("menu")}
        >
          <Icon name="menu" size={16} />
        </button>
      </div>

      {panel === "search" && (
        <form id="mobile-search" className={styles.searchRow} onSubmit={handleSearchSubmit} role="search">
          <Input
            ref={searchRef}
            size="sm"
            type="search"
            enterKeyHint="search"
            aria-label={t("searchAria")}
            placeholder={t("searchPlaceholder")}
            maxLength={SEARCH_MAX_LENGTH}
            autoFocus
          />
          <Button type="submit" size="small" className={styles.searchButton}>
            <Icon name="search-normal" size={16} />
            {t("go")}
          </Button>
        </form>
      )}

      {panel === "menu" && (
        <nav id="mobile-menu" className={styles.menuPanel} aria-label={t("menuAria")}>
          {MENU_LINKS.map((item) => (
            <Link key={item.href} href={item.href} className={cx(styles.menuItem, "body-sm-regular")}>
              {t(item.key)}
            </Link>
          ))}
          <LocaleSwitcher variant="mobile" />
        </nav>
      )}
    </header>
  );
}
