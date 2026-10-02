"use client";

import { useEffect, useRef, useState } from "react";
import { useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import { MOBILE_BREAKPOINT } from "@/hooks/useBreakpoint";
import type { EventoDetalhe as EventoDetalheData } from "@/lib/evento-data";
import { ShareRow } from "./ShareRow";
import { CalendarIcon, ClockIcon, MapIcon, ArrowRightIcon } from "./icons";
import { VideoEmbed } from "./VideoEmbed";
import styles from "./EventoDetalhe.module.css";

interface EventoBodyProps {
  event: EventoDetalheData;
  path: string;
}

const MOBILE_MAX_LINES = 6;

function measureLineHeight(referenceEl: HTMLElement): number {
  const probe = document.createElement("div");
  probe.className = referenceEl.className;
  probe.style.position = "absolute";
  probe.style.visibility = "hidden";
  probe.style.height = "auto";
  probe.style.maxHeight = "none";
  probe.style.width = "auto";
  probe.textContent = "x";
  document.body.appendChild(probe);
  const height = probe.getBoundingClientRect().height;
  document.body.removeChild(probe);
  return height || 24;
}

export function EventoBody({ event, path }: EventoBodyProps) {
  const t = useTranslations("eventoDetalhe");
  const scheduleLabel = [event.timeLabel, event.doorsLabel && t("doorsLabel", { time: event.doorsLabel })]
    .filter(Boolean)
    .join("  ·  ");
  const mapsHref = `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(event.mapsQuery)}`;

  const asideRef = useRef<HTMLDivElement>(null);
  const descriptionBoxRef = useRef<HTMLDivElement>(null);
  const descriptionRef = useRef<HTMLDivElement>(null);

  const [overflowing, setOverflowing] = useState(false);
  const [expanded, setExpanded] = useState(false);
  const [clampHeight, setClampHeight] = useState(0);

  useEffect(() => {
    const descriptionEl = descriptionRef.current;
    const descriptionBoxEl = descriptionBoxRef.current;
    if (!descriptionEl || !descriptionBoxEl) return;

    function measure() {
      const isMobile = window.innerWidth < MOBILE_BREAKPOINT;
      const fullHeight = descriptionEl!.scrollHeight;
      const lineHeight = measureLineHeight(descriptionEl!);

      const limit = isMobile
        ? lineHeight * MOBILE_MAX_LINES
        : Math.max(
            (asideRef.current?.getBoundingClientRect().bottom ?? 0) -
              descriptionBoxEl!.getBoundingClientRect().top,
            lineHeight * 2
          );

      if (fullHeight > limit + lineHeight) {
        setClampHeight(limit);
        setOverflowing(true);
      } else {
        setOverflowing(false);
        setExpanded(false);
      }
    }

    measure();
    const ro = new ResizeObserver(measure);
    ro.observe(descriptionEl);
    if (asideRef.current) ro.observe(asideRef.current);
    window.addEventListener("resize", measure);
    return () => {
      ro.disconnect();
      window.removeEventListener("resize", measure);
    };
  }, [event.description]);

  const clamped = overflowing && !expanded;

  return (
    <div className={styles.body} data-name="Body">
      <div className={styles.aside} ref={asideRef} data-name="Aside">
        <div className={styles.pillsList} data-name="pills">
          <div className={styles.pill}>
            <CalendarIcon size={15} className={styles.pillIcon} />
            <span className={cx("body-sm-regular", styles.pillText)}>{event.dateLabel}</span>
          </div>
          <div className={styles.pill}>
            <ClockIcon size={15} className={styles.pillIcon} />
            <span className={cx("body-sm-regular", styles.pillText)}>{scheduleLabel}</span>
          </div>
          <div className={styles.pill}>
            <MapIcon size={15} className={styles.pillIcon} />
            <span className={cx("body-sm-regular", styles.pillText)}>{event.venueName}</span>
          </div>
        </div>

        <div className={styles.meta} data-name="Meta">
          <div className={styles.field} data-name="local">
            <p className={cx("caption-md-medium", styles.fieldLabel)}>{t("local")}</p>
            <p className={cx("body-md-bold", styles.venueName)}>{event.venueName}</p>
            {event.venueAddress && (
              <p className={cx("body-sm-regular", styles.venueAddress)}>{event.venueAddress}</p>
            )}
            <a href={mapsHref} target="_blank" rel="noopener noreferrer" className={styles.mapsLink}>
              <span className={cx("caption-md-medium", styles.mapsLinkText)}>{t("howToGetThere")}</span>
              <ArrowRightIcon size={14} className={styles.mapsLinkIcon} />
            </a>
          </div>

          {event.parentalRating && (
            <div className={styles.field} data-name="rating">
              <p className={cx("caption-md-medium", styles.fieldLabel)}>{t("parentalRating")}</p>
              <p className={cx("body-md-regular", styles.fieldValue)}>{event.parentalRating}</p>
            </div>
          )}

          {event.promoter && (
            <div className={styles.field} data-name="promoter">
              <p className={cx("caption-md-medium", styles.fieldLabel)}>{t("promoter")}</p>
              <p className={cx("body-md-regular", styles.fieldValue)}>{event.promoter}</p>
            </div>
          )}

          <ShareRow title={event.title} path={path} />
        </div>
      </div>

      <div className={styles.main} data-name="Main">
        {event.videoEmbedUrl && (
          <div className={styles.videoBox} data-name="Video">
            <VideoEmbed src={event.videoEmbedUrl} />
          </div>
        )}

        {event.description && (
          <div className={styles.field} data-name="sobre">
            <p className={cx("caption-md-medium", styles.fieldLabel)}>{t("about")}</p>
            <div className={styles.descriptionBox} ref={descriptionBoxRef}>
              <div
                ref={descriptionRef}
                className={cx("body-md-regular", styles.description, clamped && styles.descriptionClamped)}
                style={clamped ? { maxHeight: clampHeight } : undefined}
                dangerouslySetInnerHTML={{ __html: event.description }}
              />
              {clamped && <div className={styles.descriptionFade} />}
            </div>
            {overflowing && (
              <button
                type="button"
                className={styles.readMoreButton}
                aria-expanded={expanded}
                onClick={() => setExpanded((value) => !value)}
              >
                <span className="caption-md-medium">{expanded ? t("readLess") : t("readMore")}</span>
                <ArrowRightIcon
                  size={12}
                  className={cx(styles.readMoreIcon, expanded && styles.readMoreIconExpanded)}
                />
              </button>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
