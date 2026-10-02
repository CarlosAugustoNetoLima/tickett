"use client";

import { useCallback, useEffect } from "react";
import { useRouter } from "@/i18n/navigation";
import { useFocusTrap } from "./useFocusTrap";

export type ModalVariant = "page" | "modal";

export function useModalDismiss(variant: ModalVariant) {
  const router = useRouter();
  const dialogRef = useFocusTrap<HTMLDivElement>(true);

  const close = useCallback(() => {
    if (variant === "modal") {
      router.back();
    } else {
      router.push("/");
    }
  }, [router, variant]);

  useEffect(() => {
    document.body.style.overflow = "hidden";

    function onKeyDown(e: KeyboardEvent) {
      if (e.key === "Escape") close();
    }

    document.addEventListener("keydown", onKeyDown);
    return () => {
      document.body.style.overflow = "";
      document.removeEventListener("keydown", onKeyDown);
    };
  }, [close]);

  return { close, dialogRef };
}
