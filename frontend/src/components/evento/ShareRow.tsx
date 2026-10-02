"use client";

import { useState, type ComponentType } from "react";
import { useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import {
  ShareIcon,
  CopyIcon,
  SmsIcon,
  XIcon,
  TikTokIcon,
  FacebookIcon,
  InstagramIcon,
  WhatsappIcon,
  type EventoIconProps,
} from "./icons";
import styles from "./ShareRow.module.css";

interface ShareRowProps {
  title: string;
  path: string;
  className?: string;
}

type ShareTarget = "copy" | "sms" | "x" | "tiktok" | "facebook" | "instagram" | "whatsapp";

const TARGETS: { target: ShareTarget; Icon: ComponentType<EventoIconProps> }[] = [
  { target: "copy", Icon: CopyIcon },
  { target: "sms", Icon: SmsIcon },
  { target: "x", Icon: XIcon },
  { target: "tiktok", Icon: TikTokIcon },
  { target: "facebook", Icon: FacebookIcon },
  { target: "instagram", Icon: InstagramIcon },
  { target: "whatsapp", Icon: WhatsappIcon },
];

export function ShareRow({ title, path, className }: ShareRowProps) {
  const t = useTranslations("eventoDetalhe.share");
  const [copied, setCopied] = useState(false);

  function handleClick(target: ShareTarget) {
    const url = `${window.location.origin}${path}`;

    switch (target) {
      case "copy":
      case "tiktok":
      case "instagram":
        navigator.clipboard.writeText(url).then(() => {
          setCopied(true);
          setTimeout(() => setCopied(false), 2000);
        });
        return;
      case "sms":
        window.open(
          `mailto:?subject=${encodeURIComponent(`Tickett — ${title}`)}&body=${encodeURIComponent(t("emailBody", { url }))}`,
          "_self"
        );
        return;
      case "x":
        window.open(
          `https://twitter.com/intent/tweet?text=${encodeURIComponent(`Tickett — ${title}`)}&url=${encodeURIComponent(url)}`,
          "_blank",
          "noopener,noreferrer"
        );
        return;
      case "facebook":
        window.open(
          `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(url)}`,
          "_blank",
          "noopener,noreferrer"
        );
        return;
      case "whatsapp":
        window.open(
          `https://wa.me/?text=${encodeURIComponent(`${title} — ${url}`)}`,
          "_blank",
          "noopener,noreferrer"
        );
        return;
    }
  }

  return (
    <div className={cx(styles.share, className)} data-name="share">
      <div className={styles.label}>
        <ShareIcon size={12} className={styles.labelIcon} />
        <span className={cx("caption-sm-medium", styles.labelText)}>{copied ? t("linkCopied") : t("share")}</span>
      </div>
      <div className={styles.row}>
        {TARGETS.map(({ target, Icon }) => (
          <button
            key={target}
            type="button"
            className={styles.iconButton}
            aria-label={target}
            onClick={() => handleClick(target)}
          >
            <Icon size={18} />
          </button>
        ))}
      </div>
    </div>
  );
}
