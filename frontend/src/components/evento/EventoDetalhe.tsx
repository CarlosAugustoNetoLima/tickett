import { useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import { Button } from "@/components/ui/Button";
import { FittedImage } from "@/components/ui/FittedImage";
import type { EventoDetalhe as EventoDetalheData } from "@/lib/evento-data";
import { EventoBody } from "./EventoBody";
import { TicketIcon } from "./icons";
import styles from "./EventoDetalhe.module.css";

interface EventoDetalheProps {
  event: EventoDetalheData;
  path: string;
}

export function EventoDetalhe({ event, path }: EventoDetalheProps) {
  const t = useTranslations("eventoDetalhe");
  const eyebrow = [event.category, event.city].filter(Boolean).join("  ·  ").toUpperCase();
  const checkoutHref = event.checkoutUrl;

  return (
    <div className={styles.page}>
      <div className={styles.hero} data-name="Hero">
        {event.image ? (
          <>
            <div className={styles.heroImage}>
              <FittedImage source={event.image} mobileSource={event.mobileImage} />
            </div>
            <div className={styles.heroGradient} />
          </>
        ) : (
          <div className={styles.heroPlaceholder}>
            <TicketIcon size={40} className={styles.heroPlaceholderIcon} />
            <span className={cx("body-sm-regular", styles.heroPlaceholderText)}>{t("imagePlaceholder")}</span>
          </div>
        )}
        <div className={styles.heroContent}>
          {eyebrow && <p className={cx("caption-md-bold", styles.eyebrow)}>{eyebrow}</p>}
          <h1 className={styles.title}>{event.title}</h1>
        </div>
      </div>

      <div className={styles.divider} />

      <EventoBody event={event} path={path} />

      <div className={styles.divider} />

      <div className={styles.sticky} data-name="Sticky">
        <div className={styles.stickyInfo}>
          <p className={cx("body-md-bold", styles.stickyTitle)}>{event.title}</p>
          <p className={cx("caption-md-regular", styles.stickyMeta)}>
            {event.dateLabel} · {event.timeLabel}
            {event.city ? ` · ${event.city}` : ""}
          </p>
        </div>
        {event.salesClosed ? (
          <div className={styles.salesClosed}>
            <span className={cx("body-sm-medium", styles.salesClosedTitle)}>{t("salesClosed")}</span>
            <span className={cx("caption-md-regular", styles.salesClosedHint)}>{t("salesClosedHint")}</span>
          </div>
        ) : (
          <>
            {event.priceFrom && (
              <div className={styles.stickyPrice}>
                <span className={cx("caption-md-regular", styles.stickyPriceLabel)}>{t("priceFrom")}</span>
                <span className={cx("body-lg-bold", styles.stickyPriceValue)}>{event.priceFrom}</span>
              </div>
            )}
            <Button href={checkoutHref} className={styles.stickyButton}>
              {t("selectTickets")}
            </Button>
          </>
        )}
      </div>
    </div>
  );
}

export function EventoDetalheStickySpacer() {
  return <div className={styles.stickySpacer} />;
}
