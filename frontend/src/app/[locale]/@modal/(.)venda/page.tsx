import { VendaWizard } from "@/components/venda";
import { translatedPageMetadata } from "@/lib/seo";

export const generateMetadata = translatedPageMetadata("venda", "/venda");

export default function VendaModal() {
  return <VendaWizard variant="modal" />;
}
