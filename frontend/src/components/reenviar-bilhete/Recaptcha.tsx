"use client";

import { forwardRef, useEffect, useImperativeHandle, useRef, useState } from "react";

const SITE_KEY =
  process.env.NEXT_PUBLIC_RECAPTCHA_SITE_KEY ?? "6LdaXS8hAAAAAGBeS8IKALufNPJdfilxDgs1t_m2";

const SCRIPT_ID = "recaptcha-api-js";
const CALLBACK_NAME = "__tickettRecaptchaOnLoad";
// O load do <script> dispara antes de grecaptcha.render existir; só o callback onload= garante que já existe.
const SCRIPT_SRC = `https://www.google.com/recaptcha/api.js?render=explicit&onload=${CALLBACK_NAME}`;

interface GreCaptcha {
  render: (
    container: HTMLElement,
    params: {
      sitekey: string;
      theme?: "light" | "dark";
      callback: (token: string) => void;
      "expired-callback": () => void;
      "error-callback": () => void;
    }
  ) => number;
  reset: (widgetId?: number) => void;
}

declare global {
  interface Window {
    grecaptcha?: Partial<GreCaptcha>;
    __tickettRecaptchaOnLoad?: () => void;
  }
}

let readyPromise: Promise<void> | null = null;

function loadRecaptcha(): Promise<void> {
  if (typeof window === "undefined") return Promise.resolve();
  if (window.grecaptcha?.render) return Promise.resolve();
  if (readyPromise) return readyPromise;

  readyPromise = new Promise<void>((resolve, reject) => {
    window.__tickettRecaptchaOnLoad = () => resolve();

    const script = document.createElement("script");
    script.id = SCRIPT_ID;
    script.src = SCRIPT_SRC;
    script.async = true;
    script.defer = true;
    script.addEventListener("error", () => {
      readyPromise = null;
      reject(new Error("recaptcha_script_failed"));
    });
    document.head.appendChild(script);
  });

  return readyPromise;
}

export interface RecaptchaHandle {
  reset: () => void;
}

interface RecaptchaProps {
  onChange: (token: string) => void;
  onUnavailable?: () => void;
}

export const Recaptcha = forwardRef<RecaptchaHandle, RecaptchaProps>(function Recaptcha(
  { onChange, onUnavailable },
  ref
) {
  const containerRef = useRef<HTMLDivElement>(null);
  const widgetIdRef = useRef<number | null>(null);
  const [failed, setFailed] = useState(false);

  const onChangeRef = useRef(onChange);
  const onUnavailableRef = useRef(onUnavailable);
  onChangeRef.current = onChange;
  onUnavailableRef.current = onUnavailable;

  useEffect(() => {
    let cancelled = false;

    loadRecaptcha()
      .then(() => {
        if (cancelled || !containerRef.current || widgetIdRef.current !== null) return;
        const render = window.grecaptcha?.render;
        if (!render) throw new Error("recaptcha_unavailable");

        widgetIdRef.current = render(containerRef.current, {
          sitekey: SITE_KEY,
          theme: "dark",
          callback: (token) => onChangeRef.current(token),
          "expired-callback": () => onChangeRef.current(""),
          "error-callback": () => onChangeRef.current(""),
        });
      })
      .catch(() => {
        if (cancelled) return;
        setFailed(true);
        onUnavailableRef.current?.();
      });

    return () => {
      cancelled = true;
    };
  }, []);

  useImperativeHandle(ref, () => ({
    reset: () => {
      if (widgetIdRef.current !== null) {
        window.grecaptcha?.reset?.(widgetIdRef.current);
      }
      onChangeRef.current("");
    },
  }));

  if (failed) return null;

  return <div ref={containerRef} />;
});
