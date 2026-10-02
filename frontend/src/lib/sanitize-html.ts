const ALLOWED_TAGS = new Set([
  "p", "br", "div", "span", "b", "strong", "i", "em", "u", "ul", "ol", "li", "a", "blockquote", "h2", "h3", "h4",
]);
const DROPPED_WITH_CONTENT =
  /<(script|style|iframe|object|embed|noscript|template|svg|math|textarea|select|button|form)\b[\s\S]*?<\/\1\s*>/gi;
const SAFE_HREF = /^(https?:|mailto:)/i;

function sanitizeLink(attrs: string): string {
  const match = attrs.match(/\bhref\s*=\s*(?:"([^"]*)"|'([^']*)'|([^\s"'>]+))/i);
  const href = (match?.[1] ?? match?.[2] ?? match?.[3] ?? "").trim();
  return SAFE_HREF.test(href)
    ? `<a href="${href.replace(/"/g, "&quot;")}" target="_blank" rel="noopener noreferrer">`
    : "<a>";
}

export function sanitizeHtml(html: string): string {
  return html
    .replace(/<!--[\s\S]*?-->/g, "")
    .replace(DROPPED_WITH_CONTENT, "")
    .replace(/<\/?([a-zA-Z][a-zA-Z0-9]*)\b([^>]*)>/g, (tag: string, rawName: string, attrs: string) => {
      const name = rawName.toLowerCase();
      if (!ALLOWED_TAGS.has(name)) return "";
      if (tag.startsWith("</")) return `</${name}>`;
      return name === "a" ? sanitizeLink(attrs) : `<${name}>`;
    });
}
