type ImageFit = "cover" | "contain";

export interface FittedSource {
  src: string;
  fit: ImageFit;
}

/** As duas imagens de um evento: o banner (1440×340) e a imagem do evento (3:2). */
export interface EventImageSources {
  banner: string | null;
  thumbnail: string | null;
}

export function isBannerImage(url: string | null | undefined): boolean {
  return !!url && url.includes("banner_principal");
}

// Cada lugar mostra sempre a sua imagem, a cobrir a moldura. Só quando o evento não a tem
// entra a outra, inteira e sobre o fundo desfocado do FittedImage.
function fitted(own: string | null, other: string | null): FittedSource | null {
  if (own) return { src: own, fit: "cover" };
  return other ? { src: other, fit: "contain" } : null;
}

/** Cartões e miniaturas: a imagem do evento. */
export function toCardImage({ banner, thumbnail }: EventImageSources): FittedSource | null {
  return fitted(thumbnail, banner);
}

// Hero da home e topo do detalhe: o banner no desktop. A moldura tem a proporção do banner
// do formulário (1440×340) e a imagem entra inteira ("contain"); se o arquivo fugir desta
// proporção, o fundo desfocado do FittedImage preenche o resto. No telemóvel (até 767 px) a
// moldura tem 240 px de altura e a largura do ecrã, quase 3:2, e aí vai sempre a imagem do
// evento, como nos cartões: o banner (1440×340) ficaria uma faixa fina.
export function toHeroImages(images: EventImageSources): {
  image: FittedSource | null;
  mobileImage: FittedSource | null;
} {
  const image: FittedSource | null = images.banner
    ? { src: images.banner, fit: "contain" }
    : fitted(null, images.thumbnail);
  return { image, mobileImage: toCardImage(images) };
}
