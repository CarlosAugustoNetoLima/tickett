import { cx } from "@/lib/cx";
import type { FittedSource } from "@/lib/image-format";
import styles from "./FittedImage.module.css";

const MOBILE_MEDIA = "(max-width: 767px)";

const FIT_CLASS = {
  "cover:cover": styles.fitCover,
  "cover:contain": styles.fitCoverMobileContain,
  "contain:cover": styles.fitContainMobileCover,
  "contain:contain": styles.fitContain,
} as const;

const BACKDROP_CLASS = {
  "cover:cover": null,
  "cover:contain": styles.backdropMobileOnly,
  "contain:cover": styles.backdropDesktopOnly,
  "contain:contain": "",
} as const;

type Variant = keyof typeof FIT_CLASS;

interface FittedImageProps {
  source: FittedSource;
  mobileSource?: FittedSource | null;
  alt?: string;
  imageClassName?: string;
}

export function FittedImage({ source, mobileSource, alt = "", imageClassName }: FittedImageProps) {
  const mobile = mobileSource ?? source;
  const variant = `${source.fit}:${mobile.fit}` as Variant;
  const backdropClass = BACKDROP_CLASS[variant];
  const narrowSrc = mobile.src === source.src ? null : mobile.src;

  return (
    <span className={styles.frame}>
      {backdropClass !== null && (
        <picture className={styles.picture}>
          {narrowSrc && <source media={MOBILE_MEDIA} srcSet={narrowSrc} />}
          <img className={cx(styles.backdrop, backdropClass)} src={source.src} alt="" aria-hidden="true" />
        </picture>
      )}
      <picture className={styles.picture}>
        {narrowSrc && <source media={MOBILE_MEDIA} srcSet={narrowSrc} />}
        <img className={cx(styles.image, FIT_CLASS[variant], imageClassName)} src={source.src} alt={alt} />
      </picture>
    </span>
  );
}
