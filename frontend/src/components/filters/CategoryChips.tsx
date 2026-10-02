import { useTranslations } from "next-intl";
import { Chip } from "@/components/ui/Chip";
import { FadeScroll } from "@/components/ui/FadeScroll";
import { buildEventosUrl, type EventosFilters, type FilterOption } from "@/lib/eventos-filters";
import styles from "./CategoryChips.module.css";

interface CategoryChipsProps {
  categories: FilterOption[];
  filters: EventosFilters;
}

export function CategoryChips({ categories, filters }: CategoryChipsProps) {
  const t = useTranslations("nav");
  const href = (categoria: string | null) => buildEventosUrl({ ...filters, categoria });
  return (
    <FadeScroll className={styles.list}>
      <Chip href={href(null)} active={!filters.categoria}>
        {t("categoriesAll")}
      </Chip>
      {categories.map((category) => (
        <Chip key={category.slug} href={href(category.slug)} active={filters.categoria === category.slug}>
          {category.name}
        </Chip>
      ))}
    </FadeScroll>
  );
}
