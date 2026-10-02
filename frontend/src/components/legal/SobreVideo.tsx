"use client";

import { useEffect, useRef, useState } from "react";
import { PauseButton } from "@/components/ui/PauseButton";
import { usePrefersReducedMotion } from "@/hooks/usePrefersReducedMotion";
import styles from "./SobreVideo.module.css";

export function SobreVideo() {
  const ref = useRef<HTMLVideoElement>(null);
  const reducedMotion = usePrefersReducedMotion();
  const [userPaused, setUserPaused] = useState<boolean | null>(null);
  const paused = userPaused ?? reducedMotion;

  useEffect(() => {
    const video = ref.current;
    if (!video) return;
    let visible = true;

    const sync = () => {
      if (visible && !paused) video.play().catch(() => {});
      else video.pause();
    };

    const observer = new IntersectionObserver(([entry]) => {
      visible = entry.isIntersecting;
      sync();
    });
    observer.observe(video);
    sync();
    return () => observer.disconnect();
  }, [paused]);

  return (
    <div className={styles.frame}>
      <video
        ref={ref}
        className={styles.video}
        src="/videos/sobre-tickett.mp4"
        poster="/videos/sobre-tickett-poster.jpg"
        muted
        loop
        playsInline
        preload="metadata"
        disablePictureInPicture
        aria-hidden="true"
      />
      <PauseButton paused={paused} onToggle={() => setUserPaused(!paused)} subject="video" className={styles.pause} />
    </div>
  );
}
