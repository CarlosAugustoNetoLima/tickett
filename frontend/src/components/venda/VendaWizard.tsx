"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import { useTranslations } from "next-intl";
import { useModalDismiss, type ModalVariant } from "@/hooks/useModalDismiss";
import { TopBar } from "./TopBar";
import { AlertBanner, StickyFooter, SuccessScreen } from "@/components/form";
import { Button } from "@/components/ui/Button";
import { StepPromotor, StepEvento, StepBilhetes, StepRevisao } from "./steps";
import { createInitialFormData, STEPS } from "./types";
import type { VendaFormData } from "./types";
import { totalLotacao, validateStep } from "./validation";
import { buildReceiptText } from "./receipt";
import { Recaptcha, type RecaptchaHandle } from "@/components/reenviar-bilhete/Recaptcha";
import styles from "@/components/form/FormModal.module.css";

// Os selects do modal da lebillet.eu enviam o texto pronto para o e-mail.
// Aqui as opções são chaves i18n, então mapeamos para o mesmo texto (o e-mail é sempre em PT).
const CATEGORIA_LABELS: Record<string, string> = {
  concerto: "Concerto",
  festival: "Festival",
  teatro: "Teatro",
  comedia: "Comédia",
  desporto: "Desporto",
  conferencia: "Conferência",
  workshop: "Workshop",
  familia: "Família",
  outro: "Outro",
};

const RESTRICAO_IDADE_LABELS: Record<string, string> = {
  "todas-idades": "Todas as idades",
  m3: "M/3",
  m6: "M/6",
  m12: "M/12",
  m16: "M/16",
  m18: "M/18",
};

const CARACTERISTICA_LABELS: Record<string, string> = {
  "lugares-marcados": "Lugares marcados",
  "acessos-especiais": "Acessos especiais / mobilidade reduzida",
  descontos: "Descontos / promoções",
};

function buildBilhetesText(data: VendaFormData): string {
  const linhas: string[] = [];
  data.bilhetes.tickets.forEach((ticket) => {
    if (!ticket.nome.trim()) return;
    const lotes = ticket.lotes
      .filter((l) => l.preco || l.quantidade)
      .map((l) => {
        const loteNome = l.lote.trim() ? `${l.lote.trim()} — ` : "";
        const preco = l.preco || "0.00";
        const qtd = l.quantidade || "0";
        return `${loteNome}${preco} € × ${qtd}`;
      })
      .join("; ");
    linhas.push(`${ticket.nome.trim()}: ${lotes || "—"}`);
  });
  return linhas.join(" | ");
}

function toFormData(data: VendaFormData, recaptchaToken: string): FormData {
  const fd = new FormData();

  // Promotor — mesmos nomes de campo do modal da lebillet.eu
  fd.append("name", data.promotor.nomeResponsavel.trim());
  fd.append("email", data.promotor.email.trim());
  fd.append(
    "phone",
    data.promotor.telefoneNumero.trim()
      ? `${data.promotor.telefoneDial} ${data.promotor.telefoneNumero.trim()}`.trim()
      : ""
  );
  fd.append("subject", data.promotor.entidade.trim());
  fd.append("promotorNif", data.promotor.nif.trim());
  fd.append("promotorWebsite", data.promotor.website.trim());

  // Evento
  fd.append("eventoNome", data.evento.nome.trim());
  fd.append(
    "eventoCategoria",
    CATEGORIA_LABELS[data.evento.categoria] ?? data.evento.categoria
  );
  fd.append("message", data.evento.descricao.trim());
  fd.append("eventoDataInicio", data.evento.dataEvento);
  fd.append("eventoAberturaPortas", data.evento.aberturaPortas);
  fd.append("eventoHoraInicio", data.evento.horaInicio);
  fd.append("vendasFim", data.evento.fimVendasData);
  fd.append("vendasFimHora", data.evento.fimVendasHora);
  fd.append("eventoLocal", data.evento.recinto.trim());
  fd.append("eventoMorada", data.evento.morada.trim());
  fd.append("eventoCidade", data.evento.cidade.trim());
  fd.append("eventoPais", data.evento.pais);

  // Bilhética
  fd.append("bilhetes", buildBilhetesText(data));
  fd.append("lotacaoTotal", String(totalLotacao(data.bilhetes)));
  fd.append(
    "idadeRestricao",
    RESTRICAO_IDADE_LABELS[data.bilhetes.restricaoIdade] ?? data.bilhetes.restricaoIdade
  );
  fd.append(
    "caracteristicas",
    data.bilhetes.caracteristicas
      .map((c) => CARACTERISTICA_LABELS[c] ?? c)
      .filter(Boolean)
      .join(", ")
  );
  fd.append("mobilidadeLotacao", data.bilhetes.lotacaoMobReduzida.trim());
  fd.append("descontos", "");
  fd.append("observacoes", data.bilhetes.observacoes.trim());

  // Anexos — mesmos nomes de campo do modal da lebillet.eu
  if (data.evento.imagemPrincipal[0]) {
    fd.append("imgPrincipal", data.evento.imagemPrincipal[0], data.evento.imagemPrincipal[0].name);
  }
  if (data.evento.banner[0]) {
    fd.append("imgBanner", data.evento.banner[0], data.evento.banner[0].name);
  }
  data.evento.redesSociais.forEach((f) => {
    fd.append("mediaSocial[]", f, f.name);
  });

  // O backend do lebillet.eu exige o token reCAPTCHA no mesmo campo do modal original
  fd.append("g-recaptcha-response", recaptchaToken);

  return fd;
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
  const [recaptchaToken, setRecaptchaToken] = useState("");
  const [recaptchaAvailable, setRecaptchaAvailable] = useState(true);
  const bodyRef = useRef<HTMLDivElement>(null);
  const recaptchaRef = useRef<RecaptchaHandle>(null);

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

    if (recaptchaAvailable && !recaptchaToken) {
      setSubmitError(t("wizard.recaptchaRequired"));
      return;
    }

    setSubmitting(true);
    setSubmitError("");
    try {
      const fd = toFormData(formData, recaptchaToken);
      const res = await fetch("/api/venda", {
        method: "POST",
        body: fd,
      });
      const json = await res.json().catch(() => null);
      if (!res.ok || !json?.success) {
        setSubmitError(t("wizard.submitError"));
        recaptchaRef.current?.reset();
        setRecaptchaToken("");
        return;
      }
      setSubmitted(true);
    } catch {
      setSubmitError(t("wizard.submitError"));
      recaptchaRef.current?.reset();
      setRecaptchaToken("");
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
                <>
                  <StepRevisao
                    data={formData}
                    errors={errors}
                    onToggleAceite={(checked) =>
                      setFormData((f) => ({ ...f, revisao: { aceitaTermos: checked } }))
                    }
                  />
                  <Recaptcha
                    ref={recaptchaRef}
                    onChange={setRecaptchaToken}
                    onUnavailable={() => setRecaptchaAvailable(false)}
                  />
                </>
              )}
            </div>
          </div>

          <StickyFooter label={footerLabel} onClick={handleContinue} loading={submitting} />
        </>
      )}
    </div>
  );
}
