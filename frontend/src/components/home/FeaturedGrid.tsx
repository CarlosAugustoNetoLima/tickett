import { useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import { Icon } from "@/components/ui/Icon";
import { Button } from "@/components/ui/Button";
import { CardDestaqueMin } from "@/components/ui/Card";
import { EventCardData } from "@/types/event";
import styles from "./FeaturedGrid.module.css";

interface FeaturedGridProps {
  events: EventCardData[];
}

const MAX_ROWS = 3;
const COLUMNS = 3;

export function FeaturedGrid({ events }: FeaturedGridProps) {
  const t = useTranslations("home.featuredGrid");
  const visibleEvents = events.slice(0, MAX_ROWS * COLUMNS);

  return (
    <section className={styles.section}>
      <div className={styles.grid}>
        {visibleEvents.map((event) => (
          <CardDestaqueMin key={event.href} {...event} />
        ))}
      </div>

      <div className={styles.banner}>
        <div className={styles.bannerLeft}>
          <span className={styles.bannerChip}>
            <Icon name="global" size={28} />
          </span>
          <p className={cx("heading-h5", styles.bannerText)}>
            {t.rich("banner", {
              accent: (chunks) => <span className={styles.bannerAccent}>{chunks}</span>,
            })}
          </p>
        </div>
        <Button href="/eventos" iconRight="arrow-right" className={styles.bannerButton}>
          {t("seeMore")}
        </Button>
      </div>
    </section>
  );
}
