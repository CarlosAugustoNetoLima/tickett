import { CSSProperties } from "react";
import "./ServiceIllustrations.css";

function vec(dx: number, dy: number): CSSProperties {
  return { "--dx": `${dx}px`, "--dy": `${dy}px` } as CSSProperties;
}

function delay(seconds: number): CSSProperties {
  return { animationDelay: `${seconds}s` };
}

const HUB_NODES = [
  { x: 64, y: 58, dx: -56, dy: -42 },
  { x: 176, y: 58, dx: 56, dy: -42 },
  { x: 64, y: 142, dx: -56, dy: 42 },
  { x: 176, y: 142, dx: 56, dy: 42 },
];

export function GestaoIllustration() {
  return (
    <svg className="ill" viewBox="0 0 240 200" aria-hidden="true">
      <circle
        className="ill-stroke ill-thin ill-faint ill-orbit"
        cx="120"
        cy="100"
        r="82"
        strokeDasharray="3 9"
      />

      {HUB_NODES.map((node) => (
        <line
          key={`l-${node.x}-${node.y}`}
          className="ill-stroke ill-thin ill-faint"
          x1="120"
          y1="100"
          x2={node.x}
          y2={node.y}
        />
      ))}

      <g className="ill-stroke ill-thin">
        <circle className="ill-soft" cx="64" cy="58" r="18" />
        <line x1="58" y1="63" x2="58" y2="57" />
        <line x1="64" y1="63" x2="64" y2="53" />
        <line x1="70" y1="63" x2="70" y2="50" />

        <circle className="ill-soft" cx="176" cy="58" r="18" />
        <path d="M167 58c4-5 14-5 18 0-4 5-14 5-18 0Z" />
        <circle className="ill-fill" cx="176" cy="58" r="2" />

        <circle className="ill-soft" cx="64" cy="142" r="18" />
        <rect x="61" y="133" width="6" height="11" rx="3" />
        <path d="M57 143a7 7 0 0 0 14 0" />
        <line x1="64" y1="150" x2="64" y2="153" />

        <circle className="ill-soft" cx="176" cy="142" r="18" />
        <circle cx="176" cy="142" r="8" />
        <line x1="176" y1="136" x2="176" y2="148" />
        <line x1="173" y1="139" x2="179" y2="139" />
        <line x1="173" y1="145" x2="179" y2="145" />
      </g>

      {HUB_NODES.map((node, i) => (
        <circle
          key={`p-${node.x}-${node.y}`}
          className="ill-fill ill-packet"
          cx="120"
          cy="100"
          r="2.5"
          style={{ ...vec(node.dx, node.dy), ...delay(i * 0.4) }}
        />
      ))}

      <circle className="ill-stroke ill-soft ill-ring" cx="120" cy="100" r="30" />
      <g className="ill-core">
        <circle className="ill-stroke" cx="120" cy="100" r="22" />
        <circle className="ill-stroke ill-thin ill-soft" cx="120" cy="100" r="13" />
        <circle className="ill-fill" cx="120" cy="100" r="4" />
      </g>
    </svg>
  );
}

export function WebsitesIllustration() {
  return (
    <svg className="ill" viewBox="0 0 240 200" aria-hidden="true">
      <rect className="ill-stroke" x="26" y="30" width="188" height="142" rx="10" />
      <line className="ill-stroke ill-thin ill-faint" x1="26" y1="56" x2="214" y2="56" />
      <g className="ill-fill ill-soft">
        <circle cx="38" cy="43" r="2.5" />
        <circle cx="47" cy="43" r="2.5" />
        <circle cx="56" cy="43" r="2.5" />
      </g>

      <rect className="ill-stroke ill-thin ill-soft" x="68" y="36" width="134" height="14" rx="7" />
      <text className="ill-label ill-soft" x="78" y="46">
        tickett.com
      </text>

      <rect className="ill-stroke ill-block" x="40" y="68" width="160" height="40" rx="5" style={delay(0)} />
      <line className="ill-stroke ill-thin ill-soft ill-block" x1="52" y1="82" x2="108" y2="82" style={delay(0.1)} />
      <line className="ill-stroke ill-thin ill-faint ill-block" x1="52" y1="94" x2="140" y2="94" style={delay(0.15)} />

      <rect className="ill-stroke ill-thin ill-block" x="40" y="116" width="48" height="32" rx="4" style={delay(0.35)} />
      <rect className="ill-stroke ill-thin ill-block" x="96" y="116" width="48" height="32" rx="4" style={delay(0.5)} />
      <rect className="ill-stroke ill-thin ill-block" x="152" y="116" width="48" height="32" rx="4" style={delay(0.65)} />

      <rect className="ill-stroke ill-btn" x="40" y="156" width="56" height="12" rx="6" />
      <g className="ill-cursor">
        <path className="ill-fill" d="M92 150l14 6-6 2-2 6-6-14Z" />
      </g>
    </svg>
  );
}

export function MarketingIllustration() {
  return (
    <svg className="ill" viewBox="0 0 240 200" aria-hidden="true">
      <g className="ill-stroke ill-thin ill-faint">
        <line x1="34" y1="34" x2="34" y2="164" />
        <line x1="34" y1="164" x2="212" y2="164" />
        <line x1="34" y1="130" x2="212" y2="130" strokeDasharray="3 7" />
        <line x1="34" y1="96" x2="212" y2="96" strokeDasharray="3 7" />
      </g>

      <polyline
        className="ill-stroke ill-graph"
        points="34,150 68,132 98,138 128,106 158,114 190,70 210,54"
      />
      <g className="ill-fill ill-soft">
        <circle cx="98" cy="138" r="3" />
        <circle cx="128" cy="106" r="3" />
        <circle cx="190" cy="70" r="3" />
      </g>

      <g className="ill-stroke ill-thin ill-blast" style={{ ...vec(-26, -40), ...delay(0) }}>
        <rect x="90" y="131" width="16" height="12" rx="2" />
        <path d="M90 133l8 6 8-6" />
      </g>
      <g className="ill-stroke ill-thin ill-blast" style={{ ...vec(4, -48), ...delay(0.9) }}>
        <path d="M120 100h16a3 3 0 0 1 3 3v6a3 3 0 0 1-3 3h-9l-5 4v-4h-2a3 3 0 0 1-3-3v-6a3 3 0 0 1 3-3Z" />
      </g>
      <g className="ill-stroke ill-thin ill-blast" style={{ ...vec(24, -26), ...delay(1.8) }}>
        <circle cx="190" cy="70" r="8" />
        <circle cx="190" cy="70" r="3.5" />
      </g>

      <text className="ill-num ill-pct" x="176" y="40">
        +48%
      </text>
    </svg>
  );
}

function Wristband({ shift }: { shift: number }) {
  return (
    <g className="ill-band" style={delay(shift)}>
      <rect className="ill-stroke" x="54" y="88" width="62" height="24" rx="12" />
      <rect className="ill-stroke ill-thin ill-soft" x="92" y="93" width="14" height="14" rx="2" />
      <g className="ill-fill ill-soft">
        <rect x="95" y="96" width="3" height="3" />
        <rect x="101" y="96" width="3" height="3" />
        <rect x="95" y="102" width="3" height="3" />
        <rect x="101" y="102" width="3" height="3" />
      </g>
      <line className="ill-stroke ill-thin ill-faint" x1="62" y1="100" x2="84" y2="100" />
    </g>
  );
}

export function AcessosIllustration() {
  return (
    <svg className="ill" viewBox="0 0 240 200" aria-hidden="true">
      <line className="ill-stroke ill-thin ill-faint" x1="24" y1="128" x2="168" y2="128" strokeDasharray="4 8" />

      <Wristband shift={0} />
      <Wristband shift={1} />
      <Wristband shift={2} />

      <rect className="ill-stroke" x="150" y="44" width="52" height="118" rx="10" />
      <rect className="ill-stroke ill-thin ill-soft" x="161" y="60" width="30" height="30" rx="4" />
      <line className="ill-stroke ill-scan" x1="163" y1="75" x2="189" y2="75" />

      <circle className="ill-ok ill-fill ill-gate-ok" cx="176" cy="106" r="5" />

      <text className="ill-num ill-count-a" x="176" y="136" textAnchor="middle">
        001
      </text>
      <text className="ill-num ill-count-b" x="176" y="136" textAnchor="middle">
        002
      </text>
      <text className="ill-label ill-faint" x="176" y="152" textAnchor="middle">
        LOTAÇÃO
      </text>
    </svg>
  );
}

export function EquipasIllustration() {
  return (
    <svg className="ill" viewBox="0 0 240 200" aria-hidden="true">
      <circle
        className="ill-stroke ill-thin ill-faint ill-link"
        cx="120"
        cy="100"
        r="58"
        strokeDasharray="4 8"
      />

      <g className="ill-team">
        <g className="ill-upright">
          <circle className="ill-stroke ill-thin ill-soft" cx="120" cy="42" r="17" />
          <rect className="ill-stroke ill-thin" x="112" y="39" width="16" height="10" rx="2" />
          <rect className="ill-stroke ill-thin" x="115" y="33" width="10" height="6" rx="1" />
        </g>

        <g className="ill-upright">
          <circle className="ill-stroke ill-thin ill-soft" cx="178" cy="100" r="17" />
          <path className="ill-stroke ill-thin" d="M178 92l8 3v5c0 5-4 8-8 9-4-1-8-4-8-9v-5l8-3Z" />
        </g>

        <g className="ill-upright">
          <circle className="ill-stroke ill-thin ill-soft" cx="120" cy="158" r="17" />
          <path
            className="ill-stroke ill-thin"
            d="M114 152l-4 3 2 4 3-1v9h10v-9l3 1 2-4-4-3-3-1a3 3 0 0 1-6 0l-3 1Z"
          />
        </g>

        <g className="ill-upright">
          <circle className="ill-stroke ill-thin ill-soft" cx="62" cy="100" r="17" />
          <path className="ill-stroke ill-thin" d="M55 102v-2a7 7 0 0 1 14 0v2" />
          <rect className="ill-stroke ill-thin" x="53" y="101" width="5" height="8" rx="2" />
          <rect className="ill-stroke ill-thin" x="66" y="101" width="5" height="8" rx="2" />
        </g>
      </g>

      <circle className="ill-fill ill-soft" cx="120" cy="100" r="3" />
    </svg>
  );
}

const SATELLITES = [
  { x: 48, y: 48, dx: -62, dy: -46 },
  { x: 192, y: 48, dx: 62, dy: -46 },
  { x: 48, y: 152, dx: -62, dy: 46 },
  { x: 192, y: 152, dx: 62, dy: 46 },
];

export function IntegracoesIllustration() {
  return (
    <svg className="ill" viewBox="0 0 240 200" aria-hidden="true">
      {SATELLITES.map((s) => (
        <line
          key={`sl-${s.x}-${s.y}`}
          className="ill-stroke ill-thin ill-faint"
          x1="120"
          y1="100"
          x2={s.x}
          y2={s.y}
        />
      ))}

      <g className="ill-stroke ill-thin">
        <rect x="32" y="32" width="32" height="34" rx="4" />
        <rect className="ill-soft" x="38" y="38" width="20" height="12" rx="2" />
        <line x1="40" y1="57" x2="56" y2="57" />
      </g>

      <g className="ill-stroke ill-thin">
        <rect x="176" y="36" width="34" height="24" rx="4" />
        <path className="ill-soft" d="M184 36v-9h18v9" />
        <line x1="184" y1="52" x2="202" y2="52" />
      </g>

      <g className="ill-stroke ill-thin">
        <path d="M36 158a9 9 0 0 1 2-17 12 12 0 0 1 22-3 9 9 0 0 1 2 20H36Z" />
      </g>

      <g className="ill-stroke ill-thin">
        <rect x="178" y="136" width="30" height="32" rx="4" />
        <line className="ill-soft" x1="184" y1="145" x2="202" y2="145" />
        <line className="ill-soft" x1="184" y1="152" x2="202" y2="152" />
        <line className="ill-soft" x1="184" y1="159" x2="202" y2="159" />
      </g>

      <rect className="ill-stroke" x="92" y="80" width="56" height="40" rx="8" />
      <g className="ill-fill ill-port">
        <circle cx="104" cy="100" r="2.5" />
        <circle cx="120" cy="100" r="2.5" />
        <circle cx="136" cy="100" r="2.5" />
      </g>
      <line className="ill-stroke ill-thin ill-faint" x1="92" y1="90" x2="148" y2="90" />

      {SATELLITES.map((s, i) => (
        <circle
          key={`sp-${s.x}-${s.y}`}
          className="ill-fill ill-data"
          cx="120"
          cy="100"
          r="2.5"
          style={{ ...vec(s.dx, s.dy), ...delay(i * 0.55) }}
        />
      ))}
    </svg>
  );
}

function Garment({ x, sway }: { x: number; sway: number }) {
  return (
    <g className="ill-hang" style={delay(sway)}>
      <path className="ill-stroke ill-thin ill-soft" d={`M${x} 52v-6a4 4 0 0 1 4-4`} />
      <path
        className="ill-stroke"
        d={`M${x - 20} 62l-8 6 5 9 6-3v30h34V74l6 3 5-9-8-6-9-3a8 8 0 0 1-16 0l-9 3Z`}
      />
    </g>
  );
}

export function MerchandisingIllustration() {
  return (
    <svg className="ill" viewBox="0 0 240 200" aria-hidden="true">
      <line className="ill-stroke ill-soft" x1="28" y1="42" x2="212" y2="42" />
      <line className="ill-stroke ill-thin ill-faint" x1="36" y1="42" x2="36" y2="30" />
      <line className="ill-stroke ill-thin ill-faint" x1="204" y1="42" x2="204" y2="30" />

      <Garment x={72} sway={0} />
      <Garment x={152} sway={1.4} />

      <g className="ill-ok ill-sold">
        <rect className="ill-stroke ill-thin" x="108" y="78" width="34" height="15" rx="4" />
        <text className="ill-label" x="125" y="89" textAnchor="middle">
          SOLD
        </text>
      </g>

      <text className="ill-label ill-faint" x="34" y="160">
        STOCK
      </text>
      <text className="ill-num ill-stock-a" x="76" y="161">
        12
      </text>
      <text className="ill-num ill-stock-b" x="76" y="161">
        11
      </text>

      <g className="ill-stroke ill-thin">
        <path d="M158 142h6l6 22h26l6-15h-32" />
        <circle cx="174" cy="172" r="4" />
        <circle cx="192" cy="172" r="4" />
      </g>
    </svg>
  );
}

const INFINITY_PATH =
  "M120 100C104 82 86 74 86 58C86 40 102 28 120 28C138 28 154 40 154 58C154 74 136 82 120 100C104 118 86 126 86 142C86 160 102 172 120 172C138 172 154 160 154 142C154 126 136 118 120 100Z";

export function SuporteIllustration() {
  return (
    <svg className="ill" viewBox="0 0 240 200" aria-hidden="true">
      <g className="ill-loop">
        <path className="ill-stroke ill-soft" d={INFINITY_PATH} />
        <path className="ill-stroke ill-trail" d={INFINITY_PATH} />
      </g>

      <g className="ill-stroke ill-thin">
        <path d="M108 56l6-5 6 4 6-4 6 5" />
        <path d="M109 59l7 7 4-3 4 3 7-7" />
      </g>

      <g className="ill-stroke ill-thin">
        <path d="M108 134h24a4 4 0 0 1 4 4v8a4 4 0 0 1-4 4h-13l-6 5v-5h-5a4 4 0 0 1-4-4v-8a4 4 0 0 1 4-4Z" />
        <g className="ill-fill ill-soft">
          <circle cx="114" cy="142" r="1.6" />
          <circle cx="120" cy="142" r="1.6" />
          <circle cx="126" cy="142" r="1.6" />
        </g>
      </g>

      <circle cx="120" cy="100" r="19" fill="var(--color-bg-tertiary)" />
      <g className="ill-stroke">
        <path d="M110 101v-3a10 10 0 0 1 20 0v3" />
        <rect x="106" y="100" width="7" height="11" rx="3" />
        <rect x="127" y="100" width="7" height="11" rx="3" />
        <path className="ill-thin ill-soft" d="M130 111v2a5 5 0 0 1-5 5h-4" />
      </g>
    </svg>
  );
}
