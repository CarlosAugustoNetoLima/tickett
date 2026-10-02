"use client";

import { useEffect, useState } from "react";
import { useTranslations } from "next-intl";
import { Link } from "@/i18n/navigation";
import { cx } from "@/lib/cx";
import { Icon } from "@/components/ui/Icon";
import { Button } from "@/components/ui/Button";
import { FittedImage } from "@/components/ui/FittedImage";
import { PauseButton } from "@/components/ui/PauseButton";
import { usePrefersReducedMotion } from "@/hooks/usePrefersReducedMotion";
import type { HeroSlide } from "@/types/event";
import styles from "./Hero.module.css";

interface HeroProps {
  slides: HeroSlide[];
}

const AUTOPLAY_INTERVAL = 6000;

export function Hero({ slides }: HeroProps) {
  const t = useTranslations("home.hero");
  const [index, setIndex] = useState(0);
  const [paused, setPaused] = useState(false);
  const [interacting, setInteracting] = useState(false);
  const reducedMotion = usePrefersReducedMotion();
  const slide = slides[index];
  const autoplay = slides.length > 1 && !paused && !interacting && !reducedMotion;

  const prev = () => setIndex((i) => (i - 1 + slides.length) % slides.length);
  const next = () => setIndex((i) => (i + 1) % slides.length);

  useEffect(() => {
    if (!autoplay) return;
    const timer = setInterval(() => {
      setIndex((i) => (i + 1) % slides.length);
    }, AUTOPLAY_INTERVAL);
    return () => clearInterval(timer);
  }, [autoplay, slides.length, index]);

  return (
    <section
      className={styles.hero}
      onMouseEnter={() => setInteracting(true)}
      onMouseLeave={() => setInteracting(false)}
      onFocus={() => setInteracting(true)}
      onBlur={(e) => {
        if (!e.currentTarget.contains(e.relatedTarget as Node | null)) setInteracting(false);
      }}
    >
      <Link href={slide.href} className={styles.imageWrap} aria-label={slide.image ? undefined : slide.title}>
        {slide.image ? (
          <FittedImage
            key={slide.href}
            source={slide.image}
            mobileSource={slide.mobileImage}
            alt={slide.title}
            imageClassName={styles.image}
          />
        ) : (
          <div className={styles.imagePlaceholder}>
            <Icon name="ticket" size={40} className={styles.imagePlaceholderIcon} />
            <span className={cx("body-sm-regular", styles.imagePlaceholderText)}>{t("imagePlaceholder")}</span>
          </div>
        )}
      </Link>

      <div className={styles.infoBar}>
        <div className={styles.infoBg}>
          {slide.image && (
            <picture key={slide.href}>
              {slide.mobileImage && <source media="(max-width: 767px)" srcSet={slide.mobileImage.src} />}
              <img className={styles.infoBgImage} src={slide.image.src} alt="" />
            </picture>
          )}
          <div className={styles.infoBgOverlay} />
        </div>

        <div className={styles.infoContent}>
          <div className={styles.cta}>
            <Button href={slide.href} className={styles.ctaButton}>
              {t("cta")}
            </Button>
            {slide.priceFrom && (
              <div className={styles.priceCol}>
                <span className={cx("caption-md-regular", styles.priceLabel)}>{t("priceFrom")}</span>
                <span className={cx("heading-h6", styles.priceValue)}>{slide.priceFrom}</span>
              </div>
            )}
          </div>

          <div className={styles.meta}>
            <span className={cx("body-md-regular", styles.metaItem)}>
              <span className={styles.metaIcon}>
                <Icon name="calendar" size={14} />
              </span>
              {slide.date}
            </span>
            <span className={cx("body-sm-regular", styles.metaDivider)}>·</span>
            <span className={cx("body-md-regular", styles.metaItem)}>
              <span className={styles.metaIcon}>
                <Icon name="map" size={14} />
              </span>
              {slide.location}
            </span>
          </div>

          <div className={styles.arrows}>
            {slides.length > 1 && (
              <PauseButton
                paused={paused || reducedMotion}
                onToggle={() => setPaused((p) => !p)}
                subject="slides"
                className={styles.arrowButton}
              />
            )}
            {slides.length > 1 && (
              <svg
                key={`${index}-${autoplay}`}
                className={cx(styles.progressRing, !autoplay && styles.progressRingPaused)}
                viewBox="0 0 36 36"
                width={36}
                height={36}
                aria-hidden="true"
              >
                <circle className={styles.progressRingTrack} cx="18" cy="18" r="15" />
                <circle
                  className={styles.progressRingFill}
                  cx="18"
                  cy="18"
                  r="15"
                  style={{ animationDuration: `${AUTOPLAY_INTERVAL}ms` }}
                />
              </svg>
            )}
            <button className={styles.arrowButton} onClick={prev} aria-label={t("prev")}>
              <Icon name="arrow-left" size={16} />
            </button>
            <button className={styles.arrowButton} onClick={next} aria-label={t("next")}>
              <Icon name="arrow-right" size={16} />
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}
