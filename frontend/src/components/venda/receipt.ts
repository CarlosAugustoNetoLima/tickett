import type { useTranslations } from "next-intl";
import { totalLotacao } from "./validation";
import type { VendaFormData } from "./types";

type VendaT = ReturnType<typeof useTranslations<"venda">>;

export function buildReceiptText(data: VendaFormData, t: VendaT): string {
  const { promotor, evento, bilhetes } = data;
  const categoriaLabel = evento.categoria ? t(`options.categoria.${evento.categoria}` as never) : evento.categoria;
  const restricaoLabel = bilhetes.restricaoIdade
    ? t(`options.restricaoIdade.${bilhetes.restricaoIdade}` as never)
    : bilhetes.restricaoIdade;
  const caracteristicas = bilhetes.caracteristicas
    .map((c) => t(`options.caracteristicas.${c}` as never))
    .filter(Boolean)
    .join(", ");
  const ticketsLines = bilhetes.tickets
    .map((ticket) => {
      const lotes = ticket.lotes
        .map((l) => `    - ${l.lote || t("receipt.loteUnico")}: ${l.preco || "0"} € × ${l.quantidade || "0"}`)
        .join("\n");
      return `  ${ticket.nome || "—"}\n${lotes}`;
    })
    .join("\n");

  return `${t("receipt.header")}
${t("receipt.generatedAt", { date: new Date().toLocaleString() })}

${t("receipt.promotor")}
  ${t("receipt.responsavel")}: ${promotor.nomeResponsavel}
  ${t("receipt.entidade")}: ${promotor.entidade || "—"}
  ${t("receipt.nif")}: ${promotor.nif}
  ${t("receipt.email")}: ${promotor.email}
  ${t("receipt.telefone")}: ${promotor.telefoneDial} ${promotor.telefoneNumero}
  ${t("receipt.website")}: ${promotor.website || "—"}

${t("receipt.evento")}
  ${t("receipt.nome")}: ${evento.nome}
  ${t("receipt.categoria")}: ${categoriaLabel}
  ${t("receipt.descricao")}: ${evento.descricao}
  ${t("receipt.data")}: ${evento.dataEvento}
  ${t("receipt.aberturaPortas")}: ${evento.aberturaPortas || "—"}
  ${t("receipt.horaInicio")}: ${evento.horaInicio}
  ${t("receipt.fimVendas")}: ${evento.fimVendasData || "—"} ${evento.fimVendasHora || ""}
  ${t("receipt.local")}: ${evento.recinto}
  ${t("receipt.morada")}: ${evento.morada || "—"}
  ${t("receipt.cidadePais")}: ${evento.cidade}, ${evento.pais}

${t("receipt.bilhetica")}
${ticketsLines}
  ${t("receipt.lotacaoTotal")}: ${totalLotacao(bilhetes)} ${t("receipt.bilhetesSuffix")}
  ${t("receipt.restricaoIdade")}: ${restricaoLabel}
  ${t("receipt.caracteristicas")}: ${caracteristicas || "—"}
  ${t("receipt.observacoes")}: ${bilhetes.observacoes || "—"}

${t("receipt.footer")}
`;
}
