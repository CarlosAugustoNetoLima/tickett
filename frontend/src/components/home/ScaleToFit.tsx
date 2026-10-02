"use client";

import { useEffect, useRef, useState } from "react";

interface FocusArea {
  x: number;
  y: number;
  width: number;
  height: number;
}

interface ScaleToFitProps {
  width: number;
  height: number;
  focus?: FocusArea;
  children: React.ReactNode;
}

export function ScaleToFit({ width, height, focus, children }: ScaleToFitProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const [scale, setScale] = useState(1);

  const area = focus ?? { x: 0, y: 0, width, height };
  const { x: areaX, y: areaY, width: areaWidth, height: areaHeight } = area;

  const offsetX = width / 2 - (areaX + areaWidth / 2);
  const offsetY = height / 2 - (areaY + areaHeight / 2);

  useEffect(() => {
    const el = containerRef.current;
    if (!el) return;

    const update = () => {
      const { clientWidth, clientHeight } = el;
      if (!clientWidth || !clientHeight) return;
      setScale(Math.min(clientWidth / areaWidth, clientHeight / areaHeight));
    };

    update();
    const ro = new ResizeObserver(update);
    ro.observe(el);
    return () => ro.disconnect();
  }, [areaWidth, areaHeight]);

  return (
    <div
      ref={containerRef}
      style={{
        width: "100%",
        height: "100%",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        overflow: "hidden",
      }}
    >
      <div
        style={{
          width,
          height,
          flexShrink: 0,
          transform: `scale(${scale}) translate(${offsetX}px, ${offsetY}px)`,
          transformOrigin: "center center",
        }}
      >
        {children}
      </div>
    </div>
  );
}
