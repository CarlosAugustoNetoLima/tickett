import { readFile } from "node:fs/promises";
import { join } from "node:path";
import { ImageResponse } from "next/og";
import { getTranslations } from "next-intl/server";
import { routing, type Locale } from "@/i18n/routing";

export const size = { width: 1200, height: 630 };
export const contentType = "image/png";
export const alt = "Tickett.com";

const readAsset = (name: string) => readFile(join(process.cwd(), "src/assets/og", name));

export function generateStaticParams() {
  return routing.locales.map((locale) => ({ locale }));
}

export default async function OpenGraphImage({ params }: { params: Promise<{ locale: Locale }> }) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "seo" });
  const [logo, bebas, inter, interBold] = await Promise.all([
    readAsset("logo-white.png"),
    readAsset("BebasNeue-Regular.ttf"),
    readAsset("Inter-Regular.ttf"),
    readAsset("Inter-Bold.ttf"),
  ]);

  return new ImageResponse(
    (
      <div
        style={{
          width: "100%",
          height: "100%",
          display: "flex",
          flexDirection: "column",
          justifyContent: "space-between",
          padding: "72px 80px",
          backgroundColor: "#0F0F11",
          backgroundImage:
            "radial-gradient(circle at 88% 12%, rgba(0, 177, 227, 0.38), transparent 42%), radial-gradient(circle at 0% 100%, rgba(0, 177, 227, 0.16), transparent 45%)",
          color: "#FFFFFF",
          fontFamily: "Inter",
        }}
      >
        <img src={`data:image/png;base64,${logo.toString("base64")}`} width={430} height={60} alt="" />
        <div style={{ display: "flex", flexDirection: "column", gap: 24 }}>
          <div style={{ fontFamily: "Bebas Neue", fontSize: 112, lineHeight: 1, letterSpacing: 1, maxWidth: 1000 }}>
            {t("ogTagline")}
          </div>
          <div style={{ fontSize: 34, lineHeight: 1.35, color: "#AFAFBC", maxWidth: 940 }}>{t("ogSubtitle")}</div>
        </div>
        <div style={{ display: "flex", fontSize: 30, fontWeight: 700, color: "#00B1E3" }}>tickett.com</div>
      </div>
    ),
    {
      ...size,
      fonts: [
        { name: "Bebas Neue", data: bebas, weight: 400 },
        { name: "Inter", data: inter, weight: 400 },
        { name: "Inter", data: interBold, weight: 700 },
      ],
    }
  );
}
