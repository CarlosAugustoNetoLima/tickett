"use client";

import { ComponentType, useRef } from "react";
import { useTranslations } from "next-intl";
import gsap from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";
import { useGSAP } from "@gsap/react";
import { cx } from "@/lib/cx";
import { BilheteAnimation } from "./BilheteAnimation";
import { WhatsAppAnimation } from "./WhatsAppAnimation";
import { MapAnimation } from "./MapAnimation";
import {
  AcessosIllustration,
  EquipasIllustration,
  GestaoIllustration,
  IntegracoesIllustration,
  MarketingIllustration,
  MerchandisingIllustration,
  SuporteIllustration,
  WebsitesIllustration,
} from "./illustrations/ServiceIllustrations";
import styles from "./WhyChooseUsBento.module.css";

gsap.registerPlugin(ScrollTrigger, useGSAP);

type ItemKey =
  | "bilhetes"
  | "whatsapp"
  | "mapa"
  | "gestao360"
  | "websites"
  | "marketing"
  | "acessos"
  | "equipas"
  | "integracoes"
  | "merchandising"
  | "suporte";

interface Item {
  key: ItemKey;
  area: string;
  kind: "image" | "service";
  Visual: ComponentType;
}

const ITEMS: Item[] = [
  { key: "bilhetes", area: "img1", kind: "image", Visual: BilheteAnimation },
  { key: "websites", area: "s1", kind: "service", Visual: WebsitesIllustration },
  { key: "suporte", area: "s2", kind: "service", Visual: SuporteIllustration },
  { key: "equipas", area: "s3", kind: "service", Visual: EquipasIllustration },
  { key: "mapa", area: "img2", kind: "image", Visual: MapAnimation },
  { key: "acessos", area: "s4", kind: "service", Visual: AcessosIllustration },
  { key: "whatsapp", area: "img3", kind: "image", Visual: WhatsAppAnimation },
  { key: "integracoes", area: "s5", kind: "service", Visual: IntegracoesIllustration },
  { key: "marketing", area: "s6", kind: "service", Visual: MarketingIllustration },
  { key: "merchandising", area: "s7", kind: "service", Visual: MerchandisingIllustration },
  { key: "gestao360", area: "s8", kind: "service", Visual: GestaoIllustration },
];

export function WhyChooseUsBento() {
  const t = useTranslations("home.whyChooseUs");
  const gridRef = useRef<HTMLDivElement>(null);
  const tileMap = useRef<Map<string, HTMLDivElement>>(new Map());

  function registerTile(key: string) {
    return (node: HTMLDivElement | null) => {
      if (node) tileMap.current.set(key, node);
      else tileMap.current.delete(key);
    };
  }

  useGSAP(
    () => {
      const tiles = ITEMS.map((it) => tileMap.current.get(it.key)).filter(
        (el): el is HTMLDivElement => Boolean(el)
      );
      if (!tiles.length) return;

      const mm = gsap.matchMedia();

      mm.add("(prefers-reduced-motion: no-preference)", () => {
        gsap.set(tiles, { autoAlpha: 0, y: 36, scale: 0.96 });

        ScrollTrigger.batch(tiles, {
          start: "top 88%",
          once: true,
          onEnter: (batch) =>
            gsap.to(batch, {
              autoAlpha: 1,
              y: 0,
              scale: 1,
              duration: 0.7,
              ease: "power3.out",
              stagger: 0.08,
              overwrite: true,
            }),
        });
      });

      const cleanups: Array<() => void> = [];
      tiles.forEach((tile) => {
        const setX = gsap.quickSetter(tile, "--mx", "px");
        const setY = gsap.quickSetter(tile, "--my", "px");

        const onMove = (e: PointerEvent) => {
          const rect = tile.getBoundingClientRect();
          setX(e.clientX - rect.left);
          setY(e.clientY - rect.top);
        };

        tile.addEventListener("pointermove", onMove);
        cleanups.push(() => tile.removeEventListener("pointermove", onMove));
      });

      return () => {
        cleanups.forEach((fn) => fn());
        mm.revert();
      };
    },
    { scope: gridRef }
  );

  return (
    <div className={styles.grid} ref={gridRef}>
      {ITEMS.map(({ key, area, kind, Visual }) => {
        const copy = (
          <>
            <div className={styles.divider} />
            <div className={styles.copy}>
              <h3 className={cx("heading-h6", styles.tileTitle)}>{t(`features.${key}.title`)}</h3>
              <p className={cx("body-md-regular", styles.tileDesc)}>{t(`features.${key}.description`)}</p>
            </div>
          </>
        );

        return (
          <div
            key={key}
            ref={registerTile(key)}
            className={cx(
              styles.tile,
              styles[`area-${area}`],
              kind === "image" ? styles.tileImage : styles.tileService
            )}
          >
            <div className={styles.spotlight} aria-hidden="true" />
            <div className={cx(styles.visual, kind === "image" ? styles.visualImage : styles.visualService)}>
              <Visual />
            </div>
            {kind === "image" ? copy : <div className={styles.serviceBody}>{copy}</div>}
          </div>
        );
      })}
    </div>
  );
}
