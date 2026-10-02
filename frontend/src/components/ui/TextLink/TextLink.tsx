import type { ReactNode } from "react";
import { Link } from "@/i18n/navigation";
import styles from "./TextLink.module.css";

export function TextLink({ href, children }: { href: string; children: ReactNode }) {
  if (/^https?:/.test(href)) {
    return (
      <a href={href} className={styles.link} target="_blank" rel="noopener noreferrer">
        {children}
      </a>
    );
  }
  return (
    <Link href={href} className={styles.link}>
      {children}
    </Link>
  );
}
