import { CheckoutModal } from "@/components/checkout/CheckoutModal";

export default async function CheckoutModalPage({ params }: { params: Promise<{ path: string[] }> }) {
  const { path } = await params;
  return <CheckoutModal path={path} variant="modal" />;
}
