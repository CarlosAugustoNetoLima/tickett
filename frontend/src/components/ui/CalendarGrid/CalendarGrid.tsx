"use client";

import { useLocale, useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import { Icon } from "@/components/ui/Icon";
import { getWeekdays, getMonths, buildWeeks } from "@/lib/calendar";
import styles from "./CalendarGrid.module.css";

interface CalendarGridProps {
  year: number;
  month: number;
  startDate?: string | null;
  endDate?: string | null;
  onPrevMonth?: () => void;
  onNextMonth?: () => void;
  onDayClick?: (iso: string) => void;
  compact?: boolean;
}

export function CalendarGrid({
  year,
  month,
  startDate,
  endDate,
  onPrevMonth,
  onNextMonth,
  onDayClick,
  compact = false,
}: CalendarGridProps) {
  const locale = useLocale();
  const t = useTranslations("filters");
  const weeks = buildWeeks(year, month, startDate, endDate);
  const monthLabel = `${getMonths(locale)[month]} ${year}`;

  return (
    <div className={cx(styles.wrap, compact && styles.compact)}>
      <div className={styles.header}>
        <button type="button" className={styles.navButton} onClick={onPrevMonth} aria-label={t("prevMonth")}>
          <Icon name="arrow-left" size={16} />
        </button>
        <p className={cx("body-sm-medium", styles.monthLabel)}>{monthLabel}</p>
        <button type="button" className={styles.navButton} onClick={onNextMonth} aria-label={t("nextMonth")}>
          <Icon name="arrow-right" size={16} />
        </button>
      </div>

      <div className={styles.weekdayRow}>
        {getWeekdays(locale).map((weekday) => (
          <span key={weekday} className={cx("caption-md-medium", styles.weekdayLabel)}>
            {weekday.slice(0, 3)}
          </span>
        ))}
      </div>

      <div className={styles.grid}>
        {weeks.map((week, i) => (
          <div className={styles.week} key={i}>
            {week.map((cell) => (
              <button
                key={cell.iso}
                type="button"
                className={cx(
                  "caption-md-regular",
                  styles.day,
                  cell.outsideMonth && styles.dayOutside,
                  cell.inRange && styles.dayInRange,
                  cell.isEndpoint && styles.dayEndpoint
                )}
                onClick={() => onDayClick?.(cell.iso)}
              >
                {cell.day}
              </button>
            ))}
          </div>
        ))}
      </div>
    </div>
  );
}
