"use client";

import { useState, type FormEvent } from "react";
import { useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import { Icon } from "@/components/ui/Icon";
import { Button } from "@/components/ui/Button";
import { Input } from "@/components/ui/Input";
import { TextLink } from "@/components/ui/TextLink";
import { useNewsletterSubscribe } from "@/hooks/useNewsletterSubscribe";
import styles from "./AlertasWhatsapp.module.css";

export function AlertasWhatsapp() {
  const t = useTranslations("home.alertas");
  const [email, setEmail] = useState("");
  const { status, message, subscribe, reset } = useNewsletterSubscribe();

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();
    if (await subscribe(email)) setEmail("");
  }

  return (
    <section className={styles.section}>
      <div className={styles.banner}>
        <div className={styles.left}>
          <span className={styles.chip}>
            <Icon name="sms" size={28} />
          </span>
          <div className={styles.ltext}>
            <h2 className={cx("heading-h5", styles.title)}>{t("title")}</h2>
            <p className={cx("body-sm-regular", styles.description)}>{t("description")}</p>
          </div>
        </div>

        <form className={styles.right} onSubmit={handleSubmit} noValidate>
          <div className={styles.inputRow}>
            <div className={styles.field}>
              <Input
                type="email"
                autoComplete="email"
                inputMode="email"
                aria-label={t("placeholder")}
                placeholder={t("placeholder")}
                value={email}
                onChange={(e) => {
                  setEmail(e.target.value);
                  reset();
                }}
                invalid={status === "error"}
                aria-describedby="alertas-feedback"
              />
            </div>
            <Button type="submit" disabled={status === "loading"}>
              {t("button")}
            </Button>
          </div>
          {message ? (
            <span
              id="alertas-feedback"
              className={cx("caption-md-regular", styles.message, status === "error" ? styles.error : styles.success)}
              role={status === "error" ? "alert" : "status"}
            >
              {message}
            </span>
          ) : (
            <span id="alertas-feedback" className={cx("caption-md-regular", styles.disclaimer)}>
              {t.rich("disclaimer", { link: (chunks) => <TextLink href="/privacidade">{chunks}</TextLink> })}
            </span>
          )}
        </form>
      </div>
    </section>
  );
}
