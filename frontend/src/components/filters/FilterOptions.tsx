"use client";

import { useTranslations } from "next-intl";
import { MenuItem } from "./MenuItem";
import { QUICK_DATE_KEYS, type QuickDateKey } from "@/lib/calendar";
import { PRECO_KEYS, SORT_KEYS, type FilterOption, type PrecoKey, type SortKey } from "@/lib/eventos-filters";

interface OptionsProps<T> {
  selected: T;
  onSelect: (value: T) => void;
}

interface DateOptionsProps {
  selectedKey: QuickDateKey | null;
  hasCustomDate: boolean;
  onSelect: (key: QuickDateKey) => void;
  onPickDate: () => void;
}

export function DateOptions({ selectedKey, hasCustomDate, onSelect, onPickDate }: DateOptionsProps) {
  const t = useTranslations("calendar.quickDates");
  const tFilters = useTranslations("filters");
  return (
    <>
      {QUICK_DATE_KEYS.map((key) => (
        <MenuItem key={key} label={t(key)} selected={key === selectedKey} onClick={() => onSelect(key)} />
      ))}
      <MenuItem
        label={tFilters("escolherData")}
        icon="calendar"
        selected={hasCustomDate}
        onClick={onPickDate}
      />
    </>
  );
}

export function CityOptions({ cities, selected, onSelect }: OptionsProps<string | null> & { cities: FilterOption[] }) {
  const t = useTranslations("filters");
  return (
    <>
      <MenuItem label={t("todosLocais")} selected={selected === null} onClick={() => onSelect(null)} />
      {cities.map((city) => (
        <MenuItem key={city.slug} label={city.name} selected={selected === city.slug} onClick={() => onSelect(city.slug)} />
      ))}
    </>
  );
}

export function PriceOptions({ selected, onSelect }: OptionsProps<PrecoKey>) {
  const t = useTranslations("filters.preco");
  return (
    <>
      {PRECO_KEYS.map((key) => (
        <MenuItem key={key} label={t(key)} selected={selected === key} onClick={() => onSelect(key)} />
      ))}
    </>
  );
}

export function SortOptions({ selected, onSelect }: OptionsProps<SortKey>) {
  const t = useTranslations("filters.ordenar");
  return (
    <>
      {SORT_KEYS.map((key) => (
        <MenuItem key={key} label={t(key)} selected={selected === key} onClick={() => onSelect(key)} />
      ))}
    </>
  );
}
