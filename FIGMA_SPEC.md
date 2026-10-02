# Tickett.com — Especificacao Completa do Design (Figma → Codigo)

> **Arquivo Figma:** ibEbbCIbxZWJPXYQphtgGi
> **MCP Tool:** Use mcp_figma_read ou equivalente para inspecionar nodes em tempo real
> **Leia este documento inteiro antes de escrever qualquer codigo.**

---

## 1. DESIGN TOKENS

### 1.1 Cores

:root {
  /* Backgrounds */
  --color-bg-primary: #000000;
  --color-bg-secondary: #0F0F11;
  --color-bg-tertiary: #151518;
  --color-bg-elevated: #1C1C20;
  --color-bg-surface: #2D2D32;

  /* Text */
  --color-text-primary: #FFFFFF;
  --color-text-secondary: #AFAFBC;
  --color-text-muted: #606069;

  /* Accent (Brand) */
  --color-accent-primary: #00B1E3;

  /* Borders */
  --color-border-default: #2D2D32;
  --color-border-subtle: #1C1C20;
  --color-border-strong: #606069;
  --color-border-accent: #00B1E3;

  /* Overlay */
  --color-overlay: rgba(21, 21, 24, 0.90);
  --color-overlay-light: rgba(15, 15, 17, 0.80);
  --color-accent-10: rgba(0, 177, 227, 0.10);
  --color-accent-20: rgba(0, 177, 227, 0.20);
}

### 1.2 Espacamento

:root {
  --space-2: 2px;
  --space-4: 4px;
  --space-6: 6px;
  --space-8: 8px;    /* unidade base */
  --space-10: 10px;
  --space-12: 12px;
  --space-16: 16px;
  --space-20: 20px;
  --space-24: 24px;
  --space-32: 32px;
  --space-40: 40px;
  --space-48: 48px;
  --space-80: 80px;  /* margens laterais desktop */
}

### 1.3 Border Radius

:root {
  --radius-sm: 4px;
  --radius-md: 6px;
  --radius-default: 8px;   /* cards, inputs, botoes */
  --radius-lg: 12px;       /* paineis, cards maiores */
  --radius-xl: 16px;       /* cards destaque */
  --radius-2xl: 20px;
  --radius-3xl: 24px;
  --radius-full: 100px;    /* pills, badges, avatares */
}

### 1.4 Sombras e Efeitos

:root {
  --shadow-card: -4px 4px 50px rgba(15, 15, 17, 1);
  --shadow-elevated: 0px 4px 20px rgba(0, 0, 0, 0.45);
  --shadow-modal: 0px 8px 28px rgba(0, 0, 0, 0.50);

  --blur-sm: blur(4px);
  --blur-md: blur(50px);
  --blur-lg: blur(80px);
  --blur-xl: blur(100px);
}

### 1.5 Layout / Breakpoints

:root {
  --desktop-width: 1440px;
  --mobile-width: 360px;
  --content-padding-desktop: 80px;
  --content-padding-mobile: 16px;
  --navbar-height: 68px;
  --footer-height-desktop: 217px;
  --footer-height-mobile: 593px;
}

Breakpoint: 768px (abaixo = mobile, acima = desktop)

---

## 2. TIPOGRAFIA

Fontes:
- Display/Hero: "Bebas Neue", sans-serif
- Corpo (tudo mais): "Inter", sans-serif

Escala tipografica:

| Token | Fonte | Peso | Tamanho |
|-------|-------|------|---------|
| display-hero | Bebas Neue | 400 | 150px |
| display-hero-sm | Bebas Neue | 400 | 130px |
| heading-h1 | Inter | 700 | 96px |
| heading-h2 | Inter | 700 | 64px |
| heading-h3 | Inter | 700 | 48px |
| heading-h4 | Inter | 700 | 36px |
| heading-h5 | Inter | 700 | 28px |
| heading-h6 | Inter | 700 | 22px |
| body-lg-bold | Inter | 700 | 18px |
| body-md-bold | Inter | 700 | 16px |
| body-md-medium | Inter | 500 | 16px |
| body-md-regular | Inter | 400 | 16px |
| body-sm-bold | Inter | 700 | 14px |
| body-sm-medium | Inter | 500 | 14px |
| body-sm-regular | Inter | 400 | 14px |
| caption-md-medium | Inter | 500 | 12px |
| caption-md-regular | Inter | 400 | 12px |
| caption-sm-medium | Inter | 500 | 10px |
| caption-sm-regular | Inter | 400 | 10px |
| caption-xs | Inter | 400 | 8px |

Line-height: auto em todas. Letter-spacing: 0 exceto display-hero que pode ter -5%.

---

## 3. ICONES

A aplicacao usa Vuesax Linear icons. Estes sao os 22 icones usados nas telas:

add, arrow-down, arrow-left, arrow-right, calendar, check-mark,
clock, close, copy, facebook, global, home-2, instagram, map,
minus, search-normal, share-2, sms, ticket, tiktok, whatsapp, x

Implementacao: Use a lib iconsax-react (variante Linear) ou exporte SVGs do Figma via MCP.

---

## 4. COMPONENTES

### 4.1 Button

| Prop | Valores |
|------|---------|
| variant | primary, secondary |
| size | default (h: 50px), small (h: 40px) |
| state | default, hover, disabled |

- Primary: bg var(--color-accent-primary), texto branco, radius 8px
- Secondary: bg var(--color-bg-elevated), texto branco, radius 8px, border var(--color-border-default)
- Disabled: opacity 0.5
- Padding horizontal: ~24px

### 4.2 Card Destaque (grande)

- Tamanho: 300x315
- Radius: 16px
- Estrutura: Imagem topo (300x200) + Info bottom (300x115)
- Info: titulo (body-lg-bold), local + data (caption-md), preco (body-sm-bold com accent)
- Hover: leve scale ou shadow change

### 4.3 Card General (medio)

- Tamanho: 308x303
- Radius: 12px
- Estrutura: Imagem (308x205) + Info (308x98)
- Mesma estrutura de info que Card Destaque

### 4.4 Card Default (pequeno)

- Tamanho: 200x231
- Radius: 12px
- Estrutura: Imagem (200x133) + Info (200x98)

### 4.5 Card Destaque Min (horizontal)

- Tamanho: 411x80
- Layout: horizontal (imagem esquerda + info direita)
- Hover state disponivel

### 4.6 Navbar

- Tamanho: 1440x68 (full width)
- Layout: Logo esquerda + Menu centro + Acoes direita
- Background: var(--color-bg-secondary)
- Contem sub-row FilterBar com chips de filtro

### 4.7 Footer

- Desktop: 1440x217
- Mobile: 360x593
- Layout vertical com links + copyright
- Background: var(--color-bg-secondary)

### 4.8 Chip (filtro)

| State | Estilo |
|-------|--------|
| default | bg transparent, border var(--color-border-strong), texto secondary |
| hover | bg var(--color-bg-elevated) |
| active | bg var(--color-accent-primary), texto branco |

- Radius: var(--radius-full) (pill)
- Padding: 10px 12px
- Font: caption-md-medium

### 4.9 Dropdown (filtro)

- Default: texto + icone arrow-down, border subtle
- Active: border accent, icone rotaciona

### 4.10 StepCheckout

- Layout horizontal com numero + label
- Active: accent color no numero
- Default: text-muted

### 4.11 Pagamentos

4 variantes: Default, MBWAY, MBMULTI, CARD
- Cada um e um radio-button style card (984x80)
- Border quando selecionado: accent

### 4.12 Switch

- Toggle Sim/Nao
- Active: bg accent
- Inactive: bg surface

### 4.13 Check (checkbox)

- 18x18
- Default: border strong, bg transparent
- Active: bg accent, icone check-mark branco

### 4.14 Carrinho (sidebar)

- Largura: 360px, altura dinamica (~525px)
- Posicao: fixed right no checkout
- Lista de items + total + botao

### 4.15 Paineis de Filtro (Dropdowns expandidos)

| Painel | Tamanho | Conteudo |
|--------|---------|----------|
| Panel-Data | 240x340 | Lista de datas |
| Panel-Local | 240x422 | Lista de locais com search |
| Panel-Preco | 240x299 | Range de precos |
| Panel-Ordenar | 240x299 | Opcoes de ordenacao |
| DatePickerPanel | 360x487 | Calendario mensal |

### 4.16 Componentes Mobile

| Componente | Descricao |
|-----------|-----------|
| Menu | Bottom navigation (4 tabs: Home, Eventos, Bilhetes, Perfil) |
| FilterBarMob | Barra horizontal scrollavel com chips (360x64) |
| Header checkout | Steps 1/2/3 no topo mobile |
| Card default mob | Card com variantes Size (Large/Small) + State |
| Destaque 3 | Hero card mobile (10 variantes de conteudo) |

---

## 5. TELAS — DESKTOP (1440px)

### 5.1 Home (Desktop/Home)

Estrutura top-to-bottom:
1. Navbar (68px) — fixo no topo
2. Hero (438px) — carousel com imagem full-width + overlay texto
3. Destaque 2 (495px) — secao "Em destaque" com cards grandes
4. Destaque (496px) — grid de cards
5. ShowcaseContainer (1467px) — secoes de categorias (Samba, Reggae, etc) com cards horizontais
6. Section/Alertas WhatsApp (203px) — CTA para alertas
7. Section/Promotor (324px) — banner para promotores
8. Footer (217px)

Padding lateral do conteudo: 80px em cada lado.

### 5.2 Eventos (Desktop/Eventos-ListaCompleta)

1. Navbar + FilterBar com chips de categoria
2. Destaque 2 — hero section
3. Secoes por genero: Samba, Reggae, Talks (grid de cards)
4. Footer

### 5.3 Event Detail (Desktop/EventDetail-MapaColapsado / MapaExpandido)

- Header com imagem do evento
- Info: titulo, data, local, preco
- Mapa interativo (colapsado ou expandido)
- Botao "Comprar Bilhete"

### 5.4 Fluxo de Compra (Desktop)

Step 1 — Mapa/Setor:
- TopBarCheckout (68px) com steps indicator
- Corpo: mapa do venue com setores clicaveis
- Sticky bar bottom (68px) com resumo + botao proximo
- Variante: Desktop/Compra-S1b-Lugares — grid de assentos

Step 2 — Dados:
- Formulario: nome, email, telefone, NIF
- Sidebar Carrinho (360px) visible

Step 3 — Pagamento:
- Lista de metodos (MBWAY, Multibanco, Cartao)
- Formulario do metodo selecionado
- Sidebar Carrinho

Layout checkout: TopBar fixa + body split (conteudo esquerda ~70% + carrinho direita ~30%)

### 5.5 Fluxo de Venda (Desktop)

Para promotores/vendedores criarem eventos:

1. Venda-Step1-Evento — selecao do evento
2. Venda-Step2-Ingressos — configuracao de tipos de ingresso
3. Venda-Step3-Dados — dados do comprador (minimo/completo)
4. Venda-Step4-Revisao — resumo final
5. Venda-Sucesso — confirmacao

---

## 6. TELAS — MOBILE (360px)

### 6.1 Home Mobile (Mobile/Home-Completa)

Estrutura scroll vertical:
1. Hero slider (full-width)
2. Destaque 3 (cards verticais)
3. Cards horizontais scroll por categoria
4. Section alertas
5. Section promotor
6. Footer mobile (593px)
7. Menu bottom navigation (fixo)

### 6.2 Compra Mobile

- S1-Mapa: mapa fullscreen com bottom sheet para setor
- S2-Dados: form fullscreen com header de steps
- S3-Bilhetes: lista de bilhetes, confirmacao, QR code

### 6.3 Bottom Sheets

Sheets que sobem do bottom em mobile para filtros:
- Filtros, Ordenar, Data (calendario), Local, Preco, Categoria
- Background com overlay escuro
- Radius top: 16-24px
- Drag indicator no topo

---

## 7. ESTRUTURA DE PASTAS RECOMENDADA

src/
├── styles/
│   ├── tokens.css          (variaveis CSS deste doc)
│   ├── typography.css      (classes tipograficas)
│   ├── reset.css           (normalize/reset)
│   └── globals.css         (estilos globais: body, html)
├── components/
│   ├── ui/
│   │   ├── Button/
│   │   ├── Card/
│   │   ├── Chip/
│   │   ├── Checkbox/
│   │   ├── Switch/
│   │   ├── Dropdown/
│   │   └── Input/
│   ├── layout/
│   │   ├── Navbar/
│   │   ├── Footer/
│   │   ├── Sidebar/
│   │   └── BottomSheet/
│   ├── checkout/
│   │   ├── StepIndicator/
│   │   ├── TopBarCheckout/
│   │   ├── Carrinho/
│   │   ├── Pagamentos/
│   │   └── DatePicker/
│   └── mobile/
│       ├── Menu/
│       ├── FilterBarMob/
│       └── HeaderCheckout/
├── pages/
│   ├── Home/
│   ├── Eventos/
│   ├── EventDetail/
│   ├── Compra/
│   │   ├── Step1Mapa/
│   │   ├── Step2Dados/
│   │   └── Step3Pagamento/
│   └── Venda/
│       ├── Step1Evento/
│       ├── Step2Ingressos/
│       ├── Step3Dados/
│       ├── Step4Revisao/
│       └── Sucesso/
├── assets/
│   └── icons/
└── hooks/
    └── useBreakpoint.ts

---

## 8. REGRAS DE IMPLEMENTACAO

1. NUNCA use valores hardcoded — sempre reference tokens via var(--token)
2. 1 componente Figma = 1 componente codigo — com as mesmas props/variantes
3. Mobile-first NAO — este design e desktop-first. Media query max-width: 768px para mobile
4. Cores de texto — sempre var(--color-text-*), nunca white ou #fff
5. Gaps e paddings — sempre tokens da escala de spacing
6. Border-radius — sempre tokens da escala de radius
7. Dark theme nativo — o design inteiro e dark, nao precisa de theme toggle
8. Imagens — use object-fit: cover com ratio da imagem no card
9. Hover states — transicoes suaves (200-300ms ease)
10. Backdrop blur — use backdrop-filter: blur(var(--blur-*)) nos overlays

---

## 9. COMO USAR O MCP PARA INSPECIONAR

Quando precisar de detalhes exatos de um node, use o MCP Figma:

File key: ibEbbCIbxZWJPXYQphtgGi
Pagina principal: 75:2 (Screens & Components)
Pagina tokens: 236:7182 (Design Tokens MCP Reference)

Nodes importantes para inspecionar:
- Home: 233:4498
- Eventos: 233:4410
- Event Detail: 233:4200
- Compra Step 1: 233:6452 (mapa), 233:6648 (lugares)
- Compra Step 2: 233:7946
- Compra Step 3: 233:8204
- Venda Step 1: 233:8762
- Button component: 233:9862
- Card destaque: 233:9971
- Card general: 233:9996
- Card default: 233:10015
- Navbar: 233:9382
- Footer: 233:9358
- Carrinho: 233:10222

Mobile:
- Home completa: 233:13558
- Home categorias: 233:14524
- Compra mapa: 233:11130
- Compra dados: 233:13229
- Compra bilhetes: 233:14842
- Menu bottom: 233:10635

---

## 10. CHECKLIST DE VALIDACAO

Antes de considerar qualquer componente pronto, valide:

[ ] Usa apenas tokens CSS (nenhum valor magic number)
[ ] Dimensoes batem com o Figma (width, height, padding, gap)
[ ] Tipografia correta (font, weight, size)
[ ] Cores corretas (bg, text, border)
[ ] Border-radius correto
[ ] Hover state implementado
[ ] Responsivo (desktop para mobile)
[ ] Sombras/blur aplicados onde necessario
[ ] Icones corretos (vuesax linear)

---

Documento gerado a partir do Figma file ibEbbCIbxZWJPXYQphtgGi em 2026-07-29.