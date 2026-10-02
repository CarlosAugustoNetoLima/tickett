"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import { useTranslations } from "next-intl";
import { useModalDismiss, type ModalVariant } from "@/hooks/useModalDismiss";
import { AlertBanner, StickyFooter, SuccessScreen } from "@/components/form";
import { Button } from "@/components/ui/Button";
import { TopBar } from "./TopBar";
import {
  FormStep,
  createInitialData,
  type EventsStatus,
  type ReenviarBilheteData,
} from "./FormStep";
import { Recaptcha, type RecaptchaHandle } from "./Recaptcha";
import { validate } from "./validation";
import { EMAIL_RE } from "@/lib/validation";
import type { ResendEvent } from "@/types/event";
import { cx } from "@/lib/cx";
import { TextLink } from "@/components/ui/TextLink";
import layout from "@/components/form/FormLayout.module.css";
import styles from "@/components/form/FormModal.module.css";

interface ReenviarBilheteModalProps {
  variant?: ModalVariant;
}

const LOOKUP_DEBOUNCE_MS = 400;

export function ReenviarBilheteModal({ variant = "page" }: ReenviarBilheteModalProps) {
  const { close, dialogRef } = useModalDismiss(variant);
  const t = useTranslations("reenviarBilhete");
  const [data, setData] = useState(() => createInitialData());
  const [attempted, setAttempted] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [submitError, setSubmitError] = useState("");

  const [lookup, setLookup] = useState<{
    email: string;
    status: Exclude<EventsStatus, "idle" | "loading">;
    events: ResendEvent[];
  } | null>(null);

  const [recaptchaToken, setRecaptchaToken] = useState("");
  const [recaptchaAvailable, setRecaptchaAvailable] = useState(true);
  const recaptchaRef = useRef<RecaptchaHandle>(null);

  const errors = useMemo(() => (attempted ? validate(data, t) : {}), [attempted, data, t]);
  const showAlert = attempted && Object.keys(errors).length > 0;

  const email = data.email.trim();
  const emailValido = EMAIL_RE.test(email);
  const lookupAtual = lookup?.email === email ? lookup : null;

  const eventsStatus: EventsStatus = !emailValido
    ? "idle"
    : (lookupAtual?.status ?? "loading");
  const events = lookupAtual?.events ?? [];

  useEffect(() => {
    if (!EMAIL_RE.test(email)) return;

    const controller = new AbortController();
    const timer = setTimeout(async () => {
      try {
        const res = await fetch(`/api/reenviar-bilhete/eventos?email=${encodeURIComponent(email)}`, {
          signal: controller.signal,
        });
        const json = await res.json().catch(() => null);

        if (!res.ok || !json?.success) {
          const status = json?.code === "email_not_found" ? "notFound" : "error";
          setLookup({ email, status, events: [] });
          return;
        }

        setLookup({ email, status: "loaded", events: json.events ?? [] });
      } catch (error) {
        if ((error as Error).name === "AbortError") return;
        setLookup({ email, status: "error", events: [] });
      }
    }, LOOKUP_DEBOUNCE_MS);

    return () => {
      controller.abort();
      clearTimeout(timer);
    };
  }, [email]);

  function submitErrorFor(code: unknown, backendMsg: unknown): string {
    switch (code) {
      case "phone_mismatch":
        return t("form.errors.phoneMismatch");
      case "no_purchase":
        return t("form.errors.noPurchase");
      case "send_failed":
        return t("form.errors.sendFailed");
      case "recaptcha_required":
        return t("form.recaptchaRequired");
      case "unknown":
        return typeof backendMsg === "string" && backendMsg ? backendMsg : t("form.submitError");
      default:
        return t("form.submitError");
    }
  }

  function handleDataChange(next: ReenviarBilheteData) {
    const emailMudou = next.email.trim() !== email;
    setData(emailMudou && next.evento ? { ...next, evento: "" } : next);
  }

  async function handleSubmit() {
    const stepErrors = validate(data, t);
    if (Object.keys(stepErrors).length > 0) {
      setAttempted(true);
      return;
    }

    if (recaptchaAvailable && !recaptchaToken) {
      setAttempted(true);
      setSubmitError(t("form.recaptchaRequired"));
      return;
    }

    setAttempted(false);
    setSubmitError("");
    setSubmitting(true);

    try {
      const res = await fetch("/api/reenviar-bilhete", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({
          email,
          mobileCountry: data.telefoneDial,
          cellNumber: data.telefoneNumero.trim(),
          event: data.evento,
          recaptchaToken,
        }),
      });
      const json = await res.json().catch(() => null);

      if (!res.ok || !json?.success) {
        setSubmitError(submitErrorFor(json?.code, json?.msg));
        recaptchaRef.current?.reset();
        return;
      }

      setSubmitted(true);
    } catch {
      setSubmitError(t("form.submitError"));
      recaptchaRef.current?.reset();
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <div ref={dialogRef} tabIndex={-1} className={styles.root} role="dialog" aria-modal="true" aria-label={t("form.heading")}>
      <TopBar onClose={close} />

      {submitted ? (
        <SuccessScreen title={t("success.title")} subtitle={t("success.subtitle")}>
          <Button variant="secondary" onClick={close}>
            {t("success.close")}
          </Button>
        </SuccessScreen>
      ) : (
        <>
          <div className={styles.body}>
            <div className={styles.bodyInner}>
              {showAlert && <AlertBanner message={t("form.alertGeneric")} />}
              {submitError && <AlertBanner message={submitError} />}
              <FormStep
                data={data}
                errors={errors}
                onChange={handleDataChange}
                events={events}
                eventsStatus={eventsStatus}
              />
              <Recaptcha
                ref={recaptchaRef}
                onChange={setRecaptchaToken}
                onUnavailable={() => setRecaptchaAvailable(false)}
              />
              <p className={cx("caption-md-regular", layout.hint)}>
                {t.rich("form.recaptchaNotice", {
                  privacy: (chunks) => <TextLink href="https://policies.google.com/privacy">{chunks}</TextLink>,
                  terms: (chunks) => <TextLink href="https://policies.google.com/terms">{chunks}</TextLink>,
                })}
              </p>
            </div>
          </div>

          <StickyFooter label={t("form.submit")} onClick={handleSubmit} loading={submitting} />
        </>
      )}
    </div>
  );
}
