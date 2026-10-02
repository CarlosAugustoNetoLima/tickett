"use client";

import { useEffect, useRef, useState, type ReactNode } from "react";
import { cx } from "@/lib/cx";
import styles from "./FadeScroll.module.css";

interface FadeScrollProps {
  className?: string;
  children: ReactNode;
}

export function FadeScroll({ className, children }: FadeScrollProps) {
  const viewportRef = useRef<HTMLDivElement>(null);
  const contentRef = useRef<HTMLDivElement>(null);
  const [fade, setFade] = useState({ start: false, end: false });

  useEffect(() => {
    const viewport = viewportRef.current;
    const content = contentRef.current;
    if (!viewport || !content) return;

    const maxScroll = () => viewport.scrollWidth - viewport.clientWidth;

    const update = () => {
      const start = viewport.scrollLeft > 1;
      const end = viewport.scrollLeft < maxScroll() - 1;
      setFade((prev) => (prev.start === start && prev.end === end ? prev : { start, end }));
    };

    const scrollWithWheel = (e: WheelEvent) => {
      if (Math.abs(e.deltaX) >= Math.abs(e.deltaY)) return;
      const delta = e.deltaMode === WheelEvent.DOM_DELTA_LINE ? e.deltaY * 16 : e.deltaY;
      const next = Math.min(maxScroll(), Math.max(0, viewport.scrollLeft + delta));
      if (Math.abs(next - viewport.scrollLeft) < 1) return;
      e.preventDefault();
      viewport.scrollLeft = next;
    };

    update();
    viewport.addEventListener("scroll", update, { passive: true });
    viewport.addEventListener("wheel", scrollWithWheel, { passive: false });
    const observer = new ResizeObserver(update);
    observer.observe(viewport);
    observer.observe(content);
    return () => {
      viewport.removeEventListener("scroll", update);
      viewport.removeEventListener("wheel", scrollWithWheel);
      observer.disconnect();
    };
  }, []);

  return (
    <div ref={viewportRef} className={cx(styles.viewport, fade.start && styles.fadeStart, fade.end && styles.fadeEnd)}>
      <div ref={contentRef} className={cx(styles.content, className)}>
        {children}
      </div>
    </div>
  );
}
