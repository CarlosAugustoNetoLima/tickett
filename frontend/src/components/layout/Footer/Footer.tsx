import { useTranslations } from "next-intl";
import { Link } from "@/i18n/navigation";
import { cx } from "@/lib/cx";
import { SUPPORT_EMAIL } from "@/lib/contact";
import { CookieSettingsButton } from "@/components/consent";
import { NewsletterForm } from "./NewsletterForm";
import styles from "./Footer.module.css";

const INSTAGRAM_URL = "https://www.instagram.com/tickett_com";
const RAL_URL = "https://www.consumidor.gov.pt/";
const LIVRO_RECLAMACOES_URL = "https://www.livroreclamacoes.pt/";

interface FooterLink {
  label: string;
  href: string;
}

function isExternal(href: string): boolean {
  return /^https?:|^mailto:/.test(href);
}

export function Footer() {
  const t = useTranslations("footer");
  const tConsent = useTranslations("consent");

  const columns: { title: string; links?: FooterLink[]; content?: "newsletter" }[] = [
    {
      title: t("columns.company.title"),
      links: [
        { label: t("columns.company.sobre"), href: "/sobre" },
        { label: t("columns.company.termos"), href: "/termos" },
        { label: t("columns.company.privacidade"), href: "/privacidade" },
        { label: t("columns.company.cookies"), href: "/cookies" },
        { label: t("columns.company.acessibilidade"), href: "/acessibilidade" },
      ],
    },
    {
      title: t("columns.support.title"),
      links: [
        { label: t("columns.support.contacto"), href: `mailto:${SUPPORT_EMAIL}` },
        { label: t("columns.support.reenviarBilhete"), href: "/reenviar-bilhete" },
        { label: t("columns.support.venda"), href: "/venda" },
        { label: t("columns.support.litigios"), href: RAL_URL },
        { label: t("columns.support.reclamacoes"), href: LIVRO_RECLAMACOES_URL },
      ],
    },
    {
      title: t("columns.social.title"),
      links: [
        { label: t("columns.social.instagram"), href: INSTAGRAM_URL },
        { label: SUPPORT_EMAIL, href: `mailto:${SUPPORT_EMAIL}` },
      ],
    },
    {
      title: t("columns.newsletter.title"),
      content: "newsletter",
    },
  ];

  return (
    <footer className={styles.footer}>
      <div className={styles.top}>
        <div className={styles.brand}>
          <img className={styles.brandLogo} src="/brand/logo.png" alt="Tickett.com" />
          <span className={cx("caption-md-regular", styles.tagline)}>{t("tagline")}</span>
        </div>

        <div className={styles.linkColumns}>
          {columns.map((column) => (
            <div
              key={column.title}
              className={cx(styles.column, column.content === "newsletter" && styles.newsletterColumn)}
            >
              <span className={cx("body-sm-medium", styles.columnTitle)}>{column.title}</span>

              {column.content === "newsletter" && <NewsletterForm />}

              {column.links?.map((link) =>
                isExternal(link.href) ? (
                  <a
                    key={link.label}
                    href={link.href}
                    className={cx("caption-md-regular", styles.columnLink)}
                    target={link.href.startsWith("mailto:") ? undefined : "_blank"}
                    rel={link.href.startsWith("mailto:") ? undefined : "noopener noreferrer"}
                  >
                    {link.label}
                  </a>
                ) : (
                  <Link key={link.label} href={link.href} className={cx("caption-md-regular", styles.columnLink)}>
                    {link.label}
                  </Link>
                )
              )}
            </div>
          ))}
        </div>
      </div>

      <div className={cx("caption-md-regular", styles.bottom)}>
        <span>{t("copyright", { year: new Date().getFullYear() })}</span>
        <CookieSettingsButton className={styles.columnLink}>{tConsent("settings")}</CookieSettingsButton>
      </div>
    </footer>
  );
}
