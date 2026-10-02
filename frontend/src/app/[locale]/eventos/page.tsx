import type { ReactNode } from "react";
import type { Metadata } from "next";
import { getTranslations } from "next-intl/server";
import type { Locale } from "@/i18n/routing";
import { Navbar } from "@/components/layout/Navbar";
import { MobileNavbar } from "@/components/mobile/Menu";
import { FilterBarMob } from "@/components/mobile/FilterBarMob";
import { Footer } from "@/components/layout/Footer";
import { Section } from "@/components/eventos/Section";
import { InfiniteSection } from "@/components/eventos/InfiniteSection";
import { getTop10Events } from "@/lib/home-data";
import { sortByDateAsc } from "@/lib/event-cards";
import { getAllEvents, getCategoryEvents, getEventosCatalog, getEventosCount, getEventosList } from "@/lib/eventos-data";
import { buildEventosUrl, hasActiveFilters, parseEventosFilters } from "@/lib/eventos-filters";
import { pageMetadata } from "@/lib/seo";

export const revalidate = 60;

interface EventosPageProps {
  params: Promise<{ locale: Locale }>;
  searchParams: Promise<Record<string, string | string[] | undefined>>;
}

function readFilters(query: Record<string, string | string[] | undefined>) {
  return parseEventosFilters((key) => [query[key]].flat()[0] ?? null);
}

export async function generateMetadata({ params, searchParams }: EventosPageProps): Promise<Metadata> {
  const { locale } = await params;
  const filters = readFilters(await searchParams);
  const t = await getTranslations({ locale, namespace: "seo" });
  const category = filters.categoria
    ? (await getEventosCatalog()).categories.find((c) => c.slug === filters.categoria)
    : undefined;

  if (category) {
    return pageMetadata({
      locale,
      path: buildEventosUrl({ categoria: category.slug }),
      title: t("categoryTitle", { category: category.name }),
      description: t("categoryDescription", { category: category.name }),
    });
  }
  return pageMetadata({
    locale,
    path: "/eventos",
    title: filters.busca ? t("searchTitle", { query: filters.busca }) : t("eventosTitle"),
    description: t("eventosDescription"),
    noindex: !!filters.busca,
  });
}

export default async function EventosPage({ params, searchParams }: EventosPageProps) {
  const { locale } = await params;
  const [t, tSeo] = await Promise.all([
    getTranslations({ locale, namespace: "eventos" }),
    getTranslations({ locale, namespace: "seo" }),
  ]);

  const requested = readFilters(await searchParams);
  const [catalog, category] = await Promise.all([
    getEventosCatalog(),
    requested.categoria ? getCategoryEvents(requested.categoria, requested) : null,
  ]);
  const filters = { ...requested, categoria: category?.category.slug ?? null };

  let content: ReactNode;
  if (filters.busca) {
    // Os dois já aplicam a busca, porque é lá que os eventos ainda têm as palavras-chave.
    const matches = category ? category.events : await getAllEvents(filters);
    content = (
      <Section
        title={
          category
            ? t("resultsForIn", { query: filters.busca, category: category.category.name })
            : t("resultsFor", { query: filters.busca })
        }
        count={matches.length}
        events={matches}
        emptyMessage={t("noResults", { query: filters.busca })}
        headingLevel="h1"
      />
    );
  } else if (category) {
    content = (
      <Section
        title={category.category.name}
        count={category.count}
        events={category.events}
        emptyMessage={t("noResultsFilters")}
        headingLevel="h1"
      />
    );
  } else {
    const [list, total, destaquesRaw] = await Promise.all([
      getEventosList(filters),
      getEventosCount(filters),
      hasActiveFilters(filters) ? [] : getTop10Events(),
    ]);
    // Os destaques vêm por popularidade da API; aqui reordenamos por data porque esta secção
    // convive com "Todos os eventos", que é sempre por data mais próxima primeiro.
    const destaques = sortByDateAsc(destaquesRaw);
    const destaqueHrefs = destaques.map((e) => e.href);
    const others = list.events.filter((e) => !destaqueHrefs.includes(e.href));
    content = (
      <>
        <h1 className="sr-only">{tSeo("eventosTitle")}</h1>
        {destaques.length > 0 && <Section title={t("destaques")} count={destaques.length} events={destaques} />}
        {/* A key recria a lista a cada filtro; sem ela o estado do cliente mantinha os resultados anteriores. */}
        <InfiniteSection
          key={buildEventosUrl(filters)}
          title={t("todos")}
          count={Math.max(total - destaques.length, others.length)}
          initialEvents={others}
          initialPage={list.page}
          totalPages={list.totalPages}
          excludeHrefs={destaqueHrefs}
          filters={filters}
          emptyMessage={t("noResultsFilters")}
        />
      </>
    );
  }

  return (
    <>
      <Navbar filterBar={{ ...catalog, filters }} />
      <MobileNavbar />
      <FilterBarMob {...catalog} filters={filters} />
      <main>{content}</main>
      <Footer />
    </>
  );
}
