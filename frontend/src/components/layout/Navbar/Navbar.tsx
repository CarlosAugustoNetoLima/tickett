"use client";

import { useRef, type FormEvent } from "react";
import { useTranslations } from "next-intl";
import { Link, usePathname, useRouter } from "@/i18n/navigation";
import { cx } from "@/lib/cx";
import { Icon } from "@/components/ui/Icon";
import { Input, InputAction } from "@/components/ui/Input";
import { LocaleSwitcher } from "@/components/layout/LocaleSwitcher";
import { buildEventosUrl, normalizeSearchQuery, SEARCH_MAX_LENGTH } from "@/lib/eventos-filters";
import { FilterBar, type FilterBarProps } from "./FilterBar";
import styles from "./Navbar.module.css";

const NAV_LINKS = [
  { href: "/eventos", key: "eventos" },
  { href: "/venda", key: "venda" },
  { href: "/reenviar-bilhete", key: "reenviarBilhete" },
] as const;

interface NavbarProps {
  filterBar?: FilterBarProps;
}

export function Navbar({ filterBar }: NavbarProps) {
  const t = useTranslations("nav");
  const pathname = usePathname();
  const router = useRouter();
  const searchRef = useRef<HTMLInputElement>(null);
  const activeBusca = filterBar?.filters.busca ?? null;

  function search(busca: string | null) {
    router.push(buildEventosUrl({ ...filterBar?.filters, busca }));
  }

  function handleSearchSubmit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const busca = normalizeSearchQuery(searchRef.current?.value ?? "");
    if (busca) search(busca);
  }

  function clearSearch() {
    if (searchRef.current) searchRef.current.value = "";
    search(null);
  }

  return (
    <header className={styles.navbar}>
      <div className={styles.row}>
        <Link href="/" className={styles.logo}>
          <img className={styles.logoImg} src="/brand/logo.png" alt="Tickett.com" />
        </Link>

        <form key={activeBusca} className={styles.search} onSubmit={handleSearchSubmit} role="search">
          <Input
            ref={searchRef}
            size="sm"
            type="search"
            enterKeyHint="search"
            aria-label={t("searchAria")}
            placeholder={t("searchPlaceholder")}
            defaultValue={activeBusca ?? ""}
            maxLength={SEARCH_MAX_LENGTH}
            start={
              <InputAction type="submit" aria-label={t("searchAria")}>
                <Icon name="search-normal" size={16} />
              </InputAction>
            }
            end={
              activeBusca && (
                <InputAction onClick={clearSearch} aria-label={t("clearSearchAria")}>
                  <Icon name="close" size={14} />
                </InputAction>
              )
            }
          />
        </form>

        <nav className={styles.links}>
          {NAV_LINKS.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              className={cx(styles.link, "body-sm-medium", pathname?.startsWith(item.href) && styles.linkActive)}
            >
              {t(item.key)}
            </Link>
          ))}
        </nav>

        <LocaleSwitcher />
      </div>

      {filterBar && <FilterBar {...filterBar} />}
    </header>
  );
}
