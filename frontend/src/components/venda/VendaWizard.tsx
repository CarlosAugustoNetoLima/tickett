"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import { useTranslations } from "next-intl";
import { useModalDismiss, type ModalVariant } from "@/hooks/useModalDismiss";
import { TopBar } from "./TopBar";
import { AlertBanner, StickyFooter, SuccessScreen } from "@/components/form";
import { Button } from "@/components/ui/Button";
import { StepPromotor, StepEvento, StepBilhetes, StepRevisao } from "./steps";
import { createInitialFormData, STEPS } from "./types";
import type { VendaFormData, VendaPayload } from "./types";
import { validateStep } from "./validation";
import { buildReceiptText } from "./receipt";
import styles from "@/components/form/FormModal.module.css";

function toPayload(data: VendaFormData): VendaPayload {
  const names = (files: File[]) => files.map((file) => file.name);
  return {
    ...data,
    evento: {
      ...data.evento,
      imagemPrincipal: names(data.evento.imagemPrincipal),
      banner: names(data.evento.banner),
      redesSociais: names(data.evento.redesSociais),
    },
  };
}

interface VendaWizardProps {
  variant?: ModalVariant;
}

export function VendaWizard({ variant = "page" }: VendaWizardProps) {
  const { close, dialogRef } = useModalDismiss(variant);
  const t = useTranslations("venda");
  const [step, setStep] = useState(0);
  const [formData, setFormData] = useState<VendaFormData>(() => createInitialFormData());
  const [attempted, setAttempted] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [submitError, setSubmitError] = useState("");
  const bodyRef = useRef<HTMLDivElement>(null);

  const errors = useMemo(() => (attempted ? validateStep(step, formData, t) : {}), [attempted, step, formData, t]);
  const showAlert = attempted && Object.keys(errors).length > 0;

  useEffect(() => {
    bodyRef.current?.scrollTo({ top: 0 });
  }, [step, submitted]);

  function handleBack() {
    setAttempted(false);
    setStep((s) => Math.max(0, s - 1));
  }

  async function handleContinue() {
    const stepErrors = validateStep(step, formData, t);

    if (Object.keys(stepErrors).length > 0) {
      setAttempted(true);
      return;
    }

    setAttempted(false);

    if (step < STEPS.length - 1) {
      setStep((s) => s + 1);
      return;
    }

    setSubmitting(true);
    setSubmitError("");
    try {
      const res = await fetch("/api/venda", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify(toPayload(formData)),
      });
      const json = await res.json().catch(() => null);
      if (!res.ok || !json?.success) {
        setSubmitError(t("wizard.submitError"));
        return;
      }
      setSubmitted(true);
    } catch {
      setSubmitError(t("wizard.submitError"));
    } finally {
      setSubmitting(false);
    }
  }

  function handleDownload() {
    const text = buildReceiptText(formData, t);
    const blob = new Blob([text], { type: "text/plain;charset=utf-8" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `submissao-evento-${formData.evento.nome || "tickett"}.txt`;
    document.body.appendChild(a);
    a.click();
    a.remove();
    URL.revokeObjectURL(url);
  }

  const footerLabel = step === STEPS.length - 1 ? t("wizard.confirmar") : t("wizard.continuar");

  return (
    <div ref={dialogRef} tabIndex={-1} className={styles.root} role="dialog" aria-modal="true" aria-label={t("wizard.ariaLabel")}>
      <TopBar
        currentStep={step}
        allDone={submitted}
        onBack={!submitted && step > 0 ? handleBack : undefined}
        onClose={close}
      />

      {submitted ? (
        <SuccessScreen title={t("stepSucesso.title")} subtitle={t("stepSucesso.subtitle")}>
          <Button onClick={handleDownload}>{t("stepSucesso.download")}</Button>
          <Button variant="secondary" onClick={close}>
            {t("stepSucesso.close")}
          </Button>
        </SuccessScreen>
      ) : (
        <>
          <div className={styles.body} ref={bodyRef}>
            <div className={styles.bodyInner}>
              {showAlert && <AlertBanner message={t("wizard.alertGeneric")} />}
              {submitError && <AlertBanner message={submitError} />}

              {step === 0 && (
                <StepPromotor
                  data={formData.promotor}
                  errors={errors}
                  onChange={(promotor) => setFormData((f) => ({ ...f, promotor }))}
                />
              )}
              {step === 1 && (
                <StepEvento
                  data={formData.evento}
                  errors={errors}
                  onChange={(evento) => setFormData((f) => ({ ...f, evento }))}
                />
              )}
              {step === 2 && (
                <StepBilhetes
                  data={formData.bilhetes}
                  errors={errors}
                  onChange={(bilhetes) => setFormData((f) => ({ ...f, bilhetes }))}
                />
              )}
              {step === 3 && (
                <StepRevisao
                  data={formData}
                  errors={errors}
                  onToggleAceite={(checked) =>
                    setFormData((f) => ({ ...f, revisao: { aceitaTermos: checked } }))
                  }
                />
              )}
            </div>
          </div>

          <StickyFooter label={footerLabel} onClick={handleContinue} loading={submitting} />
        </>
      )}
    </div>
  );
}
