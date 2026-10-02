"use client";

import type { ReactNode } from "react";
import { OPEN_CONSENT_EVENT } from "@/lib/consent";

export function CookieSettingsButton({ className, children }: { className?: string; children: ReactNode }) {
  return (
    <button type="button" className={className} onClick={() => window.dispatchEvent(new Event(OPEN_CONSENT_EVENT))}>
      {children}
    </button>
  );
}
