import { ReenviarBilheteModal } from "@/components/reenviar-bilhete";
import { translatedPageMetadata } from "@/lib/seo";

export const generateMetadata = translatedPageMetadata("reenviarBilhete", "/reenviar-bilhete");

export default function ReenviarBilheteModalRoute() {
  return <ReenviarBilheteModal variant="modal" />;
}
