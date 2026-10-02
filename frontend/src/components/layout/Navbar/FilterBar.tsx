"use client";

import { useEffect, useRef, useState, type ReactNode } from "react";
import { useTranslations } from "next-intl";
import { Dropdown } from "@/components/ui/Dropdown";
import {
  CategoryChips,
  CityOptions,
  DateOptions,
  DatePickerPanel,
  DropdownPanel,
  PriceOptions,
  SortOptions,
} from "@/components/filters";
import { useEventosFilters } from "@/hooks/useEventosFilters";
import type { EventosFilters, FilterOption } from "@/lib/eventos-filters";
import styles from "./Navbar.module.css";

type FilterKey = "data" | "local" | "preco" | "ordenar";

export interface FilterBarProps {
  categories: FilterOption[];
  cities: FilterOption[];
  filters: EventosFilters;
}

interface FilterMenuProps {
  label: ReactNode;
  open: boolean;
  active?: boolean;
  onToggle: () => void;
  onClear?: () => void;
  clearLabel?: string;
  children: ReactNode;
}

function FilterMenu({ label, open, active, onToggle, onClear, clearLabel, children }: FilterMenuProps) {
  return (
    <div className={styles.filterItem}>
      <Dropdown active={active} open={open} onClick={onToggle} onClear={onClear} clearLabel={clearLabel}>
        {label}
      </Dropdown>
      {open && <div className={styles.filterPanel}>{children}</div>}
    </div>
  );
}

export function FilterBar({ categories, cities, filters }: FilterBarProps) {
  const t = useTranslations("nav");
  const tFilters = useTranslations("filters");
  const { goTo, calendar, labels, dateSelection, selectQuickDate, clearDates } = useEventosFilters(filters, cities);
  const [open, setOpen] = useState<FilterKey | null>(null);
  const [pickingDate, setPickingDate] = useState(false);
  const menusRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    function closeMenus() {
      setOpen(null);
      setPickingDate(false);
    }
    function onClickOutside(e: MouseEvent) {
      if (!menusRef.current?.contains(e.target as Node)) closeMenus();
    }
    function onKeyDown(e: KeyboardEvent) {
      if (e.key === "Escape") closeMenus();
    }
    document.addEventListener("mousedown", onClickOutside);
    document.addEventListener("keydown", onKeyDown);
    return () => {
      document.removeEventListener("mousedown", onClickOutside);
      document.removeEventListener("keydown", onKeyDown);
    };
  }, []);

  function toggle(key: FilterKey) {
    setOpen((current) => (current === key ? null : key));
    setPickingDate(false);
  }

  function select(apply: () => void) {
    setOpen(null);
    setPickingDate(false);
    apply();
  }

  return (
    <div className={styles.filterBar}>
      <CategoryChips categories={categories} filters={filters} />

      <div className={styles.rightFilters} ref={menusRef}>
        <FilterMenu
          label={labels.date ?? t("filterDate")}
          active={!!labels.date}
          open={open === "data"}
          onToggle={() => toggle("data")}
          onClear={() => select(clearDates)}
          clearLabel={tFilters("clearDateAria")}
        >
          {pickingDate ? (
            <DatePickerPanel
              calendar={calendar}
              onApply={() => select(calendar.apply)}
              onClear={() => select(clearDates)}
            />
          ) : (
            <DropdownPanel>
              <DateOptions
                selectedKey={dateSelection.quickKey}
                hasCustomDate={dateSelection.custom}
                onSelect={(key) => select(() => selectQuickDate(key))}
                onPickDate={() => {
                  calendar.open();
                  setPickingDate(true);
                }}
              />
            </DropdownPanel>
          )}
        </FilterMenu>

        <FilterMenu
          label={labels.city ?? t("filterLocal")}
          active={filters.cidade != null}
          open={open === "local"}
          onToggle={() => toggle("local")}
          onClear={() => select(() => goTo({ cidade: null }))}
          clearLabel={tFilters("clearLocalAria")}
        >
          <DropdownPanel className={styles.scrollPanel}>
            <CityOptions cities={cities} selected={filters.cidade} onSelect={(cidade) => select(() => goTo({ cidade }))} />
          </DropdownPanel>
        </FilterMenu>

        <FilterMenu
          label={labels.preco ?? t("filterPreco")}
          active={filters.preco !== "qualquer"}
          open={open === "preco"}
          onToggle={() => toggle("preco")}
          onClear={() => select(() => goTo({ preco: "qualquer" }))}
          clearLabel={tFilters("clearPrecoAria")}
        >
          <DropdownPanel>
            <PriceOptions selected={filters.preco} onSelect={(preco) => select(() => goTo({ preco }))} />
          </DropdownPanel>
        </FilterMenu>

        <FilterMenu
          label={
            <>
              {t("filterOrdenar")}&nbsp;<span className={styles.sortAccent}>{labels.sort}</span>
            </>
          }
          open={open === "ordenar"}
          onToggle={() => toggle("ordenar")}
        >
          <DropdownPanel>
            <SortOptions selected={filters.ordenar} onSelect={(ordenar) => select(() => goTo({ ordenar }))} />
          </DropdownPanel>
        </FilterMenu>
      </div>
    </div>
  );
}
