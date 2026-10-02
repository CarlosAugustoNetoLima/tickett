"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import { EMAIL_RE } from "@/lib/validation";

type NewsletterStatus = "idle" | "loading" | "success" | "error";

export function useNewsletterSubscribe() {
  const t = useTranslations("footer.columns.newsletter");
  const [status, setStatus] = useState<NewsletterStatus>("idle");
  const [message, setMessage] = useState("");

  async function subscribe(rawEmail: string): Promise<boolean> {
    if (status === "loading") return false;

    const email = rawEmail.trim();
    if (!EMAIL_RE.test(email)) {
      setStatus("error");
      setMessage(t("invalid"));
      return false;
    }

    setStatus("loading");
    setMessage("");

    try {
      const res = await fetch("/api/newsletter", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ email }),
      });
      const json = await res.json().catch(() => null);

      if (!res.ok || !json?.success) {
        setStatus("error");
        setMessage(t("error"));
        return false;
      }

      setStatus("success");
      setMessage(t("success"));
      return true;
    } catch {
      setStatus("error");
      setMessage(t("error"));
      return false;
    }
  }

  function reset() {
    if (status !== "idle") {
      setStatus("idle");
      setMessage("");
    }
  }

  return { status, message, subscribe, reset };
}
