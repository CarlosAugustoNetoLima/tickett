const YOUTUBE_ID_PATTERN =
  /(?:youtube(?:-nocookie)?\.com\/(?:watch\?v=|embed\/|shorts\/|live\/)|youtu\.be\/)([a-zA-Z0-9_-]{11})/;

export function getYouTubeEmbedUrl(url: string | null | undefined): string | null {
  if (!url) return null;
  const match = url.match(YOUTUBE_ID_PATTERN);
  if (!match) return null;
  return `https://www.youtube-nocookie.com/embed/${match[1]}`;
}
