"use client";

import { useEffect, useState, useSyncExternalStore } from "react";
import { useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import { Button } from "@/components/ui/Button";
import { TextLink } from "@/components/ui/TextLink";
import { CONSENT_COOKIE, CONSENT_MAX_AGE, OPEN_CONSENT_EVENT, type ConsentChoice } from "@/lib/consent";
import styles from "./CookieConsent.module.css";

const CHANGE_EVENT = "tkt:consent-change";

function readChoice(): string | null {
  const match = document.cookie.match(new RegExp(`(?:^|; )${CONSENT_COOKIE}=([^;]*)`));
  return match ? decodeURIComponent(match[1]) : null;
}

function subscribe(onChange: () => void) {
  window.addEventListener(CHANGE_EVENT, onChange);
  return () => window.removeEventListener(CHANGE_EVENT, onChange);
}

export function CookieConsent() {
  const t = useTranslations("consent");
  const choice = useSyncExternalStore(subscribe, readChoice, () => "pending");
  const [reopened, setReopened] = useState(false);

  useEffect(() => {
    const reopen = () => setReopened(true);
    window.addEventListener(OPEN_CONSENT_EVENT, reopen);
    return () => window.removeEventListener(OPEN_CONSENT_EVENT, reopen);
  }, []);

  function choose(value: ConsentChoice) {
    const secure = location.protocol === "https:" ? "; Secure" : "";
    document.cookie = `${CONSENT_COOKIE}=${value}; Max-Age=${CONSENT_MAX_AGE}; Path=/; SameSite=Lax${secure}`;
    setReopened(false);
    window.dispatchEvent(new Event(CHANGE_EVENT));
  }

  if (choice !== null && !reopened) return null;

  return (
    <section className={styles.banner} role="region" aria-labelledby="cookie-consent-title">
      <div className={styles.text}>
        <h2 id="cookie-consent-title" className={cx("body-sm-medium", styles.title)}>
          {t("title")}
        </h2>
        <p className={cx("caption-md-regular", styles.description)}>
          {t("description")}{" "}
          <TextLink href="/cookies">{t("policy")}</TextLink>
        </p>
      </div>
      <div className={styles.actions}>
        <Button variant="secondary" size="small" onClick={() => choose("essential")}>
          {t("reject")}
        </Button>
        <Button variant="primary" size="small" onClick={() => choose("all")}>
          {t("accept")}
        </Button>
      </div>
    </section>
  );
}
