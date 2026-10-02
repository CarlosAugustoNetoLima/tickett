"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import { Icon } from "@/components/ui/Icon";
import styles from "./EventoDetalhe.module.css";

export function VideoEmbed({ src }: { src: string }) {
  const t = useTranslations("eventoDetalhe");
  const [playing, setPlaying] = useState(false);

  if (playing) {
    return (
      <iframe
        className={styles.videoFrame}
        src={`${src}?autoplay=1`}
        title={t("videoTitle")}
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
        allowFullScreen
      />
    );
  }

  return (
    <button type="button" className={styles.videoPoster} onClick={() => setPlaying(true)}>
      <span className={styles.videoPlay} aria-hidden="true">
        <Icon name="play" size={28} />
      </span>
      <span className={cx("body-md-medium", styles.videoLabel)}>{t("videoPlay")}</span>
      <span className={cx("caption-md-regular", styles.videoNotice)}>{t("videoNotice")}</span>
    </button>
  );
}
