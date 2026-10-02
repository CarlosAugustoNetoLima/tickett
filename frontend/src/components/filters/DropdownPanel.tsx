import { HTMLAttributes } from "react";
import { cx } from "@/lib/cx";
import styles from "./DropdownPanel.module.css";

type DropdownPanelProps = HTMLAttributes<HTMLDivElement>;

export function DropdownPanel({ className, children, ...rest }: DropdownPanelProps) {
  return (
    <div className={cx(styles.panel, className)} {...rest}>
      {children}
    </div>
  );
}
