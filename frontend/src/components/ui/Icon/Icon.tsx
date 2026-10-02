import {
  Add,
  ArrowDown2,
  ArrowLeft,
  ArrowRight,
  Calendar,
  Category,
  Chart,
  Cpu,
  TickCircle,
  Clock,
  CloseCircle,
  Copy,
  Facebook,
  Global,
  Home2,
  Instagram,
  Map1,
  Minus,
  Monitor,
  Pause,
  Play,
  Profile2User,
  SearchNormal,
  ScanBarcode,
  ShoppingBag,
  Share,
  Sms,
  Ticket,
  Whatsapp,
  Scan,
  SecurityCard,
  Headphone,
  HambergerMenu,
  Sort,
  Warning2,
} from "iconsax-react";

const X_PATH = "M18 6 6 18M6 6l12 12";

function XIcon({ size = 24, color = "currentColor" }: { size?: string | number; color?: string }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path d={X_PATH} stroke={color} strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  );
}

function TickIcon({ size = 24, color = "currentColor" }: { size?: string | number; color?: string }) {
  return (
    <svg width={size} height={size} viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path d="M1.75 7L5.24588 10.5L12.25 3.5" stroke={color} strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  );
}

function TikTokIcon({ size = 24, color = "currentColor" }: { size?: string | number; color?: string }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path
        d="M16.5 3c.35 2.1 1.86 3.71 3.9 3.98v2.75a6.6 6.6 0 0 1-3.9-1.25v6.35a5.68 5.68 0 1 1-4.9-5.63v2.83a2.87 2.87 0 1 0 2.02 2.74V3h2.88Z"
        stroke={color}
        strokeWidth="1.3"
        strokeLinejoin="round"
      />
    </svg>
  );
}

export type IconName =
  | "add"
  | "arrow-down"
  | "arrow-left"
  | "arrow-right"
  | "calendar"
  | "category"
  | "chart"
  | "cpu"
  | "check-mark"
  | "clock"
  | "close"
  | "copy"
  | "facebook"
  | "global"
  | "home-2"
  | "instagram"
  | "map"
  | "minus"
  | "monitor"
  | "profile-2user"
  | "pause"
  | "play"
  | "search-normal"
  | "share-2"
  | "sms"
  | "tick"
  | "ticket"
  | "tiktok"
  | "whatsapp"
  | "x"
  | "scan"
  | "scan-barcode"
  | "shopping-bag"
  | "security-card"
  | "headphone"
  | "menu"
  | "sort"
  | "warning";

interface IconProps {
  name: IconName;
  size?: string | number;
  color?: string;
  className?: string;
}

export function Icon({ name, size = 24, color = "currentColor", className }: IconProps) {
  switch (name) {
    case "add":
      return <Add size={size} color={color} variant="Linear" className={className} />;
    case "arrow-down":
      return <ArrowDown2 size={size} color={color} variant="Linear" className={className} />;
    case "arrow-left":
      return <ArrowLeft size={size} color={color} variant="Linear" className={className} />;
    case "arrow-right":
      return <ArrowRight size={size} color={color} variant="Linear" className={className} />;
    case "calendar":
      return <Calendar size={size} color={color} variant="Linear" className={className} />;
    case "category":
      return <Category size={size} color={color} variant="Linear" className={className} />;
    case "chart":
      return <Chart size={size} color={color} variant="Linear" className={className} />;
    case "cpu":
      return <Cpu size={size} color={color} variant="Linear" className={className} />;
    case "check-mark":
      return <TickCircle size={size} color={color} variant="Linear" className={className} />;
    case "clock":
      return <Clock size={size} color={color} variant="Linear" className={className} />;
    case "close":
      return <CloseCircle size={size} color={color} variant="Linear" className={className} />;
    case "copy":
      return <Copy size={size} color={color} variant="Linear" className={className} />;
    case "facebook":
      return <Facebook size={size} color={color} variant="Linear" className={className} />;
    case "global":
      return <Global size={size} color={color} variant="Linear" className={className} />;
    case "home-2":
      return <Home2 size={size} color={color} variant="Linear" className={className} />;
    case "instagram":
      return <Instagram size={size} color={color} variant="Linear" className={className} />;
    case "map":
      return <Map1 size={size} color={color} variant="Linear" className={className} />;
    case "minus":
      return <Minus size={size} color={color} variant="Linear" className={className} />;
    case "monitor":
      return <Monitor size={size} color={color} variant="Linear" className={className} />;
    case "profile-2user":
      return <Profile2User size={size} color={color} variant="Linear" className={className} />;
    case "pause":
      return <Pause size={size} color={color} variant="Bold" className={className} />;
    case "play":
      return <Play size={size} color={color} variant="Bold" className={className} />;
    case "search-normal":
      return <SearchNormal size={size} color={color} variant="Linear" className={className} />;
    case "share-2":
      return <Share size={size} color={color} variant="Linear" className={className} />;
    case "sms":
      return <Sms size={size} color={color} variant="Linear" className={className} />;
    case "tick":
      return <TickIcon size={size} color={color} />;
    case "ticket":
      return <Ticket size={size} color={color} variant="Linear" className={className} />;
    case "whatsapp":
      return <Whatsapp size={size} color={color} variant="Linear" className={className} />;
    case "tiktok":
      return <TikTokIcon size={size} color={color} />;
    case "x":
      return <XIcon size={size} color={color} />;
    case "scan":
      return <Scan size={size} color={color} variant="Linear" className={className} />;
    case "scan-barcode":
      return <ScanBarcode size={size} color={color} variant="Linear" className={className} />;
    case "shopping-bag":
      return <ShoppingBag size={size} color={color} variant="Linear" className={className} />;
    case "security-card":
      return <SecurityCard size={size} color={color} variant="Linear" className={className} />;
    case "headphone":
      return <Headphone size={size} color={color} variant="Linear" className={className} />;
    case "menu":
      return <HambergerMenu size={size} color={color} variant="Linear" className={className} />;
    case "sort":
      return <Sort size={size} color={color} variant="Linear" className={className} />;
    case "warning":
      return <Warning2 size={size} color={color} variant="Linear" className={className} />;
    default:
      return null;
  }
}
