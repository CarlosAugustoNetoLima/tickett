"use client";

import { useEffect, useRef, useState } from "react";
import { useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import { Icon } from "@/components/ui/Icon";
import { CalendarGrid } from "@/components/ui/CalendarGrid";
import { BottomSheet } from "@/components/layout/BottomSheet";
import { Field, InputButton, useFieldControl } from "@/components/ui/Input";
import { useBreakpoint } from "@/hooks/useBreakpoint";
import styles from "./Field.module.css";

interface DateFieldProps {
  id?: string;
  label?: string;
  required?: boolean;
  optional?: boolean;
  error?: string;
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
}

const POPOVER_HEIGHT_ESTIMATE = 400;

function formatDisplay(iso: string) {
  const [y, m, d] = iso.split("-");
  return `${d}/${m}/${y}`;
}

export function DateField({
  id,
  label,
  required,
  optional,
  error,
  value,
  onChange,
  placeholder = "dd/mm/yyyy",
}: DateFieldProps) {
  const t = useTranslations("form.fields");
  const control = useFieldControl({ id, error, required });
  const { isMobile } = useBreakpoint();
  const [open, setOpen] = useState(false);
  const [placement, setPlacement] = useState<"below" | "above">("below");
  const [viewYear, setViewYear] = useState(() => (value ? Number(value.slice(0, 4)) : new Date().getFullYear()));
  const [viewMonth, setViewMonth] = useState(() => (value ? Number(value.slice(5, 7)) - 1 : new Date().getMonth()));
  const wrapRef = useRef<HTMLDivElement>(null);
  const triggerRef = useRef<HTMLButtonElement>(null);

  useEffect(() => {
    if (!open || isMobile) return;

    function onClickOutside(e: MouseEvent) {
      if (wrapRef.current && !wrapRef.current.contains(e.target as Node)) setOpen(false);
    }
    function onKeyDown(e: KeyboardEvent) {
      if (e.key === "Escape") setOpen(false);
    }
    document.addEventListener("mousedown", onClickOutside);
    document.addEventListener("keydown", onKeyDown);
    return () => {
      document.removeEventListener("mousedown", onClickOutside);
      document.removeEventListener("keydown", onKeyDown);
    };
  }, [open, isMobile]);

  function changeMonth(delta: number) {
    const next = new Date(viewYear, viewMonth + delta, 1);
    setViewYear(next.getFullYear());
    setViewMonth(next.getMonth());
  }

  function toggle() {
    if (!open) {
      if (value) {
        setViewYear(Number(value.slice(0, 4)));
        setViewMonth(Number(value.slice(5, 7)) - 1);
      }
      const rect = triggerRef.current?.getBoundingClientRect();
      if (rect) {
        const spaceBelow = window.innerHeight - rect.bottom;
        setPlacement(spaceBelow < POPOVER_HEIGHT_ESTIMATE ? "above" : "below");
      }
    }
    setOpen((o) => !o);
  }

  function handleDayClick(iso: string) {
    onChange(iso);
    setOpen(false);
  }

  const calendar = (
    <CalendarGrid
      year={viewYear}
      month={viewMonth}
      startDate={value}
      endDate={value}
      onPrevMonth={() => changeMonth(-1)}
      onNextMonth={() => changeMonth(1)}
      onDayClick={handleDayClick}
    />
  );

  return (
    <Field id={control.id} label={label} required={required} optional={optional} error={error}>
      <div className={styles.datePopoverWrap} ref={wrapRef}>
        <InputButton
          ref={triggerRef}
          {...control}
          invalid={!!error}
          empty={!value}
          end={<Icon name="calendar" size={16} />}
          aria-haspopup="dialog"
          aria-expanded={open}
          onClick={toggle}
        >
          {value ? formatDisplay(value) : placeholder}
        </InputButton>
        {!isMobile && open && (
          <div className={cx(styles.datePopover, placement === "above" && styles.datePopoverAbove)}>
            {calendar}
          </div>
        )}
      </div>
      {isMobile && (
        <BottomSheet open={open} title={label || t("escolherData")} onClose={() => setOpen(false)}>
          <div className={styles.dateSheetContent}>{calendar}</div>
        </BottomSheet>
      )}
    </Field>
  );
}
