import { useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import { WhyChooseUsBento } from "./WhyChooseUsBento";
import styles from "./WhyChooseUs.module.css";

export function WhyChooseUs() {
  const t = useTranslations("home.whyChooseUs");

  return (
    <section className={styles.section}>
      <div className={styles.header}>
        <span className={cx("caption-md-bold", styles.kicker)}>{t("kicker")}</span>
        <h2 className={cx("heading-h4", styles.title)}>{t("title")}</h2>
      </div>

      <WhyChooseUsBento />
    </section>
  );
}
