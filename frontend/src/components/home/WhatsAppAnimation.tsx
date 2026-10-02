import { useTranslations } from "next-intl";
import "./WhatsAppAnimation.css";
import { ScaleToFit } from "./ScaleToFit";

const ASSET = "/images/bilhete";

function StatusIcons() {
  return (
    <div className="wa-status-icons">
      <svg viewBox="0 0 24 24" width="10" height="10" fill="none" stroke="#fff" strokeWidth="2">
        <path d="M2 8.5c6-5.5 14-5.5 20 0M5.5 12c4-3.5 9-3.5 13 0M9 15.5c2-1.5 4-1.5 6 0" strokeLinecap="round" />
      </svg>
      <svg viewBox="0 0 24 24" width="10" height="10" fill="none" stroke="#fff" strokeWidth="2">
        <rect x="2" y="8" width="18" height="8" rx="2" />
        <rect x="22" y="10.5" width="1.5" height="3" fill="#fff" stroke="none" />
        <rect x="4" y="10" width="14" height="4" fill="#fff" stroke="none" />
      </svg>
    </div>
  );
}

function BackArrow() {
  return <span className="wa-back-arrow">←</span>;
}

function HeaderIcon({ path }: { path: string }) {
  return (
    <svg viewBox="0 0 24 24" width="10" height="10" fill="none" stroke="#fff" strokeWidth="2">
      <path d={path} strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  );
}

export function WhatsAppAnimation() {
  const t = useTranslations("home.whyChooseUs.whatsappDemo");
  return (
    <ScaleToFit width={840} height={400} focus={{ x: 318, y: 9, width: 204, height: 383 }}>
      <div className="wa-visual">
      <div className="wa-phone-shell">
        <div className="wa-phone-screen">
          <div className="wa-status-bar">
            <span>09:41</span>
            <StatusIcons />
          </div>

          <div className="wa-header">
            <div className="wa-header-left">
              <BackArrow />
              <div className="wa-avatar">
                <img src="/images/whatsapp/avatar-bird.png" alt="" />
              </div>
            </div>
            <div className="wa-header-center">
              <span className="wa-header-name">Tickett.com</span>
              <span className="wa-header-status">online</span>
            </div>
            <div className="wa-header-right">
              <HeaderIcon path="M15 10.5l5-3v9l-5-3M4 7h9a2 2 0 0 1 2 2v6a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V9a2 2 0 0 1 2-2Z" />
              <HeaderIcon path="M4 4h4l2 5-2.5 1.5a11 11 0 0 0 5 5L14 13l5 2v4a2 2 0 0 1-2 2C8.5 21 3 15.5 3 8a2 2 0 0 1 2-2Z" />
              <HeaderIcon path="M5 12h.01M12 12h.01M19 12h.01" />
            </div>
          </div>

          <div className="wa-chat-bg">
            <div className="wa-bubble wa-bubble-received wa-fade-bubble-1">
              <span>{t("confirmed")}</span>
              <span className="wa-time">09:41</span>
            </div>

            <div className="wa-bubble wa-bubble-ticket wa-fade-bubble-ticket">
              <div className="wa-ticket-clip">
                <img src={`${ASSET}/photo.png`} alt="Bilhete" />
              </div>
              <span className="wa-time wa-ticket-time">09:41</span>
            </div>

            <div className="wa-bubble wa-bubble-received wa-fade-bubble-3">
              <span>{t("instructions")}</span>
              <span className="wa-time">09:42</span>
            </div>

            <div className="wa-bubble wa-bubble-sent wa-fade-bubble-4">
              <span>{t("thanks")}</span>
              <span className="wa-sent-meta">
                <span>09:42</span>
                <span>✓✓</span>
              </span>
            </div>
          </div>
        </div>
      </div>

      <div className="wa-blur-overlay" />

      <div className="wa-stamp-badge">✓</div>
      </div>
    </ScaleToFit>
  );
}
