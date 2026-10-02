import { useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import { Icon, IconName } from "@/components/ui/Icon";
import { Button } from "@/components/ui/Button";
import styles from "./Promotor.module.css";

const FEATURES: { icon: IconName; key: "bilheteira" | "checkin" | "pagamentos" | "apoio" }[] = [
  { icon: "ticket", key: "bilheteira" },
  { icon: "scan", key: "checkin" },
  { icon: "security-card", key: "pagamentos" },
  { icon: "headphone", key: "apoio" },
];

export function Promotor() {
  const t = useTranslations("home.promotor");

  return (
    <section className={styles.section}>
      <div className={styles.card}>
        <div className={styles.left}>
          <span className={cx("caption-md-bold", styles.kicker)}>{t("kicker")}</span>
          <h2 className={cx("heading-h5", styles.title)}>{t("title")}</h2>
          <p className={cx("body-sm-regular", styles.description)}>{t("description")}</p>
          <div className={styles.actions}>
            <Button className={styles.ctaButton} href="/venda">
              {t("cta")}
            </Button>
          </div>
        </div>

        <div className={styles.feats}>
          {FEATURES.map((feat) => (
            <div className={styles.featCard} key={feat.key}>
              <span className={styles.featIcon}>
                <Icon name={feat.icon} size={40} />
              </span>
              <h3 className={cx("heading-h6", styles.featTitle)}>{t(`features.${feat.key}`)}</h3>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
