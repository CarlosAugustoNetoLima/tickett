"use client";

import { useState, type FormEvent } from "react";
import { useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import { Icon } from "@/components/ui/Icon";
import { Input, InputAction } from "@/components/ui/Input";
import { TextLink } from "@/components/ui/TextLink";
import { useNewsletterSubscribe } from "@/hooks/useNewsletterSubscribe";
import styles from "./NewsletterForm.module.css";

export function NewsletterForm() {
  const t = useTranslations("footer.columns.newsletter");
  const [email, setEmail] = useState("");
  const { status, message, subscribe, reset } = useNewsletterSubscribe();

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();
    if (await subscribe(email)) setEmail("");
  }

  return (
    <form className={styles.form} onSubmit={handleSubmit} noValidate>
      <span className={cx("caption-md-regular", styles.hint)}>{t("subscribe")}</span>
      <Input
        size="sm"
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
        aria-describedby={message ? "newsletter-feedback" : undefined}
        end={
          <InputAction type="submit" accent disabled={status === "loading"} aria-label={t("submit")}>
            <Icon name="arrow-right" size={16} />
          </InputAction>
        }
      />
      <p className={cx("caption-md-regular", styles.hint)}>
        {t.rich("consent", { link: (chunks) => <TextLink href="/privacidade">{chunks}</TextLink> })}
      </p>
      {message && (
        <p
          id="newsletter-feedback"
          className={cx("caption-md-regular", status === "error" ? styles.error : styles.success)}
          role={status === "error" ? "alert" : "status"}
        >
          {message}
        </p>
      )}
    </form>
  );
}
