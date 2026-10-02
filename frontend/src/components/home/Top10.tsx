"use client";

import { useRef } from "react";
import { useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import { Icon } from "@/components/ui/Icon";
import { CardDestaque } from "@/components/ui/Card";
import { EventCardData } from "@/types/event";
import styles from "./Top10.module.css";

interface Top10Props {
  events: EventCardData[];
}

const SCROLL_STEP = 380;

export function Top10({ events }: Top10Props) {
  const t = useTranslations("home.top10");
  const trackRef = useRef<HTMLDivElement>(null);

  function scrollBy(delta: number) {
    trackRef.current?.scrollBy({ left: delta, behavior: "smooth" });
  }

  return (
    <section className={styles.section}>
      <div className={styles.header}>
        <div className={styles.headingGroup}>
          <span className={cx("caption-md-bold", styles.kicker)}>{t("kicker")}</span>
          <h2 className={cx("heading-h4", styles.title)}>{t("title")}</h2>
        </div>
        <div className={styles.arrows}>
          <button className={styles.arrowButton} onClick={() => scrollBy(-SCROLL_STEP)} aria-label={t("prev")}>
            <Icon name="arrow-left" size={16} />
          </button>
          <button className={styles.arrowButton} onClick={() => scrollBy(SCROLL_STEP)} aria-label={t("next")}>
            <Icon name="arrow-right" size={16} />
          </button>
        </div>
      </div>

      <div className={styles.track} ref={trackRef}>
        {events.map((event, i) => (
          <div className={styles.rankItem} key={event.href}>
            <span className={cx("display-hero", styles.rankNumber)}>{i + 1}</span>
            <CardDestaque {...event} />
          </div>
        ))}
      </div>
    </section>
  );
}
