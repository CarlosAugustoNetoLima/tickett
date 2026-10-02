"use client";

import { useLocale, useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import { Icon } from "@/components/ui/Icon";
import { Button } from "@/components/ui/Button";
import { CalendarGrid } from "@/components/ui/CalendarGrid";
import { formatRangeSummary } from "@/lib/calendar";
import type { DateRangeDraft } from "@/hooks/useEventosFilters";
import styles from "./DatePickerPanel.module.css";

interface DatePickerPanelProps {
  calendar: DateRangeDraft;
  onApply: () => void;
  onClear: () => void;
  variant?: "panel" | "sheet";
}

export function DatePickerPanel({ calendar, onApply, onClear, variant = "panel" }: DatePickerPanelProps) {
  const locale = useLocale();
  const t = useTranslations("filters");
  const sheet = variant === "sheet";

  return (
    <div className={cx(styles.picker, sheet ? styles.sheet : styles.panel)}>
      <CalendarGrid
        year={calendar.year}
        month={calendar.month}
        startDate={calendar.start}
        endDate={calendar.end}
        onPrevMonth={() => calendar.changeMonth(-1)}
        onNextMonth={() => calendar.changeMonth(1)}
        onDayClick={calendar.pickDay}
        compact={sheet}
      />

      <div className={styles.divider} />

      <div className={styles.footer}>
        <div className={styles.rangeSummary}>
          <span className={styles.rangeIcon}>
            <Icon name="calendar" size={14} />
          </span>
          <p className="body-sm-medium">
            <span className={styles.rangeLabel}>{t("period")}</span>
            <span className={styles.rangeValue}>
              {formatRangeSummary(locale, calendar.start, calendar.end) ?? t("selectPeriod")}
            </span>
          </p>
        </div>
        <div className={styles.actions}>
          <Button variant="secondary" onClick={onClear}>
            {t("clear")}
          </Button>
          <Button variant="primary" onClick={onApply} className={styles.apply}>
            {t("apply")}
          </Button>
        </div>
      </div>
    </div>
  );
}
