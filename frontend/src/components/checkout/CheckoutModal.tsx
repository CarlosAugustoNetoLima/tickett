"use client";

import { useEffect } from "react";
import { useModalDismiss, type ModalVariant } from "@/hooks/useModalDismiss";
import styles from "./CheckoutModal.module.css";

interface CheckoutModalProps {
  path: string[];
  variant?: ModalVariant;
}

export function CheckoutModal({ path, variant = "page" }: CheckoutModalProps) {
  const { close, dialogRef } = useModalDismiss(variant);

  useEffect(() => {
    function onMessage(e: MessageEvent) {
      if (e.data === "tkt-close-checkout") close();
    }

    window.addEventListener("message", onMessage);
    return () => window.removeEventListener("message", onMessage);
  }, [close]);

  return (
    <div ref={dialogRef} tabIndex={-1} className={styles.root} role="dialog" aria-modal="true" aria-label="Checkout">
      <iframe src={`/checkout/${path.join("/")}`} className={styles.iframe} title="Checkout" />
    </div>
  );
}
