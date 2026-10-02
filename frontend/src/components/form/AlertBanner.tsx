import { Icon } from "@/components/ui/Icon";
import { cx } from "@/lib/cx";
import styles from "./AlertBanner.module.css";

interface AlertBannerProps {
  message: string;
}

export function AlertBanner({ message }: AlertBannerProps) {
  return (
    <div className={styles.banner} role="alert">
      <span className={styles.icon}>
        <Icon name="warning" size={20} />
      </span>
      <p className={cx(styles.text, "body-sm-medium")}>{message}</p>
    </div>
  );
}
