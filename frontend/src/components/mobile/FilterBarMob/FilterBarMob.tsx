"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import { Icon } from "@/components/ui/Icon";
import { BottomSheet } from "@/components/layout/BottomSheet";
import {
  CategoryChips,
  CityOptions,
  DateOptions,
  DatePickerPanel,
  PriceOptions,
  SortOptions,
} from "@/components/filters";
import { useEventosFilters } from "@/hooks/useEventosFilters";
import type { EventosFilters, FilterOption } from "@/lib/eventos-filters";
import styles from "./FilterBarMob.module.css";

type SheetView = null | "filtros" | "data" | "calendar" | "local" | "preco" | "ordenar";

interface FilterBarMobProps {
  categories: FilterOption[];
  cities: FilterOption[];
  filters: EventosFilters;
}

interface FilterRowProps {
  label: string;
  value: string | null;
  clearLabel?: string;
  onOpen: () => void;
  onClear?: () => void;
}

function FilterRow({ label, value, clearLabel, onOpen, onClear }: FilterRowProps) {
  const clearable = !!value && !!onClear;
  return (
    <div className={styles.navRow}>
      <button type="button" className={styles.navOpen} onClick={onOpen}>
        <span className={cx("body-sm-regular", styles.navLabel)}>{label}</span>
        {value && <span className={cx("caption-md-medium", styles.navValue)}>{value}</span>}
        {clearable && <span className={styles.navClearSpace} aria-hidden="true" />}
        <Icon name="arrow-right" size={14} />
      </button>
      {clearable && (
        <button type="button" aria-label={clearLabel} className={styles.navClear} onClick={onClear}>
          <Icon name="close" size={12} />
        </button>
      )}
    </div>
  );
}

export function FilterBarMob({ categories, cities, filters }: FilterBarMobProps) {
  const t = useTranslations("filters");
  const tNav = useTranslations("nav");
  const { goTo, calendar, labels, dateSelection, selectQuickDate, clearDates } = useEventosFilters(filters, cities);
  const [view, setView] = useState<SheetView>(null);
  const activeCount = [labels.date, labels.city, labels.preco].filter(Boolean).length;
  const close = () => setView(null);
  const back = () => setView("filtros");

  function select(apply: () => void) {
    close();
    apply();
  }

  return (
    <>
      <nav className={styles.bar} aria-label={t("filtrosAria")}>
        <CategoryChips categories={categories} filters={filters} />
        <button className={styles.filterButton} onClick={() => setView("filtros")} aria-label={t("filtrosAria")}>
          <Icon name="sort" size={16} className={styles.filterIcon} />
          {activeCount > 0 && <span className={cx(styles.filterBadge, "caption-sm-medium")}>{activeCount}</span>}
        </button>
      </nav>

      <BottomSheet open={view === "filtros"} title={t("filtrar")} onClose={close}>
        {activeCount > 0 && (
          <button
            className={cx(styles.clearAllRow, "caption-md-medium")}
            onClick={() => select(() => goTo({ data_inicio: null, data_fim: null, cidade: null, preco: "qualquer" }))}
          >
            {t("clearFilters", { count: activeCount })}
          </button>
        )}
        <FilterRow
          label={tNav("filterDate")}
          value={labels.date}
          clearLabel={t("clearDateAria")}
          onOpen={() => setView("data")}
          onClear={clearDates}
        />
        <FilterRow
          label={tNav("filterLocal")}
          value={labels.city}
          clearLabel={t("clearLocalAria")}
          onOpen={() => setView("local")}
          onClear={() => goTo({ cidade: null })}
        />
        <FilterRow
          label={tNav("filterPreco")}
          value={labels.preco}
          clearLabel={t("clearPrecoAria")}
          onOpen={() => setView("preco")}
          onClear={() => goTo({ preco: "qualquer" })}
        />
        <FilterRow label={tNav("filterOrdenar")} value={labels.sort} onOpen={() => setView("ordenar")} />
      </BottomSheet>

      <BottomSheet open={view === "data"} title={tNav("filterDate")} onClose={close} onBack={back}>
        <DateOptions
          selectedKey={dateSelection.quickKey}
          hasCustomDate={dateSelection.custom}
          onSelect={(key) => select(() => selectQuickDate(key))}
          onPickDate={() => {
            calendar.open();
            setView("calendar");
          }}
        />
      </BottomSheet>

      <BottomSheet open={view === "calendar"} title={t("escolherData")} onClose={close} onBack={() => setView("data")}>
        <DatePickerPanel
          variant="sheet"
          calendar={calendar}
          onApply={() => select(calendar.apply)}
          onClear={() => select(clearDates)}
        />
      </BottomSheet>

      <BottomSheet open={view === "local"} title={tNav("filterLocal")} onClose={close} onBack={back}>
        <CityOptions cities={cities} selected={filters.cidade} onSelect={(cidade) => select(() => goTo({ cidade }))} />
      </BottomSheet>

      <BottomSheet open={view === "preco"} title={tNav("filterPreco")} onClose={close} onBack={back}>
        <PriceOptions selected={filters.preco} onSelect={(preco) => select(() => goTo({ preco }))} />
      </BottomSheet>

      <BottomSheet open={view === "ordenar"} title={tNav("filterOrdenar")} onClose={close} onBack={back}>
        <SortOptions selected={filters.ordenar} onSelect={(ordenar) => select(() => goTo({ ordenar }))} />
      </BottomSheet>
    </>
  );
}
