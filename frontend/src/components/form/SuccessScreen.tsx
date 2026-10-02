import type { ReactNode } from "react";
import { cx } from "@/lib/cx";
import { Icon } from "@/components/ui/Icon";
import styles from "./SuccessScreen.module.css";

interface SuccessScreenProps {
  title: string;
  subtitle: string;
  children: ReactNode;
}

export function SuccessScreen({ title, subtitle, children }: SuccessScreenProps) {
  return (
    <div className={styles.wrap}>
      <div className={styles.content}>
        <div className={styles.checkCircle}>
          <Icon name="tick" size={36} />
        </div>
        <div className={styles.textGroup}>
          <p className={cx(styles.title, "heading-h6")}>{title}</p>
          <p className={cx(styles.subtitle, "body-sm-regular")}>{subtitle}</p>
        </div>
        <div className={styles.actions}>{children}</div>
      </div>
    </div>
  );
}
