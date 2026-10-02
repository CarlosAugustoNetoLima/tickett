"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import { useRouter } from "@/i18n/navigation";
import { buildEventosUrl, type EventosFilters, type FilterOption } from "@/lib/eventos-filters";
import { formatShortRange, matchQuickDateKey, quickDateRange, type QuickDateKey } from "@/lib/calendar";

interface DateDraft {
  start: string | null;
  end: string | null;
  year: number;
  month: number;
}

export interface DateRangeDraft extends DateDraft {
  pickDay: (iso: string) => void;
  changeMonth: (delta: number) => void;
}

function draftFrom(filters: EventosFilters): DateDraft {
  const start = filters.data_inicio;
  const today = new Date();
  return {
    start,
    end: filters.data_fim,
    year: start ? Number(start.slice(0, 4)) : today.getFullYear(),
    month: start ? Number(start.slice(5, 7)) - 1 : today.getMonth(),
  };
}

export function useEventosFilters(filters: EventosFilters, cities: FilterOption[]) {
  const router = useRouter();
  const t = useTranslations("filters");
  const [draft, setDraft] = useState(() => draftFrom(filters));

  function goTo(changes: Partial<EventosFilters>) {
    router.push(buildEventosUrl({ ...filters, ...changes }));
  }

  const calendar: DateRangeDraft & { open: () => void; apply: () => void } = {
    ...draft,
    open: () => setDraft(draftFrom(filters)),
    pickDay: (iso) =>
      setDraft((d) => (!d.start || d.end || iso < d.start ? { ...d, start: iso, end: null } : { ...d, end: iso })),
    changeMonth: (delta) =>
      setDraft((d) => {
        const next = new Date(d.year, d.month + delta, 1);
        return { ...d, year: next.getFullYear(), month: next.getMonth() };
      }),
    apply: () => goTo({ data_inicio: draft.start, data_fim: draft.end ?? draft.start }),
  };

  const activeQuickDateKey = matchQuickDateKey(filters.data_inicio, filters.data_fim);

  return {
    goTo,
    calendar,
    labels: {
      date: formatShortRange(filters.data_inicio, filters.data_fim),
      city: cities.find((c) => c.slug === filters.cidade)?.name ?? null,
      preco: filters.preco === "qualquer" ? null : t(`preco.${filters.preco}`),
      sort: t(`ordenar.${filters.ordenar}`),
    },
    dateSelection: {
      quickKey: activeQuickDateKey,
      custom: !!filters.data_inicio && !activeQuickDateKey,
    },
    selectQuickDate(key: QuickDateKey) {
      const { start, end } = quickDateRange(key);
      goTo({ data_inicio: start, data_fim: end });
    },
    clearDates() {
      goTo({ data_inicio: null, data_fim: null });
    },
  };
}
