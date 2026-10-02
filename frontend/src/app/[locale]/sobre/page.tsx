import { legalMetadata, legalPage, SobreVideo } from "@/components/legal";

export const generateMetadata = legalMetadata("sobre");

export default legalPage("sobre", <SobreVideo />);
