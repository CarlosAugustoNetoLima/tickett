"use client";

import { Suspense, useEffect, useId, useRef, useState } from "react";
import { useSearchParams } from "next/navigation";
import { useLocale, useTranslations } from "next-intl";
import { usePathname, useRouter } from "@/i18n/navigation";
import { locales, localeLabels, type Locale } from "@/i18n/routing";
import { cx } from "@/lib/cx";
import styles from "./LocaleSwitcher.module.css";

interface LocaleSwitcherProps {
  variant?: "desktop" | "mobile";
}

export function LocaleSwitcher(props: LocaleSwitcherProps) {
  return (
    <Suspense fallback={null}>
      <LocaleSwitcherInner {...props} />
    </Suspense>
  );
}

function LocaleSwitcherInner({ variant = "desktop" }: LocaleSwitcherProps) {
  const locale = useLocale() as Locale;
  const t = useTranslations("localeSwitcher");
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const rootRef = useRef<HTMLDivElement>(null);
  const triggerRef = useRef<HTMLButtonElement>(null);
  const menuId = useId();

  useEffect(() => {
    function onClickOutside(e: MouseEvent) {
      if (rootRef.current && !rootRef.current.contains(e.target as Node)) {
        setOpen(false);
      }
    }
    function onKeyDown(e: KeyboardEvent) {
      if (e.key === "Escape" && rootRef.current?.contains(document.activeElement)) {
        setOpen(false);
        triggerRef.current?.focus();
      }
    }
    document.addEventListener("mousedown", onClickOutside);
    document.addEventListener("keydown", onKeyDown);
    return () => {
      document.removeEventListener("mousedown", onClickOutside);
      document.removeEventListener("keydown", onKeyDown);
    };
  }, []);

  function selectLocale(next: Locale) {
    setOpen(false);
    if (next === locale) return;
    const query = searchParams.toString();
    router.replace(query ? `${pathname}?${query}` : pathname, { locale: next });
  }

  const current = localeLabels[locale];

  return (
    <div className={cx(styles.root, variant === "mobile" && styles.mobile)} ref={rootRef}>
      <button
        ref={triggerRef}
        type="button"
        className={cx(styles.trigger, "body-sm-medium")}
        onClick={() => setOpen((v) => !v)}
        aria-expanded={open}
        aria-controls={menuId}
      >
        <span className="sr-only">{t("label")}: </span>
        <span className={styles.flag} aria-hidden="true">
          {current.flag}
        </span>
        <span className={styles.code}>{current.code}</span>
      </button>

      {open && (
        <ul id={menuId} className={styles.menu}>
          {locales.map((loc) => (
            <li key={loc}>
              <button
                type="button"
                lang={loc}
                aria-current={loc === locale ? "true" : undefined}
                className={cx(styles.option, "body-sm-regular", loc === locale && styles.optionActive)}
                onClick={() => selectLocale(loc)}
              >
                <span className={styles.flag} aria-hidden="true">
                  {localeLabels[loc].flag}
                </span>
                {localeLabels[loc].name}
              </button>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
