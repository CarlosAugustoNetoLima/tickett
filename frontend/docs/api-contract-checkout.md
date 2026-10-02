# Escopo de dados — API de Compra / Checkout (Next.js)

> Companion de [`api-contract-home-eventos-evento.md`](./api-contract-home-eventos-evento.md). Aquele documento cobre **descoberta** (home, listagem, detalhe do evento); este cobre o **funil de compra** — do momento em que o utilizador clica "Comprar" até ao pagamento.
>
> Baseado no protótipo Figma "Website-Lebillet" (file `22oZ3zoX3B2cKxymtDs5Ol`), nos 17 frames da secção **Compra** (mapeados na §1), cruzado com:
> - o **checkout atual** — `checkout.lebillet.eu`, hoje consumido por *reverse proxy* em `src/app/[locale]/checkout/[...path]/route.ts`;
> - o **código Phalcon deste repo** (`app/controllers/CheckoutController.php`, `app/library/CartLib.php`, `app/library/GetProducts.php`, `app/library/CustomerLib.php`, `app/controllers/ApiCartController.php`);
> - o **schema** (`base.sql`).
>
> **Situação de partida:** o frontend Next.js **não tem checkout próprio**. O que existe hoje é um proxy que serve o checkout legado por baixo do nosso domínio e o repinta com `public/checkout-theme.css` + ~250 linhas de JS injectado (reordenar linhas da tabela de bilhetes, corrigir `<label for>` partidos, inferir o passo actual espiando `XMLHttpRequest.prototype.open`). Substituir isto por um checkout nativo é exactamente o que os frames abaixo descrevem — e é por isso que a API nova tem de cobrir **todo** o funil, não só o carrinho.

---

## 0. Observações importantes para quem vai construir a API

1. **O design assume checkout sem conta ("Não precisa de criar conta"), o checkout actual exige login ou registo com password.** `CheckoutController::loginAction()` (`app/controllers/CheckoutController.php:435`) só avança se receber `login[email]+login[password]` **ou** `register[name]+register[email]+register[password]`. O ecrã S2 do Figma não tem password nem "já tenho conta". Isto é a maior mudança funcional do lote inteiro — ver §4.1.
2. **O carrinho é `evento → produto → tipo/lote`, não uma lista plana.** `CartLib::persistCart()` (`app/library/CartLib.php:520`) acumula por evento e devolve 11 valores distintos (`value_product`, `value_product_tax`, `value_fee`, `value_fee_tax`, `value_fee_org`, `value_fee_org_tax`, `value_interest`, `value_interest_tax`, `value_delivery`, `value_tax`, `value_total`). O design mostra **uma** linha "Custos de operação" e um "Total" — a API tem de devolver o detalhe *e* o agregado, senão perdemos IVA, taxa de organizador e custo de entrega (§4.4).
3. **O ✕ de cada linha do Resumo não tem equivalente no backend.** `CartLib::removeProductFromCart()` (`app/library/CartLib.php:477`) faz `unset($cart['event'][$id_event])` — remove **o evento inteiro**, não um lote. Remover "Plateia VIP × 1" e manter "Bilhete Dia 27" é funcionalidade nova.
4. **Cupões existem no modelo de dados mas não no fluxo de compra.** Tabelas `coupons` (`discount_fixed`, `discount_percentage`, `free_tax`, `limit_general`, `limit_personal`, `start_at`, `end_at`, `active`), `coupons_codes`, `coupons_products`; colunas `sales.value_discount`, `sales_items.value_discount/value_discount_tax`. Mas `persistCart()` **nunca** calcula desconto. O campo "Código promocional / Aplicar" aparece nos 17 frames — logo, aplicar cupão é trabalho novo de backend, não só de UI (§4.2).
5. **Valores formatados**: mesma regra do contrato anterior — devolver sempre o valor cru (`number`, cêntimos ou decimal) **e** o label PT já formatado (`"€ 82,95"`), para o frontend não reimplementar `formatMoney()`.
6. **Idempotência e concorrência não são opcionais aqui.** Bilhete é stock com contenção real: `GetProducts::getAvailable()` calcula `sales_limit − vendidos` **no momento da leitura**. Entre pintar o ecrã S1 e carregar em "Continuar" no S3 o lote pode esgotar. A API precisa de reservar e de uma chave de idempotência na criação da encomenda (§5.9).

---

## 1. Mapa dos 17 frames

Todos em `22oZ3zoX3B2cKxymtDs5Ol`. "Passo" = passo real do funil pelo conteúdo do frame (nem sempre bate com o nome, ver §2).

### Desktop (1440×789)

| node-id | Nome no Figma | Passo | O que mostra |
|---|---|---|---|
| `5471:9605` | `Desktop/Compra-S1-MapaDefault` | 1 | Mapa de **setores** do recinto (BALCÃO 0/1/2 × SECTOR A–G, Plateia, Plateia VIP), popover de hover com nome do setor + lote + preço, controlos de zoom (+ / home / −). Resumo vazio: *"Não adicionou item ao carrinho"*, sem linha de Total. |
| `5471:9702` | `Desktop/Compra-S1-MapaSelecionado` | 1 | Lista de **lotes/tipos de bilhete** (general admission — exemplo Festival do Crato: 5 cards com nome, descrição, badge de estado, preço e stepper −/qty/+). Resumo com 1 item + custos + Total. |
| `5471:9801` | `Desktop/Compra-S1b-LugaresDefault` | 1b | Grelha de **lugares** com legenda (Disponível / Indisponível / Selecionado), "PALCO", toast *"Lugar adicionado ao carrinho"*, `Lugares selecionados:` com chips `Fila F – 9`, `Fila F – 10`. Resumo ainda vazio. |
| `5471:10450` | `Desktop/Compra-S1b-LugaresSelecionados` | 1b | Igual, com lugar já seleccionado e Resumo preenchido (`1x Plateia VIP · € 80,00`). |
| `5471:11099` | `Desktop/Compra-S2-DadosDefault` | 2 | Formulário do comprador vazio: Nome*, Apelido*, E-mail*, Confirmar e-mail*, Telemóvel* (prefixo 🇵🇹 +351), Confirmar telemóvel*, País* (select), Concelho* (select). Banner: *"Não precisa de criar conta. Os bilhetes serão enviados para o seu e-mail e WhatsApp."* |
| `5471:11228` | `Desktop/Compra-S2-DadosPreenchidos` | 2 | Mesma estrutura, Resumo do Festival do Crato. **Os campos continuam com placeholder** — não há variante realmente "preenchida" nem estado de erro. |
| `5471:11457` | `Desktop/Compra-S3-PagamentoDefault` | 3 | MODO DE PAGAMENTO (MB WAY / Multibanco / Visa+Mastercard+Apple Pay+G Pay), EMITIR FATURA = **Não**, 2 checkboxes (termos ✓ / uso promocional dos dados), faixa "Ao prosseguir confirma que leu e aceita os Termos e Condições". |
| `5471:11357` | `Desktop/Compra-S3-PagamentoCartao` | 3 | Idêntico ao anterior com o carrinho do outro evento. **Não mostra formulário de cartão** apesar do nome. |
| `5471:11557` | `Desktop/Compra-S3-PagamentoPix` | 3 | EMITIR FATURA = **Sim** → revela Nome/Empresa*, NIF*, Morada*, E-mail*. |
| `5471:11657` | `Desktop/Compra-S3-PagamentoPreenchido` | 3 | Igual ao `11557`. |

### Mobile (360×W)

| node-id | Nome no Figma | Passo | O que mostra |
|---|---|---|---|
| `5471:14283` | `Mobile/Compra-S1-MapaDefault` | 1 | *"Selecione uma área"* + mapa de setores circular, zoom, bottom sheet com handle + botão Continuar. |
| `5471:14411` | `Mobile/Compra-S1-MapaZoom` | 1b | Grelha de lugares com legenda, `Lugares selecionados:` vazio. |
| `5471:15086` | `Mobile/Compra-S1-MapaSetor` | 1b | Grelha + toast + chip `Fila F – 9` + sheet colapsado com **Total** e Continuar. |
| `5471:15734` | `Mobile/Compra-S1-MapaLugares` | 1b | Igual com o **sheet expandido**: Resumo completo (capa, evento, cupão, linhas, custos, Total). |
| `5471:16382` | `Mobile/Compra-S2-DadosForm` | 2 | Formulário do comprador em coluna única + sheet colapsado com Total. |
| `5471:16509` | `Mobile/Compra-S2-DadosMinimo` | **3** | É o ecrã de **pagamento** (fatura = Não). Nome errado. |
| `5471:16610` | `Mobile/Compra-S2-DadosCompleto` | **3** | É o ecrã de **pagamento** com fatura = Sim. Nome errado. |

**Resumo da cobertura:** 3 passos (S1 selecção · S2 dados · S3 pagamento) + sub-passo S1b (lugares), desktop e mobile. **Zero frames depois do botão "Continuar" do S3** — ver §3.1.

---

## 2. Inconsistências dentro do próprio Figma (corrigir antes do handoff)

| # | Onde | Problema |
|---|---|---|
| 2.1 | `5471:16509`, `5471:16610` | Nomeados `Compra-S2-Dados*` mas o conteúdo é o passo 3 (MODO DE PAGAMENTO / EMITIR FATURA / termos). Quem implementar pelo nome do frame constrói o ecrã errado. |
| 2.2 | `5471:11557` | Chamado `PagamentoPix`. **Pix é meio de pagamento brasileiro** e não aparece no ecrã (que mostra MB WAY / Multibanco / Visa). Nome herdado de outro projecto. |
| 2.3 | `5471:11657` | O Resumo lista `Plateia VIP × 1 = € 80,00` + `Custos de operação € 2,95`, mas o **Total diz € 17,95** (valor copiado do frame do Festival do Crato). |
| 2.4 | `5471:16509:16513`, `5471:16610:16614` | A instância `Pagamentos` está com **width = 984 px dentro de um frame de 328 px**. É por isso que no mobile o cartão VISA aparece cortado à direita. O componente de meios de pagamento **não foi adaptado a mobile**. |
| 2.5 | `5471:11357` (`PagamentoCartao`) | Não tem formulário de cartão. Se o cartão é *hosted* (redirect/iframe do PSP), o nome induz em erro; se é inline, falta o ecrã inteiro (§3.4). |
| 2.6 | `5471:9702` (`S1-MapaSelecionado`) | Não mostra mapa nenhum — é a lista de lotes GA. Falta clarificar se "escolher um setor no mapa" leva a esta lista de lotes, ou se é o fluxo alternativo de eventos sem mapa (o `ticketing.mode` do contrato anterior). |
| 2.7 | Desktop vs Mobile | Desktop usa a instância `TopBarCheckout`, mobile usa `Header checkout` — **dois componentes diferentes**. Confirmar se é intencional (o mobile tem seta de voltar e os passos numa linha própria com scroll horizontal). |
| 2.8 | Todos os frames S2 | Não existe variante com campos preenchidos, focados, em erro ou desactivados. O `DadosPreenchidos` (`5471:11228`) tem exactamente os mesmos placeholders do `DadosDefault`. |

---

## 3. O que faltava no design — e o que já foi desenhado

> **Estado:** os ecrãs marcados ✅ abaixo já foram construídos no mesmo ficheiro Figma, na página **`↳ Redesign v3`**, à direita/abaixo dos frames originais. Foram montados **só com o sistema existente** — os 32 tokens de `LeBillet / Tokens`, os 24 text styles (`Body/*`, `Label/*`, `Display/*`), os componentes `TopBarCheckout`, `Header checkout`, `Button`, `Pagamentos`, `InputGroup`, `field` e ícones vuesax. **Nenhuma cor, fonte, raio, espaçamento ou token novo foi criado.**

| ✅ | Frame | node-id |
|---|---|---|
| ✅ | `Desktop/Compra-S4-Multibanco` | `5725:6959` |
| ✅ | `Desktop/Compra-S4-MBWayAguardar` | `5726:7016` |
| ✅ | `Desktop/Compra-S4-Sucesso` | `5726:7201` |
| ✅ | `Desktop/Compra-S4-Erro` | `5727:7132` |
| ✅ | `Desktop/Compra-S3-PagamentoCartaoForm` | `5727:7304` |
| ✅ | `Desktop/Compra-S2-DadosErro` | `5728:7251` |
| ✅ | `Desktop/Compra-S3-CupaoAplicado` | `5728:7485` |
| ✅ | `Desktop/Compra-S3-CupaoInvalido` | `5732:7841` |
| ✅ | `Desktop/Compra-S1b-ReservaTimer` | `5729:7404` |
| ✅ | `Desktop/Compra-S1b-ReservaExpirada` | `5729:8125` |
| ✅ | `Mobile/Compra-S4-Multibanco` | `5730:7523` |
| ✅ | `Mobile/Compra-S4-MBWayAguardar` | `5730:7721` |
| ✅ | `Mobile/Compra-S4-Sucesso` | `5731:7641` |
| ✅ | `Mobile/Compra-S4-Erro` | `5731:7831` |
| ✅ | `Mobile/Compra-S2-DadosErro` | `5731:8007` |

Continua por desenhar: 3DS/redirect do cartão, esgotou-durante-o-checkout, passo de entrega (se for mantido), carrinho multi-evento e o ecrã de cortesia (total = 0).

### 3.1 — Não existia nada depois do "Continuar" do passo 3 🔴 (✅ resolvido)

É a lacuna mais crítica. Faltam, no mínimo:

- **Sucesso / confirmação** — com os bilhetes, QR, e o `events.instructions` (a coluna existe e está comentada no schema como *"Vai na tela de confirmação do evento"*, `base.sql:329`).
- **Multibanco: entidade + referência + valor + validade.** O backend já emite isto: `CartLib::sendEmailMultiBanco($id_order, $entity, $expireDate, $reference, $value)` (`app/library/CartLib.php:1542`), template `multibanco-sibs`, via SIBS. E os T&C (`app/config/config_company/lebillet_pt.php:332`) dizem: *"Caso o meio de pagamento não seja aceite no prazo de 48h ou as referências MULTIBANCO não sejam pagas atempadamente, a venda não é finalizada"*. Ou seja: existe um estado **"encomenda pendente de pagamento" que dura 48 h** e não tem ecrã.
- **MB WAY: ecrã de espera** ("confirme no telemóvel"), com polling, timeout e opção de reenviar/trocar de método.
- **Cartão: redirect 3-D Secure e retorno.** `VivawalletController` só tem `successAction()` e `errorAction()` — ou seja, já há retorno de PSP por redirect e nenhum dos dois estados está desenhado.
- **Pagamento recusado / falhado**, com caminho de retry.
- **Cortesia** (`value_total == 0`): `CheckoutController::checkoutAction()` trata `payment == 7` quando o total é zero (`app/controllers/CheckoutController.php:668`) e `payment.volt:13` tem esse formulário. Com 100 % de desconto por cupão isto passa a ser alcançável pelo site público.

### 3.2 — Estados do cupão (✅ resolvido)

Existia o input e o botão "Aplicar"; faltava: aplicado com sucesso (e como é que o desconto aparece no Resumo — linha própria? risca o preço?), código inválido, expirado, limite atingido, não aplicável àqueles produtos (`coupons_products` é por `id_products_types`), e **como remover** um cupão já aplicado.

### 3.3 — Reserva / expiração (✅ resolvido)

`products_seats` tem `reserved_by` e `reserved_at`, e o checkout actual chama `/{eventId}/seats/add?reservation=` — há TTL de reserva de lugar. Não há cronómetro, aviso de "a sua reserva expira em…", nem ecrã de "carrinho expirado". Sem isto o utilizador perde lugares sem perceber porquê.

### 3.4 — Formulário de cartão (✅ parcial)

Se o cartão for inline, falta tudo (titular, número, validade, CVV, e o **código postal** que o backend actual exige — `CheckoutController.php:730` só processa se `$billing_address['zip']` estiver preenchido). Se for *hosted*, falta o ecrã de transição e o tratamento do retorno.

### 3.5 — Erros, validação e loading (✅ parcial)

Nenhum campo tem estado de erro desenhado, apesar de metade ser obrigatória (`*`) e de haver duas confirmações (e-mail e telemóvel) cujo único propósito é falhar quando não coincidem. Também faltam: botão em loading/disabled, skeleton do Resumo, e o erro de **"esgotou enquanto estava no checkout"** (concorrência real — §0.6).

### 3.6 — Entrega (delivery)

O checkout actual tem passo de entrega obrigatório: `CheckoutController::deliveryAction()` (`:577`), `CartLib::setDelivery()` (`:487`), endpoints `/cart/set-delivery` e `/cart/delivery-payment`, e a tabela `events_deliveries` com **`value` e `value_tax` por tipo de entrega**. O design elimina o passo e assume e-mail + WhatsApp sempre. Duas consequências: (a) eventos configurados com entrega paga ou levantamento em bilheteira deixam de funcionar; (b) `cart.value_delivery` deixa de ter origem. Decisão de negócio, não de UI.

### 3.7 — Restantes buracos

- **Multi-evento**: o carrinho suporta N eventos (`cart['event']` é um array); o Resumo desenhado tem um `EventCard` único.
- **Limite por encomenda**: o stepper não tem máximo visível; `products_sales_limit` existe por evento/produto/tipo/lote/ponto-de-venda.
- **Vários lotes por tipo de bilhete**: o proxy actual tem código dedicado a desenhar *n* lotes por bilhete, incluindo lotes "Esgotado" repetidos (`route.ts`, `restyleTicketRows`). O card do Figma tem **um** badge de estado e **um** preço.
- **Badge "Limitado"**: `GetProducts` só sabe `available = sales_limit − vendidos`. Não existe regra para "Limitado" — é preciso definir o limiar (ex.: `available <= 10` ou `<= 10 %`).
- **Comissário / ponto de venda**: `CheckoutController` carrega `seller`, `id_sale_point`, `id_sale_terminal`, `embedded` e `ref` (link de divulgação). Nada disto aparece no design; se o link com `?ref=` deixar de atribuir a venda, quebra a comissão.
- **Acessibilidade do mapa**: a grelha de lugares não tem alternativa não-visual nem estado de "sem lugares disponíveis"/"mapa indisponível".
- **i18n**: o site é `[locale]`; os frames são todos PT.

---

## 4. O que o design pede e não existe hoje no nosso lado

| # | Pedido pelo design | Situação actual | Trabalho |
|---|---|---|---|
| 4.1 | **Checkout sem conta** | `loginAction()` exige password. | `CustomerLib::register()` (`app/library/CustomerLib.php:65`) **já gera password automaticamente quando recebe `null`**, e `customers.password` é `NOT NULL` — dá para criar o convidado sem mudar schema. Falta: decidir de-duplicação por e-mail (hoje `register()` devolve *"Email already in use"* e aborta — com guest checkout isso passaria a bloquear compras repetidas do mesmo e-mail) e o que fazer com `email_confirmed`/`cell_number_confirmed`. |
| 4.2 | **Código promocional** | Modelo existe, cálculo não. | Implementar validação (`coupons_codes.code` → `coupons`), aplicabilidade (`coupons_products`), limites (`limit_general`/`limit_personal`), janela (`start_at`/`end_at`/`active`), e somar `value_discount` em `persistCart()`. Decidir se desconta antes ou depois das taxas (`coupons.free_tax` sugere que há caso de isentar taxa). |
| 4.3 | **Nome + Apelido separados** | `customers.name` é **um** varchar(100). | Ou concatenar (perde-se a separação) ou acrescentar `surname`. Recomendo acrescentar coluna — o bilhete e a fatura beneficiam. |
| 4.4 | **"Custos de operação" numa linha** | 6 componentes distintos (`value_fee`, `value_fee_tax`, `value_fee_org`, `value_fee_org_tax`, + `value_delivery`, + `value_product_tax`). | Definir exactamente o que entra na linha. Nota: os T&C dizem *"Sobre o valor total da transacção acresce 6 % mais IVA"* (`lebillet_pt.php:660`), enquanto o código calcula fee **por unidade de produto**. Os `€ 2,95` do protótipo não correspondem a 6 % de `€ 80,00`. **O IVA tem de aparecer em algum lado** — é obrigação legal em PT e neste momento não está em nenhum frame. |
| 4.5 | **País / Concelho (selects)** | `customers.city/region/country` são varchars livres. A tabela `cities` tem ~22 linhas (`AUTO_INCREMENT=23`), não os 308 concelhos. | Precisa de fonte de dados: ou popular `cities`/`regions` com os concelhos e distritos, ou uma tabela nova. Sem isto o select fica vazio. |
| 4.6 | **Remover 1 linha do carrinho (✕)** | `removeProductFromCart()` remove o evento inteiro. | Endpoint novo por `lineId`. |
| 4.7 | **Apple Pay / Google Pay** | Os T&C listam *Cartões (VISA, MASTERCARD), MBWay, MBnet, PayPal, Paysafe Cash, Multibanco* (`lebillet_pt.php:310`) — **sem** Apple/Google Pay. | Confirmar suporte no PSP (Viva Wallet suporta), acrescentar aos T&C e aos `payment_types`. |
| 4.8 | **Confirmar e-mail / telemóvel** | Não existe. | Validação só de frontend, mas a API deve rejeitar na mesma (defesa em profundidade). |

E ao contrário — **o que o design deixou cair**: PayPal, MBnet e Paysafe Cash estão nos T&C e não estão nos três cards do S3. Ou saem dos T&C, ou entram no design.

---

## 5. Contrato proposto

Prefixo `/api/checkout`. Autenticação: sessão anónima por cookie `HttpOnly` (`cartId` opaco) — o carrinho actual já é *session-scoped* (`cart['customer_session']`, `customer_ip`, `customer_agent`).

### 5.0 Tipos comuns

```ts
type Money = { amount: number; label: string };      // { amount: 8295, label: "€ 82,95" } — cêntimos
type TicketStatus = "available" | "limited" | "soldout";
type PaymentMethod = "mbway" | "multibanco" | "card" | "applepay" | "googlepay";
type OrderStatus  = "pending" | "awaiting_payment" | "paid" | "failed" | "expired" | "cancelled";

interface CartLine {
  id: string;              // id da linha (necessário para o ✕) — §4.6
  productId: number;       // products.id
  typeId: number;          // products_types.id
  lot: number;             // products_lots.lot_number
  name: string;            // "Plateia VIP" / "Bilhete único - Dia 26 de Agosto"
  qty: number;
  unitPrice: Money;
  total: Money;
  seat?: { id: number; row: string; seat: string; label: string };  // "Fila F – 9"
}

interface CartTotals {
  products: Money;
  fees: Money;             // agregado que alimenta "Custos de operação" — §4.4
  tax: Money;              // IVA — falta no design, devolver na mesma
  delivery: Money;
  discount: Money;         // negativo; 0 se não houver cupão
  total: Money;
  breakdown: {             // detalhe 1:1 com persistCart(), para conferência/debug
    valueProduct: number; valueProductTax: number;
    valueFee: number; valueFeeTax: number;
    valueFeeOrg: number; valueFeeOrgTax: number;
    valueInterest: number; valueInterestTax: number;
    valueDelivery: number;
  };
}

interface Cart {
  id: string;
  expiresAt: string | null;   // ISO — TTL da reserva, §3.3
  event: { id: number; title: string; image: string; dateLabel: string; venueLabel: string };
  lines: CartLine[];
  coupon: { code: string; label: string; discount: Money } | null;
  totals: CartTotals;
}
```

### 5.1 `GET /api/checkout/:eventId` — arranque (S1)

Devolve o cabeçalho do evento (para o `EventCard` do Resumo), o modo de ticketing e o carrinho actual.

```jsonc
{
  "event": { "id": 1855, "title": "Marisa Monte & Orquestra",
             "image": "…", "dateLabel": "Dom, 20 Set 2026", "timeLabel": "21:30h",
             "venueLabel": "Porto", "instructions": "…" },
  "ticketing": { "mode": "seatmap" },        // "seatmap" | "tiers"  (mesmo campo do contrato anterior)
  "maxPerOrder": 6,                           // §3.7
  "cart": { /* Cart */ }
}
```

### 5.2 `GET /api/checkout/:eventId/tiers` — lista GA (`5471:9702`)

```jsonc
{ "tiers": [{
    "productId": 412, "typeId": 1, "lot": 1,
    "name": "BILHETE ÚNICO - DIA 26 DE AGOSTO",
    "description": "Acesso ao Festival do Crato — 1.º dia…",
    "price": { "amount": 1500, "label": "€ 15,00" },
    "status": "available", "available": 340, "maxPerOrder": 6
}]}
```

⚠️ Um `product` pode ter **vários lotes** simultâneos, incluindo esgotados. Definir se a API achata para o lote activo (e o design só mostra esse) ou devolve todos — hoje o checkout mostra todos, ver §3.7.

### 5.3 `GET /api/checkout/:eventId/sectors` + `/sectors/:sectorId/seats` — mapa (S1 / S1b)

`sectors` → geometria/SVG dos setores (`maps_sector`, hoje servidos de `/img/mapas/`) + preço mínimo para o popover de hover (`5471:9650`).
`seats` → `maps_seats` ⋈ `products_seats`: `{ id, row, seat, label, left, top, status: "available"|"unavailable"|"selected", price }`.
Equivalente actual: `/Seats/getAllSeats` e `/Seats/checkSeats`.

### 5.4 Carrinho

| Método | Rota | Nota |
|---|---|---|
| `POST` | `/api/checkout/cart/lines` | `{ productId, typeId, lot, qty }` → devolve `Cart` |
| `PATCH` | `/api/checkout/cart/lines/:lineId` | `{ qty }` (stepper −/+) |
| `DELETE` | `/api/checkout/cart/lines/:lineId` | **novo** (§4.6) |
| `POST` | `/api/checkout/cart/seats` | `{ seatIds: number[] }` → reserva com TTL, devolve `expiresAt` |
| `DELETE` | `/api/checkout/cart/seats/:seatId` | o ✕ do chip `Fila F – 9` |
| `POST` | `/api/checkout/cart/coupon` | `{ code }` → 200 `Cart` · 422 `{ error: { code: "coupon_invalid"\|"coupon_expired"\|"coupon_limit_reached"\|"coupon_not_applicable" } }` |
| `DELETE` | `/api/checkout/cart/coupon` | falta no design (§3.2) |

Todos devolvem o `Cart` completo — o Resumo é a mesma componente nos 17 frames, recalcular tudo evita divergência entre cliente e servidor.

### 5.5 `PUT /api/checkout/buyer` — S2

```jsonc
{ "firstName": "Tiago", "lastName": "Santos",
  "email": "tiago@exemplo.com", "emailConfirm": "tiago@exemplo.com",
  "phoneCountry": "PT", "phone": "912345678", "phoneConfirm": "912345678",
  "country": "PT", "municipality": 1106 }
```

Erros por campo, para o estado que falta desenhar (§3.5):
`422 { "errors": { "emailConfirm": "Os e-mails não coincidem", "phone": "Número inválido" } }`

### 5.6 `GET /api/checkout/geo/countries` · `/geo/municipalities?country=PT`

Alimenta os dois selects do S2. **Precisa de fonte de dados nova** (§4.5).

### 5.7 `GET /api/checkout/payment-methods`

Por evento/ponto-de-venda — hoje `SalesPointsPaymentType` filtrado por `id_sale_point` (`CheckoutController.php:512`). Nem todos os eventos aceitam tudo; o design mostra sempre os mesmos três cards.

```jsonc
{ "methods": [
  { "id": "mbway",       "label": "MB WAY",     "enabled": true },
  { "id": "multibanco",  "label": "Multibanco", "enabled": true, "note": "Referência válida 48h" },
  { "id": "card",        "label": "Cartão",     "enabled": true, "wallets": ["applepay","googlepay"], "flow": "redirect" }
]}
```

### 5.8 `POST /api/checkout/invoice` — EMITIR FATURA

```jsonc
{ "enabled": true, "name": "…", "nif": "…", "address": "…", "email": "…" }
```

⚠️ Hoje o equivalente é `ApiCartController::savefaturaAction()` (`app/controllers/ApiCartController.php:934`), que exige **`idOrder`** — ou seja, só funciona *depois* da encomenda existir, e grava em `customers_saft` + dispara `cron_saft/processNew/`. No design a fatura é preenchida **antes** do "Continuar". Escolher: (a) guardar no carrinho e enviar junto com a encomenda (preferível), ou (b) manter `savefatura` como chamada pós-encomenda. Validar o NIF no servidor (check digit), não só no cliente.

### 5.9 `POST /api/checkout/order` — o "Continuar" do S3

```jsonc
{ "paymentMethod": "mbway",
  "acceptedTerms": true, "acceptedMarketing": false,
  "invoice": { … } | null,
  "idempotencyKey": "uuid-v4" }     // §0.6 — duplo-clique não pode criar 2 encomendas
```

```jsonc
// 201
{ "orderId": 98231, "reference": "LB-98231", "status": "awaiting_payment",
  "payment": {
    "method": "multibanco",
    "multibanco": { "entity": "21234", "reference": "123 456 789",
                    "amount": { "amount": 8295, "label": "€ 82,95" },
                    "expiresAt": "2026-09-19T21:30:00Z" }
    // "mbway": { "pollUrl": "…", "expiresIn": 240 }
    // "card":  { "redirectUrl": "https://…" }
  },
  "nextUrl": "/pt/compra/98231" }
```

Erros que o design não prevê: `409 sold_out`, `409 cart_expired`, `422 terms_not_accepted`, `402 payment_failed`.

### 5.10 `GET /api/checkout/order/:orderId` — confirmação / polling

Alimenta o(s) ecrã(s) em falta da §3.1: `status`, dados de pagamento, bilhetes emitidos, `events.instructions`, e os reenvios que já existem (`/delivery/send-email`, `/delivery/send-whatsapp`).

### 5.11 Webhook do PSP

`POST /api/checkout/webhooks/:psp` — confirmação assíncrona (Multibanco pago dias depois, MB WAY confirmado no telemóvel). Sem isto, o "48 h" da §3.1 não fecha. Verificar assinatura; idempotente.

---

## 6. Mapeamento com o banco actual

| Campo da API | Origem |
|---|---|
| `event.*` | `events` ⋈ `places`/`cities` (igual ao contrato anterior) |
| `event.instructions` | `events.instructions` |
| `ticketing.mode` | existe mapa (`maps` / `places_maps`) → `"seatmap"`, senão `"tiers"` |
| `tiers[]` | `products_lots` (`lot_number`, `lot_name`, `price`, `tax`) ⋈ `products` ⋈ `products_types` |
| `tiers[].available` / `status` | `GetProducts::getAvailable()` = `products_sales_limit.sales_limit` − vendidos. **`"limited"` não tem regra hoje** (§3.7) |
| `sectors[]` | `maps_sector`, `maps` |
| `seats[]` | `maps_seats` ⋈ `products_seats` (`row`, `seat`, `label`, `left`, `top`, `status`, `salable`) |
| `cart.expiresAt` | `products_seats.reserved_at` + TTL |
| `cart.lines[]` | `cart['event'][id]['products'][idProduct][idType]` de `CartLib` / tabela `cart` |
| `cart.totals.*` | `CartLib::persistCart()` |
| `cart.coupon` | `coupons_codes` ⋈ `coupons` ⋈ `coupons_products` — **cálculo por implementar** (§4.2) |
| `buyer.*` | `customers` (`name` único → §4.3; `city`/`region`/`country` varchar → §4.5) |
| `payment-methods` | `sales_points_payment_type` ⋈ `payment_types` |
| `invoice` | `customer_saft` (`name`, `nif`, `morada`, `email`, `id_order`) |
| `order.*` | `orders`, `orders_status`, `orders_payment`, `orders_payment_status`, `sales`, `sales_items` |
| `multibanco.entity/reference` | fluxo SIBS já existente (`CartLib::sendEmailMultiBanco`) |
| **`municipality` (Concelho)** | **não existe** — `cities` tem ~22 linhas (§4.5) |

---

## 7. Decisões pendentes antes de implementar

**Produto / negócio**
- [ ] Checkout sem conta substitui mesmo o login, ou coexistem? O que acontece a quem já tem conta e compra como convidado com o mesmo e-mail?
- [ ] O passo de entrega desaparece? E os eventos com `events_deliveries` pagas / levantamento em bilheteira?
- [ ] O que entra exactamente em "Custos de operação" — e onde aparece o IVA?
- [ ] Apple Pay / Google Pay: confirmados com o PSP e a acrescentar aos T&C? PayPal / MBnet / Paysafe saem?
- [ ] Regra do badge "Limitado".
- [ ] Máximo de bilhetes por encomenda e por lugar.
- [ ] O carrinho passa a ser mono-evento?
- [ ] O link de comissário (`?ref=` / ponto de venda) continua a atribuir a venda?

**Design (a pedir ao autor do Figma)**
- [x] Ecrãs pós-"Continuar": sucesso, Multibanco (entidade/referência/48 h), MB WAY a aguardar, recusado — **feitos** (§3). Falta o 3DS/redirect.
- [x] Estados do cupão (aplicado / inválido / remover) — **feitos**.
- [x] Erros de campo e reserva expirada — **feitos**. Falta loading e esgotou-durante-o-checkout.
- [x] Formulário de cartão inline — **feito** (`5727:7304`). Falta decidir se é mesmo inline ou hosted.
- [x] Cronómetro/expiração da reserva de lugares — **feitos** (`5729:7404`, `5729:8125`).
- [ ] Corrigir §2.1 a §2.8 (nomes dos frames, total do `11657`, componente `Pagamentos` em mobile).

**Técnico**
- [ ] Onde vive a API — rotas do Next (`src/app/api/**`, como `/api/eventos`) ou novo serviço a falar com o Phalcon?
- [ ] Fonte de dados de países/concelhos.
- [ ] Chave de idempotência + reserva de stock na criação da encomenda.
- [ ] Webhook do PSP e reconciliação das referências Multibanco.
- [ ] Plano de desmontagem do proxy `src/app/[locale]/checkout/[...path]/route.ts` (e do `public/checkout-theme.css`) quando o checkout nativo entrar.
