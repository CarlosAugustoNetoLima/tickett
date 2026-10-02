import "./BilheteAnimation.css";
import { ScaleToFit } from "./ScaleToFit";

const ASSET = "/images/bilhete";

export function BilheteAnimation() {
  return (
    <ScaleToFit width={336} height={754.08} focus={{ x: 0, y: 207, width: 336, height: 754.08 }}>
      <div className="bilhete">
        <div className="bilhete-photo">
          <img className="bilhete-photo-img" src={`${ASSET}/photo.png`} alt="" />
          <img className="bilhete-brilho" src={`${ASSET}/brilho-aux.svg`} alt="" />
        </div>

        <img className="bilhete-stub-outline" src={`${ASSET}/subtract-stroke.svg`} alt="" />

        <div className="bilhete-content bilhete-fade-content">
          <div className="bilhete-wordmark-row">
            <img className="bilhete-wordmark" src={`${ASSET}/wordmark.svg`} alt="TICKETT.COM" />
          </div>
          <div className="bilhete-copy">
            <img src={`${ASSET}/headline.svg`} alt="A Tua Experiência Inesquecível" />
            <img
              src={`${ASSET}/desc.svg`}
              alt="Conectamos os fãs aos melhores espetáculos de forma simples e segura, garantindo sempre bilhetes 100% oficiais."
            />
          </div>
          <div className="bilhete-features">
            <div className="bilhete-feature-row">
              <img src={`${ASSET}/entrada-rapida.svg`} alt="Entrada rápida e garantida" />
            </div>
            <div className="bilhete-feature-row">
              <img src={`${ASSET}/ilustrativo.svg`} alt="Bilhete Ilustrativo" />
            </div>
          </div>
        </div>

        <div className="bilhete-divider bilhete-fade-divider" />

        <div className="bilhete-vip-block bilhete-fade-vip">
          <img src={`${ASSET}/setor-vip.svg`} alt="Setor VIP" />

          <div className="bilhete-qrcode bilhete-fade-qrcode">
            <img src={`${ASSET}/qr.png`} alt="QR Code" />
            <div className="bilhete-scan-bar" />
          </div>

          <img src={`${ASSET}/order-number.svg`} alt="8387493" />
        </div>

        <div className="bilhete-footer">
          <div className="bilhete-footer-badge">
            <img src={`${ASSET}/logo.png`} alt="Tickett.com" />
          </div>
        </div>
      </div>
    </ScaleToFit>
  );
}
