"use client";

import "./MapAnimation.css";
import { ScaleToFit } from "./ScaleToFit";

const DOTS: { x: number; y: number }[] = [
  { x: 345, y: 136 },
  { x: 365, y: 112 },
  { x: 380, y: 118 },
  { x: 367, y: 124 },
  { x: 358, y: 134 },
  { x: 310, y: 199 },
  { x: 400, y: 288 },
  { x: 415, y: 307 },
  { x: 411, y: 262 },
  { x: 387, y: 231 },
  { x: 400, y: 270 },
  { x: 329, y: 206 },
  { x: 351, y: 123 },
  { x: 418, y: 331 },
];

const CYCLE_SECONDS = 2.4;

const GOLDEN_RATIO_CONJUGATE = 0.6180339887498949;
function staggeredDelay(index: number) {
  const fraction = (index * GOLDEN_RATIO_CONJUGATE) % 1;
  return fraction * CYCLE_SECONDS;
}

export function MapAnimation() {
  return (
    <ScaleToFit width={840} height={400} focus={{ x: 293, y: 85, width: 150, height: 250 }}>
      <div className="map-visual">
      <img className="map-bg-img" src="/images/map/world-silhouette.png" alt="" />

      {DOTS.map((dot, i) => (
        <div key={i} className="map-dot" style={{ left: dot.x, top: dot.y }}>
          <div
            className="map-dot-ring"
            style={{ animationDelay: `${staggeredDelay(i).toFixed(2)}s` }}
          />
          <div className="map-dot-core" />
        </div>
      ))}
      </div>
    </ScaleToFit>
  );
}
