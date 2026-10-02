"use client";

import { useEffect, useRef, useState, type PointerEvent as ReactPointerEvent, type ReactNode } from "react";
import { useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import { Icon } from "@/components/ui/Icon";
import { useFocusTrap } from "@/hooks/useFocusTrap";
import styles from "./BottomSheet.module.css";

interface BottomSheetProps {
  open: boolean;
  title: string;
  onClose: () => void;
  onBack?: () => void;
  children: ReactNode;
}

const DISMISS_THRESHOLD = 100;

export function BottomSheet({ open, title, onClose, onBack, children }: BottomSheetProps) {
  const t = useTranslations("bottomSheet");
  const [dragY, setDragY] = useState(0);
  const [dragging, setDragging] = useState(false);
  const dragStartY = useRef(0);
  const sheetRef = useFocusTrap<HTMLDivElement>(open);

  useEffect(() => {
    if (!open) return;

    document.body.style.overflow = "hidden";
    function onKeyDown(e: KeyboardEvent) {
      if (e.key === "Escape") onClose();
    }
    document.addEventListener("keydown", onKeyDown);

    return () => {
      document.body.style.overflow = "";
      document.removeEventListener("keydown", onKeyDown);
    };
  }, [open, onClose]);

  const [wasOpen, setWasOpen] = useState(open);
  if (wasOpen !== open) {
    setWasOpen(open);
    if (!open) {
      setDragY(0);
      setDragging(false);
    }
  }

  function handleDragStart(e: ReactPointerEvent) {
    dragStartY.current = e.clientY;
    setDragging(true);
    try {
      e.currentTarget.setPointerCapture(e.pointerId);
    } catch {
    }
  }

  function handleDragMove(e: ReactPointerEvent) {
    if (!dragging) return;
    setDragY(Math.max(0, e.clientY - dragStartY.current));
  }

  function handleDragEnd() {
    if (!dragging) return;
    setDragging(false);
    if (dragY > DISMISS_THRESHOLD) onClose();
    setDragY(0);
  }

  return (
    <div className={cx(styles.overlay, open && styles.overlayOpen)} onClick={onClose} aria-hidden={!open}>
      <div
        ref={sheetRef}
        tabIndex={-1}
        className={cx(styles.sheet, open && styles.sheetOpen)}
        onClick={(e) => e.stopPropagation()}
        role="dialog"
        aria-modal="true"
        aria-label={title}
        style={dragging ? { transform: `translateY(${dragY}px)`, transition: "none" } : undefined}
      >
        <div
          className={styles.dragArea}
          onPointerDown={handleDragStart}
          onPointerMove={handleDragMove}
          onPointerUp={handleDragEnd}
          onPointerCancel={handleDragEnd}
        >
          <div className={styles.handleRow}>
            <div className={styles.handle} />
          </div>
          <div className={styles.header}>
            <button className={styles.backButton} onClick={onBack ?? onClose} aria-label={t("back")}>
              <Icon name="arrow-left" size={24} />
            </button>
            <p className={cx("body-lg-bold", styles.title)}>{title}</p>
            <span className={styles.headerSpacer} aria-hidden="true" />
          </div>
        </div>
        <div className={styles.divider} />
        <div className={styles.content}>{children}</div>
      </div>
    </div>
  );
}
