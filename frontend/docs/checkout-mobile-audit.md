# Auditoria do checkout no mobile — achados e plano de correção

Levantamento feito a 375×812 (iPhone-like), no proxy local `/{locale}/checkout/...`,
percorrendo o fluxo completo em dois eventos:

- **1664** — Dire Straits Legacy (evento **com mapa de lugares**)
- **2056** — Roda do Viva o Samba (evento **simples**, só seletor de quantidade)

Passos cobertos: 1 Bilhetes (carrinho recolhido e aberto), 2 Os seus dados (com e sem
erro de validação), 3 Pagamento. Não foi concluído nenhum pagamento.

## Contexto: o que é nosso e o que é do upstream

O checkout é a app externa `checkout.lebillet.eu`, servida através do proxy em
`src/app/[locale]/checkout/[...path]/route.ts`. Não temos acesso ao código dela.
Os dois pontos onde conseguimos intervir são os que o proxy já usa hoje:

1. **`public/checkout-theme.css`** — folha de estilo injetada no `</head>`.
2. **O `<script>` injetado a seguir ao `<body>`** dentro do `route.ts` — já faz
   coisas deste género (passos ativos, `restyleTicketRows`, delegação de cliques).

Ou seja, todas as correções abaixo são viáveis sem tocar no upstream.

---

## Achados

### A1 — CRÍTICO · O total do carrinho é inalcançável no mobile

Foi o que reportaste, e na prática é pior do que parecia.

`.cart-sidebar` é, abaixo de 900px, uma gaveta `position: fixed` ancorada ao fundo.
Medições reais:

| Estado | altura | `overflow-y` | `scrollHeight` | `clientHeight` | dá para scrollar? |
|---|---|---|---|---|---|
| Recolhido (2056) | 162px | `visible` | 630 | 162 | **não** — transborda para fora do ecrã |
| Aberto (1664) | 406px | `auto` | 406 | 406 | **não** — conteúdo cortado |

Com o carrinho recolhido, a linha `Total` fica em **y=1140** numa viewport de 812.
Como o contentor é `fixed`, a página não a consegue trazer para o ecrã: o total está
fora de alcance, não apenas tapado. O mesmo acontece ao contador
**"Tempo para finalizar compra 09:24"**, que é informação sensível numa reserva com
prazo.

Com o carrinho aberto no evento com mapa, o `Total` ocupa y=718–768 e o botão
`#button-products` (fixo, 60px) está em y=752–812 — os últimos 16px do total ficam
por baixo do botão. É exatamente o teu screenshot.

Agrava: `padding-bottom: 0` na gaveta, portanto nada reserva espaço para o botão fixo.

### A2 — CRÍTICO · A mensagem de erro pode ficar 100% invisível

`setRegister()` no `checkout.js` do upstream faz:

```js
$('#div-msg-register').html('<div class="alert alert-danger" role="alert">' + data.msg + '</div>');
setTimeout(() => {
  document.getElementById('div-msg-register')?.scrollIntoView({ behavior:'smooth', block:'start' });
}, 50);
```

Dois problemas somados:

1. **O `scrollIntoView({block:'start'})` não desconta o header fixo.** Medi a caixa de
   erro em y=0–74 e o `.tkt-checkout-header-mobile` em y=0–98. A mensagem fica
   inteiramente atrás do header — o utilizador carrega em Continuar e não vê nada.
   No teu screenshot ainda era visível porque a posição de scroll calhou diferente;
   no meu teste desapareceu por completo.
2. **O nosso próprio tema mata o vermelho.** Em `checkout-theme.css:1021`:

   ```css
   .card, .list-group-item, .alert {
     background: var(--bg-tertiary) !important;
     border: 1px solid var(--border-default) !important;
     color: var(--text-primary) !important;
   }
   ```

   Como não há regra para `.alert-danger`, o erro herda o aspeto de cartão neutro:
   fundo cinzento, texto branco, borda igual à dos campos. Foi isto que te fez dizer
   que "confunde com o conteúdo da página" — a causa é nossa, não do upstream.

Além disso: **nenhum campo é marcado** e **o foco vai para o primeiro campo do
formulário** (`name`), não para o campo errado.

### A3 — ALTO · Mensagens de erro não estão mapeadas a campos

A validação é toda no servidor e devolve **uma mensagem de cada vez** em
`{success:false, msg:"..."}`. Enumerei o conjunto completo por POST direto ao
endpoint `/{id}/login/register`:

| `msg` devolvida | Campo a marcar |
|---|---|
| `Informe o nome completo` | `name` (ou `name_apelido` se for esse o vazio) |
| `Informe um email válido` | `email` |
| `Email de confirmação inválido` | `email_confirm` |
| `Informe o número de telefone` | `cell_number` |
| `Telemóvel de confirmação inválido` | `cell_number_confirm` |

Notas apanhadas na enumeração:

- `email` vazio devolve **"Email de confirmação inválido"**, não "informe um email" —
  a mensagem aponta para o campo errado. Vale marcar ambos nesse caso.
- Indicativos diferentes (`+351` vs `+44`) com o mesmo número devolvem
  "Telemóvel de confirmação inválido", mas o campo visualmente errado é o **seletor
  de país**, não a caixa do número.
- `name` com uma só letra passa na validação.

### A4 — ALTO · Conteúdo tapado pela gaveta do carrinho nos passos 2 e 3

A gaveta fixa (y=650–812) e o botão (y=752–812) tapam conteúdo real:

- **Passo 2:** os selects **País** e **Distrito / Concelho** ficam por baixo, e o texto
  "Os bilhetes serão enviados por e-mail e whatsapp" é cortado a meio.
- **Passo 3:** o link **"Termos e Condições do Evento"** fica por baixo — e é um link
  que o utilizador tem de conseguir ler antes de aceitar. O "Olá Teste Teste / Sair"
  fica atrás do botão.

### A5 — MÉDIO · Alvos de toque abaixo de 40px

Recorrente em todos os passos:

| Elemento | Tamanho |
|---|---|
| `−` / `+` de quantidade | 29×34 e 30×34 |
| Controlos do mapa (`+`, `−`, `⌂`) | 32×32 |
| `×` remover item do carrinho | 15×24 |
| Botão de fechar genérico | 25×25 |
| "Código Promocional" | 296×31 |
| "Termos e Condições do Evento" | 187×17 |
| "Sair" | 36×19 |

O mínimo recomendado é 44×44 (Apple HIG) ou 48×48 (Material). O `×` de remover a
15px de largura é o mais arriscado: é destrutivo e está encostado a outros alvos.

### A6 — MÉDIO · Campos sem label associada

Passo 2: `name_apelido` (só placeholder), `selectMobileNumber`,
`selectMobileNumberConfirm`, `city`.
Passo 3: os três `paymentRadio` e os dois `send-saft-method`.

Sem `<label for>` nem `aria-label`, um leitor de ecrã anuncia estes campos sem nome.
Nos rádios de pagamento isto significa não conseguir distinguir MB WAY de Multibanco
de cartão.

### A7 — MÉDIO · Área vazia enorme acima do mapa de lugares

No evento 1664 o contentor do mapa ocupa y=142–775 (633px) mas o desenho só começa
por volta de y=590 — cerca de 450px de preto antes de qualquer coisa visível. Em
mobile isso é mais de meio ecrã desperdiçado, e dá a impressão de página partida.

### A8 — BAIXO · Carrinho acumula eventos diferentes sem o tornar óbvio

Ao entrar no checkout do 2056 tendo passado antes pelo 1664, o carrinho ficou com os
dois (€80,00 + €15,00 = €103,18). Pode ser intencional, mas como o total está
escondido (A1), o utilizador pode chegar ao pagamento com um item que não sabe que lá
está. Confirmar se é comportamento desejado.

### A9 — BAIXO · Barra de passos cortada no passo 3

No passo 3 a régua de passos aparece deslocada à esquerda, com "1 Bilhetes" cortado
pela margem. É o `scrollIntoView` do nosso próprio script de passos
(`route.ts`) a deixar a linha a meio.

---

## Plano de correção

Ordenado por impacto na conversão. As fases 1 e 2 são as que desbloqueiam compra.

### Fase 1 — Desbloquear a compra (crítico) — **FEITO**

**1.1 Tornar a gaveta do carrinho scrollável e reservar espaço para o botão**
`checkout-theme.css`, dentro do `@media (max-width: 900px)`:

- `overflow-y: auto` em ambos os estados (hoje é `visible` no recolhido)
- `padding-bottom` ≥ altura do botão (60px) + margem de segurança
- `max-height` limitada à viewport, com `-webkit-overflow-scrolling: touch`
- reservar o espaço do botão fixo também no fim do conteúdo da página

Critério de aceitação: com o carrinho em qualquer estado, `Total` e
"Tempo para finalizar compra" ficam alcançáveis por scroll e nunca sob o botão.

**1.2 Manter o total sempre visível**
Como pediste que esteja *sempre* visível: promover `Total` a uma linha fixa no topo
da gaveta (fora da área que scrolla), ao lado do label "Carrinho de compras". Assim
o valor lê-se mesmo com a gaveta recolhida, que é o estado por omissão.

**1.3 Estilar `.alert-danger` como erro a sério**
Acrescentar ao tema, depois da regra genérica `.alert`:

- fundo e borda em tom de erro (é preciso introduzir um token — o tema não tem
  nenhuma cor de erro definida, como o próprio ficheiro nota na linha 843)
- ícone de aviso e peso de texto que o distinga de um cartão
- variantes `.alert-success` / `.alert-warning` pelo mesmo critério, para não ficarem
  todas iguais

### Fase 2 — Erros acionáveis (crítico) — **FEITO**

**2.1 Scroll que respeita o header fixo**
No script injetado no `route.ts`, envolver `#div-msg-register` com
`scroll-margin-top` igual à altura do header mobile, ou substituir o
`scrollIntoView` do upstream por um scroll próprio com offset.

**2.2 Mapear mensagem → campo, marcar e focar**
Intercetar a resposta de `/login/register` (o script já intercepta
`XMLHttpRequest.prototype.open` para os passos — dá para estender ao `.done`, ou
observar `#div-msg-register` com um `MutationObserver`, que é menos intrusivo).
Ao detetar erro:

1. limpar marcações anteriores
2. mapear a `msg` para o campo pela tabela de A3
3. aplicar `aria-invalid="true"` + classe de erro (borda vermelha) no campo
4. `focus()` no campo e scroll com o offset do header
5. limpar a marcação no `input` seguinte desse campo

Como o servidor devolve um erro de cada vez, o "corre até ao primeiro" resolve-se
naturalmente. Se quisermos mostrar vários de uma vez, é preciso validação no cliente
antes do POST — proponho deixar para a fase 4 e primeiro corrigir o que existe.

**2.3 Mensagem junto ao campo**
Além do bloco no topo, repetir a mensagem por baixo do campo marcado. É o padrão que
o utilizador espera e evita depender do scroll.

### Fase 3 — Não tapar conteúdo (alto) — **FEITO**

**3.1** Reservar, no fim do conteúdo de cada passo, a altura da gaveta + botão, para
que País / Distrito / Termos e Condições nunca fiquem por baixo (A4).
**3.2** Rever o `scrollIntoView` da régua de passos para não deixar a linha cortada (A9).

### Fase 4 — Toque e acessibilidade (médio) — **FEITO**

**4.1** Subir todos os alvos da tabela A5 para 44×44 mínimos, com prioridade para o
`×` de remover item.
**4.2** Acrescentar `aria-label` aos campos de A6 pelo script injetado, com destaque
para os rádios de pagamento.
**4.3** Confirmar que os campos marcados como inválidos são anunciados
(`aria-invalid`, `aria-describedby` a apontar para a mensagem).

### Fase 5 — Polimento (baixo) — **PARCIAL**

**5.1** Recortar o espaço morto acima do mapa (A7) — provavelmente um `viewBox` ou
uma altura fixa herdada do desktop.
**5.2** Decidir e tornar explícito o comportamento do carrinho multi-evento (A8).
**5.3** Validação de nome com uma só letra (A3) — é do servidor, exige o upstream.

---

## O que precisa do upstream

Quase tudo acima é resolúvel no tema e no script injetado. Ficam dependentes do
`checkout.lebillet.eu`:

- devolver **todos** os erros de uma vez em vez de um a um, e identificar o campo
  (`{field: "cell_number_confirm"}`) em vez de só a mensagem — hoje dependemos de
  casar strings em português, o que parte se mudarem o texto ou acrescentarem idioma
- corrigir a mensagem de email vazio, que aponta para o campo errado
- a validação de nome com uma só letra


---

## Registo de execução — fases 1 e 2

Implementadas em `public/checkout-theme.css` e no script injetado por
`src/app/[locale]/checkout/[...path]/route.ts`. Verificado a 375×812 nos eventos
2056 (simples) e 1664 (com mapa), nos estados recolhido e aberto da gaveta.

**Feito**

- Gaveta do carrinho em coluna: cabeçalho fixo + corpo com `overflow-y: auto` e
  `padding-bottom: 76px` para a altura do botão. Recolhida, passa a medir o que o
  cabeçalho precisa em vez dos 20% cravados, que não chegavam.
- Total espelhado no cabeçalho da gaveta e mantido em sincronia por
  MutationObserver. Visível em qualquer estado: € 86,89 no 1664, € 16,29 no 2056.
- `.alert-danger` com fundo, borda, cor e ícone de erro; `--error*` acrescentado ao
  `:root` (antes não havia token nenhum).
- Mensagem → campo pela tabela de A3, com `aria-invalid`, `aria-describedby`,
  contorno vermelho no grupo inteiro (indicativo + número) e a mensagem repetida por
  baixo do campo. Foco e scroll até ao campo; a marca limpa-se ao escrever.
- `--tkt-drawer-h`, medido da gaveta, reserva espaço no fim da coluna de conteúdo.
  Sem isto o passo 2 media exatamente uma viewport e os campos por baixo da gaveta
  eram inalcançáveis — o scroll não os trazia.

**Três coisas que só apareceram ao implementar**

1. O `scrollIntoView` do upstream corre num `setTimeout(50)` e sobrepunha-se ao
   nosso scroll, deixando a pessoa a olhar para o topo do formulário. O nosso passou
   a correr a 120ms, depois dele.
2. A debounce do observador usava `requestAnimationFrame`, que não corre em separador
   em segundo plano: a flag ficava presa e o observador morria em silêncio. Trocada
   por `setTimeout`. Afetava quem trocasse de app a meio da compra.
3. Quem faz scroll não é a janela — `#tickets-container` e o próprio
   `form#tickets-form-register` têm `overflow-y: auto`, e o documento mede uma
   viewport exata. O `window.scrollTo` não fazia nada; agora subimos até ao primeiro
   ancestral que realmente scrolla.

As correções ficaram num IIFE próprio, separado do que mexe na árvore do upstream,
com `try/catch`: antes, uma exceção nesse código levava tudo atrás sem aviso.

**Por fazer nessa altura:** fases 3 a 5 — feitas a seguir.


---

## Registo de execução — fases 3 a 5

**Fase 3**

- A4 ficou resolvido pela reserva de espaço da fase 2: o link dos Termos, que estava
  permanentemente por baixo da gaveta, passa a ser alcançável por scroll (verificado:
  chega a y=460, dentro da faixa livre).
- A9: a tira de passos media 386px de conteúdo numa linha de 375. Com `gap: 8px` e
  rótulo a 13px passa a caber (`scrollWidth` 375 = `clientWidth`), portanto não há
  scroll e o "1 Bilhetes" deixa de aparecer cortado.

**Fase 4**

| Alvo | Antes | Agora |
|---|---|---|
| Steppers `−` / `+` | 29×34, 30×34 | 44×44 |
| Controlos de zoom do mapa | 32×32 | 44×44 |
| "Código Promocional" | 296×31 | 296×44 |
| "Sair" | 36×19 | 60×44 |
| `×` remover item | 15×24 | área de toque 44×44 (`::after`) |
| Chevron do carrinho | 25×25 | área de toque 44×44 (`::after`) |

Nos dois últimos a área foi esticada com um `::after` invisível em vez de crescer o
botão: aumentá-los visualmente estragava o desenho do carrinho.

Acessibilidade: os 11 campos do passo 3 passaram de 5 sem nome para **0**. Os métodos
de pagamento só tinham a imagem, sem `alt` nem texto — o nome sai agora de um mapa
explícito de nome de ficheiro (`mb_way.png` → MB WAY, etc.), não adivinhado.

**Fase 5**

- A7: `.map-container` tinha `height: 78vh` (633px) e o desenho, com outro rácio,
  ficava centrado com ~150px de preto em cima e em baixo. A altura passa a sair do
  viewBox do próprio mapa, calculada em `fitMapHeight` e escrita em `--tkt-map-h`:
  328px neste recinto, **305px poupados**. Não serve `height: auto` — os atributos
  `width/height` do SVG (1776×600) dão outro rácio e o mapa colapsava para 127px.
- A8 (carrinho multi-evento) fica por decidir: é comportamento de produto, não um bug.
  Com o total agora sempre visível o risco baixou bastante.
- A3 (nome com uma só letra) é validação do servidor, fora do nosso alcance.

**Dois bugs encontrados durante a fase 4**

1. Os `<label>` dos métodos de pagamento apontam para ids inexistentes
   (`for="flexRadioDefa…"`).
2. Os dois rádios do "Emitir fatura" partilham o **mesmo id** (`send-saft-method5`).
   Como `getElementById` devolve sempre o primeiro, **tocar no rótulo "Sim"
   selecionava "Não"** — confirmado no browser antes e depois. Não era só
   acessibilidade: não se conseguia pedir fatura pelo rótulo.

`repairFormIds` trata os dois: dá id único a cada input de um `.form-check` e aponta
o rótulo do bloco ao seu próprio input. Só renomeia ids repetidos, nunca a primeira
ocorrência, para não partir código do upstream — que, com ids repetidos, já só
alcançava o primeiro de qualquer maneira.

---

## Correções de seguimento (reportadas por screenshot)

**A10 — Controlos do mapa por cima do header.** Os botões de zoom são
`position: absolute; z-index: 1000` (upstream) e o nosso header mobile era `sticky`
com `z-index: 10`. Parados no topo da página não se tocam, mas ao fazer scroll o
header fica fixo e os controlos passam-lhe à frente, sobre a régua de passos. O
header passou a `z-index: 1100` — acima dos 1000 dos controlos e abaixo dos 10000 da
gaveta, que é ao fundo e nunca lhe disputa espaço. Confirmado com `elementFromPoint`
no ponto de interseção: agora responde o header.

**A11 — Goteiras do carrinho diferentes do resto do site.** Três coisas somadas:
`.cart-sidebar` com padding assimétrico (10px à esquerda, 15px à direita),
`.cart-all` com `margin-right: 40px`, e — a menos óbvia — `border: solid <cor>` sem
largura declarada no bloco mobile do upstream, que o browser resolve como `medium`,
ou seja 3px invisíveis de cada lado. O conteúdo acabava entre os 37px e os 333px numa
viewport de 375: desalinhado à direita e com o dobro da goteira do site.

Zerados os três no `@media (max-width: 900px)` e fixado 16px de cada lado, que é o
valor que o rodapé e as secções usam. Medido depois: 16/16 nos dois eventos, sem
scroll horizontal. O desktop ficou intacto (24px de padding, moldura e raio de
cartão, `margin-right: 40px`) — todas as regras estão dentro do breakpoint.

---

## Varredura de confirmação

Passagem completa depois das cinco fases, a 375×812, 320×640 e 740×360 (deitado),
nos eventos **1663** e **1664** (mapa de lugares), **1930** (três tipos de bilhete),
**2056** (simples) e **1855** (esgotado, só seleção no mapa). Passos 1→2→3, com
carrinho vazio e cheio, erro de validação, código promocional e remoção de item.

Seis coisas que tinham escapado:

**A12 — Cartões de bilhete desfaziam-se ao remover um item do carrinho.** O
`restyleTicketRows` só corria no arranque. Quando o checkout redesenha a lista por
AJAX — ao remover um item, ao aplicar um cupão — os cartões voltavam a linhas de
tabela cruas, com o stepper espalhado e selects de 13px de largura. Foi exposto ao
segundo IIFE e passa a correr a cada mudança do DOM (já era idempotente).

**A13 — Controlos de zoom sem classe.** Nalgumas versões de mapa (`versao_mapa` muda
o markup) os botões vêm como `<button>` sem classe, e a regra dos 44px não lhes
tocava. O seletor passou a apanhar também o filho direto de `.map-controls`.

**A14 — Régua de passos voltava a transbordar a 320px** (49px de excesso). Ganhou um
degrau em `max-width: 360px`: gap 4px, rótulo 11px, emblema 20px — mede exatamente
320.

**A15 — Gaveta ocupava 60% do ecrã em landscape.** A 740×360 os 60vh do `openAuto`
davam 216px de 360, deixando 56px para escolher bilhetes. Em viewports com menos de
500px de altura a gaveta desce a 48vh e o cabeçalho fica compacto, sem perder o
total.

**A16 — Alvos que faltavam:** "← Voltar" (também aparece dentro do `<h2.subtitle>`,
não só num `<p>`), os rádios `form-check-inline` do "Emitir fatura" (linha de 52×21,
pequena de mais para servir de alvo como as outras), os selects de quantidade dos
eventos sem stepper (48×40), o campo e o botão do código promocional (38px), e o
fechar e o logótipo do nosso próprio cabeçalho.

**A17 — Dois falsos positivos da sonda**, confirmados como não-problemas: os rádios e
checkboxes de 18px cuja `.form-check` mede 283×63 — verifiquei por clique que tocar
na linha alterna a caixa; e a ausência de total no cabeçalho quando o carrinho está
vazio, que é o comportamento certo.

**A18 — `contentseats` duplicado (corrigido).** O fragmento do mapa é incluído duas
vezes, e cada cópia traz um `<div id="contentseats"></div>` vazio. Antes de renomear
verifiquei no JS servido — `checkout.js`, `embedmap.js`, `novomapa.js` e os scripts
inline, incluindo montagem dinâmica do tipo `'content' + 'seats'` — e a única
referência é uma linha **comentada** (`//$('#contentseats').html('')`). Nada o procura.

`dedupeKnownIds` renomeia só as repetidas (`tkt-dup-contentseats-N`), nunca a primeira,
porque `getElementById` já só alcançava essa: o comportamento fica igual. É uma lista
explícita e não uma limpeza genérica de ids, de propósito — cada entrada tem de ser
verificada uma a uma antes de entrar.

Testado no 1663, 1664 e 1926: zero ids duplicados; `payloadsChannel` e `seatsChannels`
(declarados no mesmo bloco de script) intactos; no 1926, `showSeats(...)` abre o
visualizador e `Seats/getAllSeats` responde 200.

**A19 — `selectWhatsapp`, `inputWhatsapp`, `whatsHelp` duplicados (corrigido).** Ao
contrário do `contentseats`, estes são controlos de formulário reais e o JS do
upstream usa-os — por isso a verificação foi mais longa.

O passo 3 tem um painel por método de entrega (`.div-delivery`, mostrado por
`infoDelivery()` conforme o `<select id="delivery-method">`) e o campo de WhatsApp
existe em dois deles:

| Painel | Método | Cópia |
|---|---|---|
| `#delivery_10` | Whatsapp | a **real**: primeira no DOM, a que o utilizador preenche |
| `#delivery_6` | Email | a linha tem a classe `d-none`, que nenhum JS retira: nunca aparece |

O JS inline usa `$('#inputWhatsapp')` e `$('#selectWhatsapp')`, que só alcançam a
primeira ocorrência — a real. Renomear a segunda mantém isso exatamente igual.

O que a diferencia do `contentseats`: os `<label for>` e os `aria-describedby` da cópia
repetida apontavam para o id antigo, ou seja, para o campo da **outra** cópia. O
`dedupeKnownIds` repõe-nos, mas só dentro do painel do nó renomeado, para não tocar no
que pertence à cópia original.

Testado (1930 e 1663, passo 3): zero ids duplicados; as renomeadas ficam todas em
`delivery_6`; todas as referências apontam para um id do próprio painel. No fluxo
Whatsapp: o painel 10 mostra-se, `$('#inputWhatsapp')` continua a resolver para ele,
o `keyup` dispara no campo real, `compareNumbersWhats` lê os valores digitados e o
botão passa a "Continuar". Tocar no rótulo foca o campo certo.

**A20 — `whatsapp` submetido duas vezes (corrigido).** O `#tickets-form-delivery-payment`
tem um painel por método de entrega e o `infoDelivery()` do upstream só os esconde com
`display:none` — os campos dos escondidos ficam no formulário e são serializados.
Medido antes: em **qualquer** método escolhido saía

```
whatsapp_country=+351&whatsapp=933444555&whatsapp_confirm=933444555
&whatsapp_country=+351&whatsapp=
```

O PHP fica com o último valor de uma chave repetida, portanto o número escrito podia
chegar ao servidor como vazio. Não confirmei o que o servidor guarda (exigiria submeter
o passo), mas era o suspeito óbvio para entregas por WhatsApp falhadas.

`syncDeliveryFields` desativa, nos painéis **não ativos**, apenas os campos cujo `name`
também existe no painel ativo. Só dois nomes colidem (`whatsapp` e `whatsapp_country`);
`email`, `whatsapp_confirm` e `mobile_*` são exclusivos de um painel e continuam a seguir
como antes, porque não sabemos se o servidor conta com eles. Campos `disabled` não são
serializados mas `.val()` continua a lê-los, por isso o JS que usa `#inputWhatsapp` não
repara. Cada campo desativado por nós leva `data-tkt-off`, para só reativarmos os nossos.

O sincronismo corre no arranque do fragmento e num listener de `change` **em captura**
no `document`. A captura é essencial: o `onchange` do `<select>` chama `infoDelivery()`,
que serializa o formulário nessa mesma volta para o `/cart/set-delivery`; um listener
normal chegava tarde e essa serialização saía com o estado anterior.

Testado no 1663, passo 3, trocando de método com eventos reais:

| Método | Painel ativo | Desativados por nós | `whatsapp` enviado |
|---|---|---|---|
| Whatsapp | `delivery_10` | `whatsapp`, `whatsapp_country` @ `delivery_6` | `911111111` (uma vez) |
| Email | `delivery_6` | os mesmos @ `delivery_10` | vazio (uma vez) |
| SMS | `delivery_12` | nenhum (não tem campos `whatsapp`) | igual a antes |
| Whatsapp (volta) | `delivery_10` | reativados e reaplicados corretamente | `911111111` |

O que o `/cart/set-delivery` recebeu **no momento da troca** já estava correto, e o
corpo de `goSetDeliveryPayment()` (interceptado, sem chegar ao servidor) também.
No SMS o campo continua repetido, mas nesse método o `whatsapp` não é usado.

**A21 — "Continuar" perde o passo quando o carrinho é redesenhado (corrigido).**
O `#button-products` vive dentro do `.cart-resume`, que o upstream redesenha por AJAX
com a resposta do servidor, e essa resposta traz **sempre** o botão com
`onclick="goNewFunction(1);"` (verificado a ler a resposta de `/cart/set-delivery`).
Medido no passo 3: trocar o método de entrega, ou aplicar/remover um cupão
(`cartResume()`), deixava o Continuar a chamar o passo 1 (`goLogin`) em vez de avançar
para o pagamento. Afeta o `infoDelivery()`, o `cartResume()` e o `setInstallments()`.

O próprio upstream conhece o defeito: em `goDeliveryPayment()` e após
`set-delivery-payment` repõe o botão à mão com `setTimeout` de 3 e 4 segundos. Ficaram
sem esse remendo os outros redesenhos.

`functionButton`, a variável do upstream que guarda o passo pretendido, **não serve**
para o repor: medi `functionButton = 2` com o botão em `goNewFunction(3)` (quem já tem
sessão salta o passo 2).

`keepContinueStep` guarda o `onclick` do botão e, quando o nó é substituído, repõe-no.
**Só se a régua de passos não mudou** — esta guarda é o essencial. O "Voltar" chama
`goProducts()`, que também acaba a redesenhar o `.cart-resume`, e aí o servidor repõe
`goNewFunction(1)` de forma **legítima**. Nesse caso a régua passa a 1 (o
`setActiveStep` corre no `open` do XHR, antes da resposta), logo não se repõe nada.
Sem a guarda, o Voltar deixava de funcionar.

A memória só se atualiza quando o `onclick` muda a sério (observador de atributo) e
quando aparece um nó novo — nunca num tick qualquer. Se atualizasse o passo a cada
tick, o Voltar gravava "passo 1 + onclick antigo" antes do redesenho e a reposição
seguinte repunha exatamente o que não devia.

Testado a 375px nos passos 1, 2 e 3, e a 1440px:

| Ação | Régua | `onclick` depois | Esperado |
|---|---|---|---|
| Trocar método (Email, SMS, Whatsapp) no passo 3 | 3 | `goNewFunction(3)` | mantém |
| `cartResume()` (cupão) no passo 3 | 3 | `goNewFunction(3)` | mantém |
| `cartResume()` (cupão) no passo 2 | 2 | `goNewFunction(2)` | mantém |
| `cartResume()` no passo 2, a 1440px | 2 | `goNewFunction(2)` | mantém |
| Voltar do header, do passo 3 | 1 | `goNewFunction(1);` | **repõe (legítimo)** |
| Voltar do header, do passo 2 | 1 | `goNewFunction(1);` | **repõe (legítimo)** |
| Remover item (×) no passo 3 | 1 | `goNewFunction(1);` | **repõe (legítimo)** |
| Escolher bilhetes no passo 1 | 1 | `goNewFunction(1);` | igual |

E o clique no Continuar, depois de trocar de método e aplicar `cartResume()`, chama
agora `/cart/set-delivery-payment` (avança para o pagamento) em vez de `/login`.
O ciclo passo 1 → 3 → Voltar → 1 → 3 mantém-se coerente.

---

## Segunda varredura — gaveta recolhida, passo 2 e larguras (23/09/2026)

Reportado: com o carrinho fechado, no passo 2, via-se parte do "Código Promocional"
por cima do Continuar. Pedido: recolhido, só o total. Aproveitou-se para percorrer
outra vez o fluxo em 1664 (mapa), 1930 (três tipos), 2089 (modelo `ticket-box`), 1926
(lugares numerados), 2006 (mapa de mesas com esgotados) e 1903 (venda encerrada), a
375×812, 320×640, 740×360, 768×1024 e 1280/1440. Sem registo nem pagamento.

**A22 — Cupão a espreitar na gaveta recolhida.** Guardava-se no corpo uma faixa de
60px para o Continuar (fixed) tapar, mas a faixa começava 24px acima dele. Agora o
corpo fica com altura zero e `visibility: hidden` (sai também da ordem de tabulação),
o botão volta a `visible`, e os 60px passam a ser reservados no fundo da gaveta. Com
o carrinho vazio não há botão e a reserva sai (`:not(:has(#button-products))`; sem
suporte a `:has()` fica a reserva, que é o lado seguro).

**A23 — Folga da página presa ao estado anterior da gaveta.** O `--tkt-drawer-h` só
era medido em mudanças de nós; abrir e fechar só troca classes. Depois de a gaveta
abrir sozinha (60vh, 488px) e ser fechada (233px), ficavam 255px de vazio a mais no
fim da página. Passa a
haver um `ResizeObserver` na gaveta.

**A24 — País e Distrito escondidos numa caixa com scroll próprio.** O
`#tickets-form-register` traz inline `height: 90vh; overflow: auto !important;
scrollbar-width: none`. No telemóvel eram 149px de campos dentro de uma caixa sem
barra, dentro de uma página que já scrolla. Como o `!important` é inline, o
`unboxRegisterForm` tira-o por JS abaixo dos 900px (e repõe o original acima). O
desktop fica como o upstream desenhou — lá os campos cabem nos 90vh.

**A25 — Tablet (768–900px) partido.** O Bootstrap já aplicava `col-md-7/col-md-5` e
o upstream continuava em modo gaveta: mapa com 58% e faixa vazia à direita, gaveta
com 320px encostada à esquerda. As duas colunas passam a 100% nessa faixa.

**A26 — Alinhamentos.** Título do carrinho e seta estavam 15px para dentro (colunas
do Bootstrap); o campo do cupão 8px (`margin-left` inline) e com 38px contra os 44 do
"Aplicar"; os campos do passo 2 nos 31px (15px inline no formulário). Tudo nos 16px
do resto do site.

**A27 — 320px.** O "CARRINHO DE COMPRAS" quebrava em duas linhas (a seta tinha uma
coluna `col-2` de 48px) e, no cabeçalho, o fechar sobrepunha 16px da sua área de
toque ao logótipo. O logótipo passa a encolher e a seta mede o que mede.

**A28 — Deitado (740×360).** Cabeçalho fixo (102px) mais gaveta recolhida (160px)
deixavam 98px úteis. Com `max-height: 500px` o cabeçalho deixa de ser sticky.

**A29 — Modelo `table.ticket-box`** (ex.: 2089), que o `restyleTicketRows` não
converte: o select de quantidade tinha 19px e, num lote de nome comprido, o "+" caía
sozinho para a linha de baixo. Select a 48px e -/select/+ agrupados num `.tkt-qty`.

**A30 — Cronómetro da reserva invisível.** "Tempo para finalizar compra" arranca
depois do registo e vive no corpo da gaveta, que recolhida não se vê. Espelhado no
cabeçalho (`syncCartTimer`), como o total. Testado simulando a classe e o texto do
upstream no browser — o passo 3 real exige criar conta.

**A31 — 367 pedidos ao Google Translate por cada abertura do passo 2.** O
`traduzirTexto` do upstream traduz cada país e cada concelho de `pt` para `pt_pt` (o
destino é forçado), todos recusados por CORS, com o País desativado até acabarem —
e cada pedido leva o IP do visitante ao Google sem consentimento. O proxy responde
a esses `fetch` com o próprio texto, que é o que o upstream já usava quando falhavam.
Medido depois: 0 pedidos, País e Distrito preenchidos.

**A32 — Nomes acessíveis.** A seta da gaveta ganhou `aria-labelledby` (o título) e
`aria-expanded`; os selects de quantidade passam a "Quantidade, <bilhete>" em vez do
texto à volta ("- 0" ou o preço).

**Fora do checkout, mas no mesmo fluxo:** três eventos listados (1808, 1903, 2064)
já têm `date_sales_end` no passado, e "Selecionar bilhetes" levava a "Vendas
encerradas no site". A página do evento passa a mostrar "Vendas online encerradas"
no lugar do botão e o JSON-LD deixa de anunciar a oferta.

### Do upstream, não corrigido aqui

- **Remover um item com dois eventos no carrinho remove o errado.**
  `POST /1664/products/rem`, feito a partir da página do 1930, devolveu o carrinho
  sem o item do 1930 e com o do 1664. O proxy passa o caminho tal como está, por
  isso é o servidor que remove os itens do evento da sessão e não o do URL.
- O Distrito vem pré-selecionado com "Abrantes" (a primeira opção). Enquanto esteve
  escondido na caixa de scroll, quem não o via submetia "Abrantes".
- `NovoMapa` é declarado outra vez ao voltar ao passo 1 (SyntaxError na consola); o
  mapa continua a responder, é só ruído.
- Mesas indisponíveis no mapa do 2006 não dão resposta ao toque (o aviso "Não
  Disponível" só aparece em hover); o estado lê-se pela tinta vermelha.
