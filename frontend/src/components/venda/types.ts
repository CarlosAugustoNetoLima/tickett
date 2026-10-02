export const STEPS = ["promotor", "evento", "bilhetes", "revisao"] as const;

export interface PromotorData {
  nomeResponsavel: string;
  entidade: string;
  nif: string;
  email: string;
  telefoneDial: string;
  telefoneNumero: string;
  website: string;
}

export interface EventoData {
  nome: string;
  categoria: string;
  descricao: string;
  dataEvento: string;
  aberturaPortas: string;
  horaInicio: string;
  fimVendasData: string;
  fimVendasHora: string;
  recinto: string;
  morada: string;
  cidade: string;
  pais: string;
  imagemPrincipal: File[];
  banner: File[];
  redesSociais: File[];
}

export interface TicketLote {
  id: string;
  lote: string;
  preco: string;
  quantidade: string;
}

export interface TicketType {
  id: string;
  nome: string;
  lotes: TicketLote[];
}

export type Caracteristica = "lugares-marcados" | "acessos-especiais" | "descontos";

export interface BilhetesData {
  tickets: TicketType[];
  restricaoIdade: string;
  caracteristicas: Caracteristica[];
  lotacaoMobReduzida: string;
  observacoes: string;
}

interface RevisaoData {
  aceitaTermos: boolean;
}

export interface VendaFormData {
  promotor: PromotorData;
  evento: EventoData;
  bilhetes: BilhetesData;
  revisao: RevisaoData;
}

export type VendaPayload = Omit<VendaFormData, "evento"> & {
  evento: Omit<EventoData, "imagemPrincipal" | "banner" | "redesSociais"> & {
    imagemPrincipal: string[];
    banner: string[];
    redesSociais: string[];
  };
};

export function createTicketLote(): TicketLote {
  return { id: crypto.randomUUID(), lote: "", preco: "", quantidade: "" };
}

export function createTicketType(): TicketType {
  return { id: crypto.randomUUID(), nome: "", lotes: [createTicketLote()] };
}

export function createInitialFormData(): VendaFormData {
  return {
    promotor: {
      nomeResponsavel: "",
      entidade: "",
      nif: "",
      email: "",
      telefoneDial: "+351",
      telefoneNumero: "",
      website: "",
    },
    evento: {
      nome: "",
      categoria: "",
      descricao: "",
      dataEvento: "",
      aberturaPortas: "",
      horaInicio: "",
      fimVendasData: "",
      fimVendasHora: "",
      recinto: "",
      morada: "",
      cidade: "",
      pais: "Portugal",
      imagemPrincipal: [],
      banner: [],
      redesSociais: [],
    },
    bilhetes: {
      tickets: [createTicketType()],
      restricaoIdade: "",
      caracteristicas: [],
      lotacaoMobReduzida: "",
      observacoes: "",
    },
    revisao: {
      aceitaTermos: false,
    },
  };
}

export type FieldErrors = Record<string, string>;
