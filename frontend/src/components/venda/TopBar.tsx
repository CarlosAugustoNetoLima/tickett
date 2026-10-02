"use client";

import { Fragment, useEffect, useRef } from "react";
import { useTranslations } from "next-intl";
import { Link } from "@/i18n/navigation";
import { cx } from "@/lib/cx";
import { Icon } from "@/components/ui/Icon";
import { STEPS } from "./types";
import styles from "./TopBar.module.css";

interface TopBarProps {
  currentStep: number;
  allDone?: boolean;
  onBack?: () => void;
  onClose: () => void;
}

export function TopBar({ currentStep, allDone = false, onBack, onClose }: TopBarProps) {
  const t = useTranslations("venda.topBar");
  const tSteps = useTranslations("venda.steps");
  const mobileBreadcrumbsRef = useRef<HTMLElement>(null);

  useEffect(() => {
    const nav = mobileBreadcrumbsRef.current;
    const active = nav?.querySelector<HTMLElement>('[data-active="true"]');
    active?.scrollIntoView({ block: "nearest", inline: "center" });
  }, [currentStep, allDone]);

  return (
    <header className={styles.wrap}>
      <div className={styles.topRow}>
        {onBack && (
          <button type="button" className={styles.back} onClick={onBack} aria-label={t("back")}>
            <span className={styles.backIcon}>
              <Icon name="arrow-left" size={24} />
            </span>
            <span className={cx(styles.backLabel, "caption-md-medium")}>{t("back")}</span>
          </button>
        )}

        <Link href="/" className={styles.logo} aria-label="Tickett.com">
          <img className={styles.logoImg} src="/brand/logo.png" alt="Tickett.com" />
        </Link>

        <nav className={styles.breadcrumbsDesktop} aria-label={t("progressAria")}>
          {STEPS.map((key, index) => {
            const active = allDone || index === currentStep;
            return (
              <Fragment key={key}>
                <div className={styles.step}>
                  <span className={cx(styles.circle, active && styles.circleActive, "body-sm-medium")}>
                    {index + 1}
                  </span>
                  <span className={cx(styles.stepLabel, active && styles.stepLabelActive, "body-sm-medium")}>
                    {tSteps(key)}
                  </span>
                </div>
                {index < STEPS.length - 1 && <span className={styles.line} aria-hidden="true" />}
              </Fragment>
            );
          })}
        </nav>

        <div className={styles.right}>
          <button type="button" className={styles.close} onClick={onClose} aria-label={t("close")}>
            <span className={styles.closeIcon}>
              <Icon name="x" size={32} />
            </span>
          </button>
        </div>
      </div>

      <div className={styles.mobileDivider} aria-hidden="true" />

      <nav className={styles.breadcrumbsMobile} aria-label={t("progressAria")} ref={mobileBreadcrumbsRef}>
        {STEPS.map((key, index) => {
          const active = allDone || index === currentStep;
          return (
            <div className={styles.step} key={key} data-active={active}>
              <span className={cx(styles.circle, active && styles.circleActive, "body-sm-medium")}>
                {index + 1}
              </span>
              <span className={cx(styles.stepLabel, active && styles.stepLabelActive, "body-sm-medium")}>
                {tSteps(key)}
              </span>
            </div>
          );
        })}
      </nav>

      <div className={styles.mobileDivider} aria-hidden="true" />
    </header>
  );
}
