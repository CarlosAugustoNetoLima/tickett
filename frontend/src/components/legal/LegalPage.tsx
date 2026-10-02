import type { ReactNode } from "react";
import { Navbar } from "@/components/layout/Navbar";
import { MobileNavbar } from "@/components/mobile/Menu";
import { Footer } from "@/components/layout/Footer";
import { cx } from "@/lib/cx";
import { getLegalDocument, type LegalSlug } from "@/content/legal";
import type { Locale } from "@/i18n/routing";
import styles from "./LegalPage.module.css";

interface LegalPageProps {
  slug: LegalSlug;
  locale: Locale;
  aside?: ReactNode;
}

export function LegalPage({ slug, locale, aside }: LegalPageProps) {
  const { title, body } = getLegalDocument(slug, locale);

  return (
    <>
      <Navbar />
      <MobileNavbar />
      <main className={styles.main}>
        <article className={cx(styles.article, aside != null && styles.withAside)}>
          <h1 className={cx("heading-h3", styles.title)}>{title}</h1>
          {aside != null && <aside className={styles.aside}>{aside}</aside>}
          <div
            className={cx("body-md-regular", styles.prose)}
            dangerouslySetInnerHTML={{ __html: body }}
          />
        </article>
      </main>
      <Footer />
    </>
  );
}
