import type { useTranslations } from "next-intl";
import type { ReenviarBilheteData, ReenviarBilheteErrors } from "./FormStep";
import { EMAIL_RE, isValidPhone } from "@/lib/validation";

type ReenviarBilheteT = ReturnType<typeof useTranslations<"reenviarBilhete">>;

export function validate(data: ReenviarBilheteData, t: ReenviarBilheteT): ReenviarBilheteErrors {
  const errors: ReenviarBilheteErrors = {};

  if (!data.email.trim()) {
    errors.email = t("validation.email");
  } else if (!EMAIL_RE.test(data.email.trim())) {
    errors.email = t("validation.emailFormato");
  }

  if (!data.telefoneNumero.trim()) {
    errors.telefoneNumero = t("validation.telefone");
  } else if (!isValidPhone(data.telefoneDial, data.telefoneNumero)) {
    errors.telefoneNumero = t("validation.telefoneFormato");
  }

  if (!data.evento) errors.evento = t("validation.evento");

  return errors;
}
