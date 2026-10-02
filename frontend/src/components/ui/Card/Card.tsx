import { useTranslations } from "next-intl";
import { Link } from "@/i18n/navigation";
import { cx } from "@/lib/cx";
import { Icon } from "@/components/ui/Icon";
import { FittedImage } from "@/components/ui/FittedImage";
import type { FittedSource } from "@/lib/image-format";
import { EventCardData } from "@/types/event";
import styles from "./Card.module.css";

function CardImage({ image, title }: { image: FittedSource | null; title: string }) {
  const t = useTranslations("card");
  if (!image) {
    return (
      <div className={styles.imagePlaceholder}>
        <Icon name="ticket" size={24} className={styles.imagePlaceholderIcon} />
        <span className={cx("caption-xs", styles.imagePlaceholderText)}>{t("imagePlaceholder")}</span>
      </div>
    );
  }
  return <FittedImage source={image} alt={title} imageClassName={styles.image} />;
}

export function CardDestaque({ href, image, title, venue, date, priceFrom }: EventCardData) {
  const t = useTranslations("card");
  return (
    <Link href={href} className={cx(styles.card, styles.destaque)}>
      <div className={cx(styles.imageWrap, styles.destaqueImage)}>
        <CardImage image={image} title={title} />
      </div>
      <div className={styles.destaqueInfo}>
        <div className={styles.titleGroup}>
          <span className={cx("body-lg-bold", styles.title)}>{title}</span>
          <span className={cx("caption-md-regular", styles.subtitle)}>{venue}</span>
        </div>
        <div className={styles.priceRow}>
          <span className={cx("caption-md-regular", styles.dateText)}>{date}</span>
          {priceFrom && (
            <div className={styles.priceBlock}>
              <span className={cx("caption-sm-regular", styles.priceLabel)}>{t("priceFrom")}</span>
              <span className={cx("body-lg-bold", styles.priceAccent)}>{priceFrom}</span>
            </div>
          )}
        </div>
      </div>
    </Link>
  );
}

export function CardDefault({ href, image, title, venue, date, priceFrom }: EventCardData) {
  const t = useTranslations("card");
  return (
    <Link href={href} className={cx(styles.card, styles.default)}>
      <div className={cx(styles.imageWrap, styles.defaultImage)}>
        <CardImage image={image} title={title} />
      </div>
      <div className={styles.mediumInfo}>
        <span className={cx("body-md-bold", styles.title)}>{title}</span>
        <span className={cx("body-sm-bold", styles.dateHighlight)}>{date}</span>
        <span className={cx("caption-md-regular", styles.subtitle)}>{venue}</span>
        <span className={cx("caption-md-regular", styles.subtitleMobile)}>
          {[date, venue].filter(Boolean).join("  ·  ")}
        </span>
        {priceFrom && (
          <div className={styles.mediumPriceRow}>
            <span className={cx("caption-sm-regular", styles.priceLabel)}>{t("priceFrom")}</span>
            <span className={cx("body-lg-bold", styles.priceWhite)}>{priceFrom}</span>
          </div>
        )}
      </div>
    </Link>
  );
}

export function CardDestaqueMin({ href, image, title, venue }: EventCardData) {
  return (
    <Link href={href} className={cx(styles.card, styles.destaqueMin)}>
      <div className={cx(styles.imageWrap, styles.minThumb)}>
        <CardImage image={image} title={title} />
      </div>
      <div className={styles.minInfo}>
        <span className="body-md-medium">{title}</span>
        <span className={cx("caption-md-regular", styles.subtitle)}>{venue}</span>
      </div>
    </Link>
  );
}
