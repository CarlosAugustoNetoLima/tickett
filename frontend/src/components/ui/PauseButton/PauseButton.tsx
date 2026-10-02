"use client";

import { useTranslations } from "next-intl";
import { Icon } from "@/components/ui/Icon";

interface PauseButtonProps {
  paused: boolean;
  onToggle: () => void;
  subject: "slides" | "video" | "animations";
  className?: string;
}

export function PauseButton({ paused, onToggle, subject, className }: PauseButtonProps) {
  const t = useTranslations("motion");
  return (
    <button type="button" className={className} onClick={onToggle} aria-label={t(`${paused ? "play" : "pause"}.${subject}`)}>
      <Icon name={paused ? "play" : "pause"} size={14} />
    </button>
  );
}
