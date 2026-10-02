import type { ReactNode } from "react";
import { useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import { CardDefault } from "@/components/ui/Card";
import type { EventCardData } from "@/types/event";
import styles from "./Section.module.css";

interface SectionProps {
  title: string;
  count: number;
  events: EventCardData[];
  emptyMessage?: string;
  headingLevel?: "h1" | "h2";
  children?: ReactNode;
}

export function Section({ title, count, events, emptyMessage, headingLevel: Heading = "h2", children }: SectionProps) {
  const t = useTranslations("eventos");

  return (
    <section className={styles.section}>
      <div className={styles.header}>
        <Heading className={cx("heading-h5", styles.title)}>{title}</Heading>
        <span className={cx("caption-md-regular", styles.count)}>{t("count", { count })}</span>
      </div>

      {events.length === 0 && emptyMessage ? (
        <p className={cx("body-md-regular", styles.empty)}>{emptyMessage}</p>
      ) : (
        <div className={styles.row}>
          {events.map((event) => (
            <CardDefault key={event.href} {...event} />
          ))}
        </div>
      )}

      {children}
    </section>
  );
}
