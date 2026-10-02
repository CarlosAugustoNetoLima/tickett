const WEEKDAY_ANCHOR = Date.UTC(2023, 0, 1);

export function getWeekdays(locale: string): string[] {
  const fmt = new Intl.DateTimeFormat(locale, { weekday: "short", timeZone: "UTC" });
  return Array.from({ length: 7 }, (_, i) => fmt.format(new Date(WEEKDAY_ANCHOR + i * 86400000)));
}

export function getMonths(locale: string): string[] {
  const fmt = new Intl.DateTimeFormat(locale, { month: "long", timeZone: "UTC" });
  return Array.from({ length: 12 }, (_, i) => fmt.format(Date.UTC(2023, i, 1)));
}

function getMonthsAbbr(locale: string): string[] {
  const fmt = new Intl.DateTimeFormat(locale, { month: "short", timeZone: "UTC" });
  return Array.from({ length: 12 }, (_, i) => fmt.format(Date.UTC(2023, i, 1)));
}

interface CalendarDay {
  day: number;
  iso: string;
  outsideMonth?: boolean;
  inRange?: boolean;
  isEndpoint?: boolean;
}

export function pad(n: number): string {
  return String(n).padStart(2, "0");
}

function toISO(year: number, month: number, day: number): string {
  return `${year}-${pad(month + 1)}-${pad(day)}`;
}

function toISODate(d: Date): string {
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`;
}

function addDays(d: Date, n: number): Date {
  const c = new Date(d);
  c.setDate(c.getDate() + n);
  return c;
}

export function buildWeeks(
  year: number,
  month: number,
  startISO?: string | null,
  endISO?: string | null
): CalendarDay[][] {
  const firstWeekday = new Date(year, month, 1).getDay();
  const daysInMonth = new Date(year, month + 1, 0).getDate();
  const daysInPrevMonth = new Date(year, month, 0).getDate();

  const cells: { iso: string; day: number; outsideMonth: boolean }[] = [];

  for (let i = firstWeekday - 1; i >= 0; i--) {
    const day = daysInPrevMonth - i;
    const prevMonth = month === 0 ? 11 : month - 1;
    const prevYear = month === 0 ? year - 1 : year;
    cells.push({ iso: toISO(prevYear, prevMonth, day), day, outsideMonth: true });
  }

  for (let day = 1; day <= daysInMonth; day++) {
    cells.push({ iso: toISO(year, month, day), day, outsideMonth: false });
  }

  let nextDay = 1;
  while (cells.length < 42) {
    const nextMonth = month === 11 ? 0 : month + 1;
    const nextYear = month === 11 ? year + 1 : year;
    cells.push({ iso: toISO(nextYear, nextMonth, nextDay), day: nextDay, outsideMonth: true });
    nextDay++;
  }

  const weeks: CalendarDay[][] = [];
  for (let w = 0; w < 6; w++) {
    weeks.push(
      cells.slice(w * 7, w * 7 + 7).map((cell) => ({
        day: cell.day,
        iso: cell.iso,
        outsideMonth: cell.outsideMonth,
        inRange: !!startISO && !!endISO && cell.iso > startISO && cell.iso < endISO,
        isEndpoint: cell.iso === startISO || cell.iso === endISO,
      }))
    );
  }
  return weeks;
}

export function formatRangeSummary(locale: string, startISO?: string | null, endISO?: string | null): string | null {
  if (!startISO) return null;
  const monthAbbr = getMonthsAbbr(locale);
  const [sy, sm, sd] = startISO.split("-").map(Number);
  const startLabel = `${sd} ${monthAbbr[sm - 1]}`;
  if (!endISO || endISO === startISO) return `${startLabel} ${sy}`;
  const [ey, em, ed] = endISO.split("-").map(Number);
  return `${startLabel} – ${ed} ${monthAbbr[em - 1]} ${ey}`;
}

export function formatEventDateLabel(dateStart: string, locale: string): string {
  const [datePart] = dateStart.split(" ");
  const [year, month, day] = datePart.split("-").map(Number);
  const weekday = getWeekdays(locale)[new Date(year, month - 1, day).getDay()];
  const monthAbbr = getMonthsAbbr(locale)[month - 1];
  return `${weekday}, ${pad(day)} ${monthAbbr} ${year}`;
}

export function formatEventTime(dateStart: string): string {
  const [, timePart] = dateStart.split(" ");
  const [hour, minute] = timePart.split(":");
  return `${hour}:${minute}h`;
}

function formatShortDate(iso: string): string {
  const [, m, d] = iso.split("-");
  return `${d}/${m}`;
}

export function formatShortRange(start?: string | null, end?: string | null): string | null {
  if (!start) return null;
  if (!end || end === start) return formatShortDate(start);
  return `${formatShortDate(start)}-${formatShortDate(end)}`;
}

export const QUICK_DATE_KEYS = [
  "hoje",
  "amanha",
  "fim-de-semana",
  "proxima-semana",
  "este-mes",
  "proximo-mes",
] as const;

export type QuickDateKey = (typeof QUICK_DATE_KEYS)[number];

export function quickDateRange(key: QuickDateKey): { start: string; end: string } {
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  switch (key) {
    case "hoje":
      return { start: toISODate(today), end: toISODate(today) };
    case "amanha": {
      const t = addDays(today, 1);
      return { start: toISODate(t), end: toISODate(t) };
    }
    case "fim-de-semana": {
      const dow = today.getDay();
      if (dow === 0) return { start: toISODate(today), end: toISODate(today) };
      const sat = addDays(today, 6 - dow);
      return { start: toISODate(sat), end: toISODate(addDays(sat, 1)) };
    }
    case "proxima-semana": {
      const dow = today.getDay();
      const nextMon = addDays(today, ((1 - dow + 7) % 7) || 7);
      return { start: toISODate(nextMon), end: toISODate(addDays(nextMon, 6)) };
    }
    case "este-mes": {
      const end = new Date(today.getFullYear(), today.getMonth() + 1, 0);
      return { start: toISODate(today), end: toISODate(end) };
    }
    case "proximo-mes": {
      const start = new Date(today.getFullYear(), today.getMonth() + 1, 1);
      const end = new Date(today.getFullYear(), today.getMonth() + 2, 0);
      return { start: toISODate(start), end: toISODate(end) };
    }
  }
}

export function matchQuickDateKey(start: string | null, end: string | null): QuickDateKey | null {
  if (!start || !end) return null;
  return QUICK_DATE_KEYS.find((key) => {
    const range = quickDateRange(key);
    return range.start === start && range.end === end;
  }) ?? null;
}
