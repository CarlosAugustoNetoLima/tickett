"use client";

import { useCallback, useEffect, useState } from "react";
import { useTranslations } from "next-intl";
import { Link } from "@/i18n/navigation";
import { cx } from "@/lib/cx";
import { Icon } from "@/components/ui/Icon";
import { Button } from "@/components/ui/Button";
import { FittedImage } from "@/components/ui/FittedImage";
import { PauseButton } from "@/components/ui/PauseButton";
import { MOBILE_BREAKPOINT } from "@/hooks/useBreakpoint";
import { usePrefersReducedMotion } from "@/hooks/usePrefersReducedMotion";
import type { HeroSlide } from "@/types/event";
import styles from "./Hero.module.css";

interface HeroProps {
  slides: HeroSlide[];
}

interface Position {
  index: number;
  previous: number | null;
  changed: boolean;
}

interface Layer {
  slide: HeroSlide;
  leaving: boolean;
  entering: boolean;
}

const AUTOPLAY_INTERVAL = 6000;
const INITIAL_POSITION: Position = { index: 0, previous: null, changed: false };

function fadeClass({ leaving, entering }: Layer, idle?: string) {
  if (leaving) return styles.fadeOut;
  if (entering) return cx(styles.fadeIn, styles.afterFadeOut);
  return idle;
}

function ImageLayer({ onSettled, ...layer }: Layer & { onSettled: () => void }) {
  const t = useTranslations("home.hero");
  const { slide, leaving } = layer;

  return (
    <span
      className={cx(styles.layer, fadeClass(layer, styles.fadeIn))}
      aria-hidden={leaving || undefined}
      onAnimationEnd={leaving ? undefined : onSettled}
    >
      {slide.image ? (
        <FittedImage source={slide.image} mobileSource={slide.mobileImage} alt={slide.title} />
      ) : (
        <div className={styles.imagePlaceholder}>
          <Icon name="ticket" size={40} className={styles.imagePlaceholderIcon} />
          <span className={cx("body-sm-regular", styles.imagePlaceholderText)}>{t("imagePlaceholder")}</span>
        </div>
      )}
    </span>
  );
}

function BackdropLayer(layer: Layer) {
  const { slide } = layer;
  if (!slide.image) return null;

  return (
    <span className={cx(styles.layer, fadeClass(layer, styles.fadeIn))}>
      <picture>
        {slide.mobileImage && <source media="(max-width: 767px)" srcSet={slide.mobileImage.src} />}
        <img className={styles.infoBgImage} src={slide.image.src} alt="" />
      </picture>
    </span>
  );
}

function PriceLayer(layer: Layer) {
  const t = useTranslations("home.hero");

  return (
    <div
      className={cx(styles.priceCol, layer.leaving && styles.stacked, fadeClass(layer))}
      aria-hidden={layer.leaving || undefined}
    >
      <span className={cx("caption-md-regular", styles.priceLabel)}>{t("priceFrom")}</span>
      <span className={cx("heading-h6", styles.priceValue)}>{layer.slide.priceFrom}</span>
    </div>
  );
}

function MetaLayer(layer: Layer) {
  return (
    <div
      className={cx(styles.meta, layer.leaving && styles.stacked, fadeClass(layer))}
      aria-hidden={layer.leaving || undefined}
    >
      <span className={cx("body-md-regular", styles.metaItem)}>
        <span className={styles.metaIcon}>
          <Icon name="calendar" size={14} />
        </span>
        {layer.slide.date}
      </span>
      <span className={cx("body-sm-regular", styles.metaDivider)}>·</span>
      <span className={cx("body-md-regular", styles.metaItem)}>
        <span className={styles.metaIcon}>
          <Icon name="map" size={14} />
        </span>
        {layer.slide.location}
      </span>
    </div>
  );
}

export function Hero({ slides }: HeroProps) {
  const t = useTranslations("home.hero");
  const [{ index, previous, changed }, setPosition] = useState(INITIAL_POSITION);
  const [paused, setPaused] = useState(false);
  const [interacting, setInteracting] = useState(false);
  const reducedMotion = usePrefersReducedMotion();
  const slide = slides[index];
  const leaving = previous === null ? null : slides[previous];
  const layers: Layer[] = (leaving ? [leaving, slide] : [slide]).map((item) => ({
    slide: item,
    leaving: item !== slide,
    entering: item === slide && changed,
  }));
  const autoplay = slides.length > 1 && !paused && !interacting && !reducedMotion;

  const go = useCallback(
    (step: number) =>
      setPosition((position) => {
        const next = (position.index + step + slides.length) % slides.length;
        if (next === position.index) return position;
        return { index: next, previous: position.changed ? null : position.index, changed: true };
      }),
    [slides.length]
  );
  const settle = () =>
    setPosition((position) => (position.changed ? { ...position, previous: null, changed: false } : position));

  useEffect(() => {
    if (!autoplay) return;
    const timer = setInterval(() => go(1), AUTOPLAY_INTERVAL);
    return () => clearInterval(timer);
  }, [autoplay, go, index]);

  useEffect(() => {
    const upcoming = slides[(index + 1) % slides.length];
    const narrow = window.matchMedia(`(max-width: ${MOBILE_BREAKPOINT - 1}px)`).matches;
    const source = narrow ? (upcoming.mobileImage ?? upcoming.image) : upcoming.image;
    if (source) new Image().src = source.src;
  }, [index, slides]);

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
        {layers.map((layer) => (
          <ImageLayer key={layer.slide.href} {...layer} onSettled={settle} />
        ))}
      </Link>

      <div className={styles.infoBar}>
        <div className={styles.infoBg}>
          {layers.map((layer) => (
            <BackdropLayer key={layer.slide.href} {...layer} />
          ))}
          <div className={styles.infoBgOverlay} />
        </div>

        <div className={styles.infoContent}>
          <div className={styles.cta}>
            <Button href={slide.href} className={styles.ctaButton}>
              {t("cta")}
            </Button>
            {slide.priceFrom && (
              <div className={styles.priceStack}>
                {layers.map(
                  (layer) => layer.slide.priceFrom && <PriceLayer key={layer.slide.href} {...layer} />
                )}
              </div>
            )}
          </div>

          <div className={styles.metaStack}>
            {layers.map((layer) => (
              <MetaLayer key={layer.slide.href} {...layer} />
            ))}
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
            <button className={styles.arrowButton} onClick={() => go(-1)} aria-label={t("prev")}>
              <Icon name="arrow-left" size={16} />
            </button>
            <button className={styles.arrowButton} onClick={() => go(1)} aria-label={t("next")}>
              <Icon name="arrow-right" size={16} />
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}
