export interface EventoIconProps {
  size?: number;
  color?: string;
  className?: string;
}

export function CalendarIcon({ size = 15, color = "currentColor", className }: EventoIconProps) {
  return (
    <svg width={size} height={size} viewBox="0 0 15 15" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      <path d="M5 1.25V3.125" stroke={color} strokeMiterlimit="10" strokeLinecap="round" strokeLinejoin="round" />
      <path d="M10 1.25V3.125" stroke={color} strokeMiterlimit="10" strokeLinecap="round" strokeLinejoin="round" />
      <path d="M2.1875 5.68125H12.8125" stroke={color} strokeMiterlimit="10" strokeLinecap="round" strokeLinejoin="round" />
      <path
        d="M13.125 5.3125V10.625C13.125 12.5 12.1875 13.75 10 13.75H5C2.8125 13.75 1.875 12.5 1.875 10.625V5.3125C1.875 3.4375 2.8125 2.1875 5 2.1875H10C12.1875 2.1875 13.125 3.4375 13.125 5.3125Z"
        stroke={color}
        strokeMiterlimit="10"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <path d="M9.80919 8.56251H9.8148" stroke={color} strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
      <path d="M9.80919 10.4375H9.8148" stroke={color} strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
      <path d="M7.49718 8.56251H7.50279" stroke={color} strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
      <path d="M7.49718 10.4375H7.50279" stroke={color} strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
      <path d="M5.18395 8.56251H5.18956" stroke={color} strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
      <path d="M5.18395 10.4375H5.18956" stroke={color} strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  );
}

export function ClockIcon({ size = 15, color = "currentColor", className }: EventoIconProps) {
  return (
    <svg width={size} height={size} viewBox="0 0 15 15" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      <path
        d="M13.75 7.5C13.75 10.95 10.95 13.75 7.5 13.75C4.05 13.75 1.25 10.95 1.25 7.5C1.25 4.05 4.05 1.25 7.5 1.25C10.95 1.25 13.75 4.05 13.75 7.5Z"
        stroke={color}
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <path d="M9.81875 9.4875L7.88125 8.33125C7.54375 8.13125 7.26875 7.65 7.26875 7.25625V4.69375" stroke={color} strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  );
}

export function MapIcon({ size = 15, color = "currentColor", className }: EventoIconProps) {
  return (
    <svg width={size} height={size} viewBox="0 0 15 15" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      <path
        d="M13.75 5.625V9.375C13.75 10.9375 13.4375 12.0313 12.7375 12.7375L8.75 8.75L13.5813 3.91875C13.6938 4.4125 13.75 4.975 13.75 5.625Z"
        stroke={color}
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <path
        d="M13.5813 3.91875L3.91874 13.5812C2.03749 13.15 1.25 11.85 1.25 9.375V5.625C1.25 2.5 2.5 1.25 5.625 1.25H9.375C11.85 1.25 13.15 2.0375 13.5813 3.91875Z"
        stroke={color}
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <path
        d="M12.7375 12.7375C12.0313 13.4375 10.9375 13.75 9.375 13.75H5.625C4.975 13.75 4.41249 13.6937 3.91874 13.5812L8.75 8.75L12.7375 12.7375Z"
        stroke={color}
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <path
        d="M3.89999 4.9875C4.32499 3.15625 7.075 3.15625 7.5 4.9875C7.74375 6.0625 7.06874 6.975 6.47499 7.5375C6.04374 7.95 5.3625 7.95 4.925 7.5375C4.33125 6.975 3.64999 6.0625 3.89999 4.9875Z"
        stroke={color}
      />
      <path d="M5.68413 5.43751H5.68974" stroke={color} strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  );
}

export function ShareIcon({ size = 12, color = "currentColor", className }: EventoIconProps) {
  return (
    <svg width={size} height={size} viewBox="0 0 12 12" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      <path d="M4.8 6.06175C4.8 5.29407 4.17768 4.67175 3.41 4.67175C2.64232 4.67175 2.02 5.29407 2.02 6.06175C2.02 6.82942 2.64232 7.45175 3.41 7.45175C4.17768 7.45175 4.8 6.82942 4.8 6.06175Z" stroke={color} strokeLinecap="round" strokeLinejoin="round" />
      <path d="M9.98113 2.53285C9.98113 1.76518 9.35881 1.14285 8.59113 1.14285C7.82346 1.14285 7.20113 1.76518 7.20113 2.53285C7.20113 3.30053 7.82346 3.92285 8.59113 3.92285C9.35881 3.92285 9.98113 3.30053 9.98113 2.53285Z" stroke={color} strokeLinecap="round" strokeLinejoin="round" />
      <path d="M7.5422 3.33569L4.5422 5.33569" stroke={color} />
      <path d="M9.98113 9.46935C9.98113 10.237 9.35881 10.8593 8.59113 10.8593C7.82346 10.8593 7.20113 10.237 7.20113 9.46935C7.20113 8.70167 7.82346 8.07935 8.59113 8.07935C9.35881 8.07935 9.98113 8.70167 9.98113 9.46935Z" stroke={color} strokeLinecap="round" strokeLinejoin="round" />
      <path d="M7.5422 8.6665L4.5422 6.6665" stroke={color} />
    </svg>
  );
}

export function CopyIcon({ size = 18, color = "currentColor", className }: EventoIconProps) {
  return (
    <svg width={size} height={size} viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      <path d="M16.5 5.175V8.325C16.5 10.95 15.45 12 12.825 12H12V9.675C12 7.05 10.95 6 8.325 6H6V5.175C6 2.55 7.05 1.5 9.675 1.5H12.825C15.45 1.5 16.5 2.55 16.5 5.175Z" stroke={color} strokeLinecap="round" strokeLinejoin="round" />
      <path d="M12 9.675V12.825C12 15.45 10.95 16.5 8.325 16.5H5.175C2.55 16.5 1.5 15.45 1.5 12.825V9.675C1.5 7.05 2.55 6 5.175 6H8.325C10.95 6 12 7.05 12 9.675Z" stroke={color} strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  );
}

export function SmsIcon({ size = 18, color = "currentColor", className }: EventoIconProps) {
  return (
    <svg width={size} height={size} viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      <path
        d="M12.75 15.375H5.25C3 15.375 1.5 14.25 1.5 11.625V6.375C1.5 3.75 3 2.625 5.25 2.625H12.75C15 2.625 16.5 3.75 16.5 6.375V11.625C16.5 14.25 15 15.375 12.75 15.375Z"
        stroke={color}
        strokeMiterlimit="10"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <path d="M12.75 6.75L10.4025 8.625C9.63 9.24 8.3625 9.24 7.59 8.625L5.25 6.75" stroke={color} strokeMiterlimit="10" strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  );
}

export function XIcon({ size = 14.5, color = "currentColor", className }: EventoIconProps) {
  return (
    <svg width={size} height={size} viewBox="0 0 14.5 14.5" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      <path
        d="M0.500002 14L6.161 8.339M6.161 8.339L0.500002 0.5H4.25L8.339 6.161M6.161 8.339L10.25 14H14L8.339 6.161M14 0.5L8.339 6.161"
        stroke={color}
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  );
}

export function TikTokIcon({ size = 18, color = "currentColor", className }: EventoIconProps) {
  return (
    <svg width={size} height={size} viewBox="0 0 13.3008 15.2497" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      <path
        d="M12.8 6.2C12.8 6.365 12.665 6.50075 12.5 6.4925C11.6184 6.4483 10.7575 6.21014 9.9785 5.795C9.76775 5.6825 9.5 5.82875 9.5 6.068V10.25C9.49995 11.1272 9.2435 11.9853 8.76221 12.7187C8.28091 13.4521 7.59575 14.0288 6.791 14.378C5.98624 14.7271 5.09699 14.8334 4.23262 14.6838C3.36824 14.5342 2.56644 14.1353 1.92582 13.536C1.2852 12.9367 0.833712 12.1633 0.626876 11.3108C0.420041 10.4583 0.466881 9.56392 0.761636 8.7377C1.05639 7.91148 1.58621 7.18942 2.28592 6.66034C2.98563 6.13126 3.82473 5.81823 4.7 5.75975C4.73912 5.75768 4.77824 5.7637 4.81492 5.77742C4.85161 5.79115 4.88507 5.81229 4.91323 5.83953C4.94138 5.86676 4.96361 5.89951 4.97854 5.93572C4.99347 5.97194 5.00078 6.01084 5 6.05V8.15C5 8.315 4.865 8.44775 4.7015 8.47475C4.36301 8.53167 4.04786 8.68418 3.79319 8.91431C3.53852 9.14443 3.35496 9.44257 3.26415 9.77358C3.17333 10.1046 3.17905 10.4547 3.28063 10.7825C3.38221 11.1104 3.57541 11.4024 3.83746 11.6241C4.09951 11.8457 4.41948 11.9879 4.75964 12.0337C5.09981 12.0795 5.44598 12.0272 5.75736 11.8827C6.06874 11.7383 6.33233 11.5079 6.51706 11.2186C6.7018 10.9293 6.79997 10.5932 6.8 10.25V0.8C6.8 0.720435 6.83161 0.644129 6.88787 0.587868C6.94413 0.531607 7.02044 0.5 7.1 0.5H9.2C9.28021 0.502045 9.35678 0.533918 9.41475 0.589392C9.47272 0.644866 9.50793 0.719957 9.5135 0.8C9.58364 1.56854 9.92092 2.2882 10.4667 2.83383C11.0125 3.37946 11.7322 3.71655 12.5008 3.7865C12.6658 3.8015 12.8008 3.93425 12.8008 4.1L12.8 6.2Z"
        stroke={color}
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  );
}

export function FacebookIcon({ size = 18, color = "currentColor", className }: EventoIconProps) {
  return (
    <svg width={size} height={size} viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      <path
        d="M10.5 6.975V9.15H12.45C12.6 9.15 12.675 9.3 12.675 9.45L12.375 10.875C12.375 10.95 12.225 11.025 12.15 11.025H10.5V16.5H8.25V11.1H6.975C6.825 11.1 6.75 11.025 6.75 10.875V9.45C6.75 9.3 6.825 9.225 6.975 9.225H8.25V6.75C8.25 5.475 9.225 4.5 10.5 4.5H12.525C12.675 4.5 12.75 4.575 12.75 4.725V6.525C12.75 6.675 12.675 6.75 12.525 6.75H10.725C10.575 6.75 10.5 6.825 10.5 6.975Z"
        stroke={color}
        strokeMiterlimit="10"
        strokeLinecap="round"
      />
      <path
        d="M11.25 16.5H6.75C3 16.5 1.5 15 1.5 11.25V6.75C1.5 3 3 1.5 6.75 1.5H11.25C15 1.5 16.5 3 16.5 6.75V11.25C16.5 15 15 16.5 11.25 16.5Z"
        stroke={color}
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  );
}

export function InstagramIcon({ size = 18, color = "currentColor", className }: EventoIconProps) {
  return (
    <svg width={size} height={size} viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      <path
        d="M6.75 16.5H11.25C15 16.5 16.5 15 16.5 11.25V6.75C16.5 3 15 1.5 11.25 1.5H6.75C3 1.5 1.5 3 1.5 6.75V11.25C1.5 15 3 16.5 6.75 16.5Z"
        stroke={color}
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <path
        d="M9 11.625C10.4497 11.625 11.625 10.4497 11.625 9C11.625 7.55025 10.4497 6.375 9 6.375C7.55025 6.375 6.375 7.55025 6.375 9C6.375 10.4497 7.55025 11.625 9 11.625Z"
        stroke={color}
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <path d="M13.2271 5.25H13.2358" stroke={color} strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  );
}

export function WhatsappIcon({ size = 18, color = "currentColor", className }: EventoIconProps) {
  return (
    <svg width={size} height={size} viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      <path
        d="M5.175 15.45C6.3 16.125 7.65 16.5 9 16.5C13.125 16.5 16.5 13.125 16.5 9C16.5 4.875 13.125 1.5 9 1.5C4.875 1.5 1.5 4.875 1.5 9C1.5 10.35 1.875 11.625 2.475 12.75L1.94044 14.806C1.74572 15.5549 2.43892 16.2317 3.18299 16.0191L5.175 15.45Z"
        stroke={color}
        strokeMiterlimit="10"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <path
        d="M12.375 11.1364C12.375 11.2579 12.348 11.3828 12.2905 11.5043C12.233 11.6258 12.1587 11.7405 12.0607 11.8485C11.895 12.0308 11.7125 12.1624 11.5063 12.2468C11.3035 12.3311 11.0838 12.375 10.8472 12.375C10.5024 12.375 10.134 12.294 9.74531 12.1286C9.3566 11.9633 8.96789 11.7405 8.58256 11.4604C8.19385 11.1769 7.82543 10.863 7.4739 10.5154C7.12575 10.1644 6.8114 9.7965 6.53086 9.41175C6.25369 9.027 6.03061 8.64225 5.86837 8.26088C5.70612 7.87613 5.625 7.50825 5.625 7.15725C5.625 6.92775 5.66556 6.70838 5.74668 6.50588C5.8278 6.3 5.95625 6.111 6.13539 5.94225C6.35172 5.72963 6.58832 5.625 6.83845 5.625C6.93309 5.625 7.02773 5.64525 7.11223 5.68575C7.20011 5.72625 7.27785 5.787 7.3387 5.87475L8.12287 6.97838C8.18371 7.06275 8.22765 7.14038 8.25807 7.21463C8.2885 7.2855 8.3054 7.35638 8.3054 7.4205C8.3054 7.5015 8.28174 7.5825 8.23441 7.66012C8.19047 7.73775 8.12625 7.81875 8.04513 7.89975L7.78824 8.16637C7.75106 8.2035 7.73416 8.24738 7.73416 8.30138C7.73416 8.32838 7.73754 8.352 7.7443 8.379C7.75444 8.406 7.76458 8.42625 7.77134 8.4465C7.83219 8.55787 7.93697 8.703 8.08569 8.8785C8.23779 9.054 8.40004 9.23288 8.5758 9.41175C8.75833 9.59063 8.93409 9.756 9.11323 9.90787C9.289 10.0564 9.43434 10.1576 9.54926 10.2184C9.56616 10.2251 9.58644 10.2352 9.6101 10.2454C9.63714 10.2555 9.66418 10.2589 9.6946 10.2589C9.75207 10.2589 9.79601 10.2386 9.83319 10.2015L10.0901 9.94838C10.1746 9.864 10.2557 9.79988 10.3334 9.75938C10.4112 9.71213 10.4889 9.6885 10.5734 9.6885C10.6376 9.6885 10.7052 9.702 10.7796 9.73238C10.854 9.76275 10.9317 9.80663 11.0162 9.864L12.135 10.6571C12.2229 10.7179 12.2837 10.7887 12.3209 10.8731C12.3547 10.9575 12.375 11.0419 12.375 11.1364Z"
        stroke={color}
        strokeMiterlimit="10"
      />
    </svg>
  );
}

export function ArrowRightIcon({ size = 14, color = "currentColor", className }: EventoIconProps) {
  return (
    <svg width={size} height={size} viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      <path d="M8.4175 3.45917L11.9583 7L8.4175 10.5408" stroke={color} strokeMiterlimit="10" strokeLinecap="round" strokeLinejoin="round" />
      <path d="M2.04167 7H11.8592" stroke={color} strokeMiterlimit="10" strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  );
}

export function TicketIcon({ size = 16, color = "currentColor", className }: EventoIconProps) {
  return (
    <svg width={size} height={size} viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      <path
        d="M13 8.33333C13 7.41333 13.7467 6.66667 14.6667 6.66667V6C14.6667 3.33333 14 2.66667 11.3333 2.66667H4.66667C2 2.66667 1.33333 3.33333 1.33333 6V6.33333C2.25333 6.33333 3 7.08 3 8C3 8.92 2.25333 9.66667 1.33333 9.66667V10C1.33333 12.6667 2 13.3333 4.66667 13.3333H11.3333C14 13.3333 14.6667 12.6667 14.6667 10C13.7467 10 13 9.25333 13 8.33333Z"
        stroke={color}
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <path d="M6.66667 2.66667L6.66667 13.3333" stroke={color} strokeLinecap="round" strokeLinejoin="round" strokeDasharray="5 5" />
    </svg>
  );
}
