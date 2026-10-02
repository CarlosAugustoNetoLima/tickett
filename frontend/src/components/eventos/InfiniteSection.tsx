"use client";

import { useEffect, useRef, useState } from "react";
import { eventosQuery, type EventosFilters } from "@/lib/eventos-filters";
import type { EventCardData } from "@/types/event";
import { Section } from "./Section";
import styles from "./Section.module.css";

interface InfiniteSectionProps {
  title: string;
  count: number;
  initialEvents: EventCardData[];
  initialPage: number;
  totalPages: number;
  excludeHrefs: string[];
  filters: EventosFilters;
  emptyMessage: string;
}

const MAX_EMPTY_PAGE_FETCHES = 5;

export function InfiniteSection({
  title,
  count,
  initialEvents,
  initialPage,
  totalPages,
  excludeHrefs,
  filters,
  emptyMessage,
}: InfiniteSectionProps) {
  const [events, setEvents] = useState(initialEvents);
  const [hasMore, setHasMore] = useState(initialPage < totalPages);
  const seen = useRef(new Set([...excludeHrefs, ...initialEvents.map((e) => e.href)]));
  const pageRef = useRef(initialPage);
  const loadingRef = useRef(false);
  const sentinelRef = useRef<HTMLDivElement>(null);
  const query = eventosQuery(filters).toString();

  useEffect(() => {
    const sentinel = sentinelRef.current;
    if (!sentinel) return;
    let cancelled = false;

    async function loadMore() {
      loadingRef.current = true;
      try {
        let nextPage = pageRef.current;
        for (let attempt = 0; attempt < MAX_EMPTY_PAGE_FETCHES; attempt++) {
          nextPage += 1;
          const params = new URLSearchParams(query);
          params.set("page", String(nextPage));
          const res = await fetch(`/api/eventos?${params}`);
          if (!res.ok || cancelled) return;
          const data: { events: EventCardData[]; page: number; totalPages: number } = await res.json();
          const fresh = data.events.filter((e) => !seen.current.has(e.href));
          fresh.forEach((e) => seen.current.add(e.href));
          if (cancelled) return;

          if (fresh.length > 0 || data.page >= data.totalPages) {
            pageRef.current = data.page;
            setEvents((prev) => [...prev, ...fresh]);
            setHasMore(data.page < data.totalPages);
            return;
          }
          nextPage = data.page;
        }
      } finally {
        if (!cancelled) loadingRef.current = false;
      }
    }

    const observer = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting && !loadingRef.current) loadMore();
      },
      { rootMargin: "600px" }
    );
    observer.observe(sentinel);
    return () => {
      cancelled = true;
      observer.disconnect();
    };
  }, [query, hasMore, events.length]);

  return (
    <Section title={title} count={count} events={events} emptyMessage={hasMore ? undefined : emptyMessage}>
      {hasMore && <div ref={sentinelRef} className={styles.sentinel} />}
    </Section>
  );
}
