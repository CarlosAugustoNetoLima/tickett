import type { Metadata } from "next";
import { getTranslations } from "next-intl/server";
import type { Locale } from "@/i18n/routing";
import { Navbar } from "@/components/layout/Navbar";
import { MobileNavbar } from "@/components/mobile/Menu";
import { Footer } from "@/components/layout/Footer";
import { Hero } from "@/components/home/Hero";
import { Top10 } from "@/components/home/Top10";
import { FeaturedGrid } from "@/components/home/FeaturedGrid";
import { WhyChooseUs } from "@/components/home/WhyChooseUs";
import { AlertasWhatsapp } from "@/components/home/AlertasWhatsapp";
import { Promotor } from "@/components/home/Promotor";
import { JsonLd } from "@/components/seo/JsonLd";
import { SUPPORT_EMAIL } from "@/lib/contact";
import { getHomeData } from "@/lib/home-data";
import { absoluteUrl, pageMetadata, SITE_NAME, SITE_URL } from "@/lib/seo";
import styles from "./page.module.css";

export const revalidate = 60;
// Só existem as 4 línguas do layout. Um ficheiro que não existe na raiz (/apple-touch-icon.png,
// /wp-login.php…) não passa pelo proxy e caía aqui como se fosse a língua: renderizava a home e
// dava 500. Assim responde 404 sem renderizar nada.
export const dynamicParams = false;

interface HomePageProps {
  params: Promise<{ locale: Locale }>;
}

export async function generateMetadata({ params }: HomePageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "metadata" });
  return pageMetadata({ locale, path: "", title: t("title"), description: t("description"), absoluteTitle: true });
}

export default async function HomePage({ params }: HomePageProps) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "metadata" });
  const { heroSlides, top10Events, featuredGridEvents } = await getHomeData();

  return (
    <>
      <JsonLd
        data={{
          "@context": "https://schema.org",
          "@graph": [
            {
              "@type": "Organization",
              "@id": `${SITE_URL}/#organization`,
              name: SITE_NAME,
              url: SITE_URL,
              logo: absoluteUrl("/brand/favicon.png"),
              email: SUPPORT_EMAIL,
            },
            {
              "@type": "WebSite",
              "@id": `${SITE_URL}/#website`,
              name: SITE_NAME,
              url: absoluteUrl(`/${locale}`),
              description: t("description"),
              inLanguage: locale,
              publisher: { "@id": `${SITE_URL}/#organization` },
              potentialAction: {
                "@type": "SearchAction",
                target: { "@type": "EntryPoint", urlTemplate: absoluteUrl(`/${locale}/eventos?busca={search_term_string}`) },
                "query-input": "required name=search_term_string",
              },
            },
          ],
        }}
      />
      <Navbar />
      <MobileNavbar />
      <main>
        <h1 className="sr-only">{t("title")}</h1>
        <Hero slides={heroSlides} />
        <Top10 events={top10Events} />
        <FeaturedGrid events={featuredGridEvents} />
        <WhyChooseUs />
        <div className={styles.spacer} />
        <AlertasWhatsapp />
        <div className={styles.spacer} />
        <Promotor />
        <div className={styles.spacer} />
      </main>
      <Footer />
    </>
  );
}
