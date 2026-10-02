# Escopo de dados — API Next.js (Home, Eventos, Detalhe do Evento)

> Contexto: hoje o frontend (Next.js) conecta **diretamente no MySQL** via `src/lib/db.ts` / `src/lib/home-data.ts` / `src/lib/eventos-data.ts`. O objetivo deste documento é especificar os endpoints que a nova **API interna do Next.js** deve expor, para que o frontend pare de falar com o banco e passe a consumir só HTTP — eliminando a camada dupla de backend (Phalcon + Next.js os dois batendo no banco).
>
> Baseado no protótipo Figma "Website-Lebillet" (file `22oZ3zoX3B2cKxymtDs5Ol`), nós telas:
> - Home — node `5471:7652`
> - Eventos (lista completa) — node `5471:7564`
> - Eventos (lista filtrada por categoria) — node `5471:7618`
> - Detalhe do evento (bilhete único / mapa de lugares) — node `5471:7354`
> - Detalhe do evento (lotes múltiplos / sem mapa) — node `5471:7429`
>
> Cruzado com o código atual (`lib/home-data.ts`, `lib/eventos-data.ts`, `types/event.ts`) e o schema (`base.sql`) para manter os nomes de campo realistas.

---

## 0. Observações importantes para quem vai construir a API

1. **Não existe hoje uma relação de categoria/gênero no `events`.** O comentário em `lib/eventos-data.ts` já registra isso: *"There is no genre/category relation on events yet, so this renders as a single section rather than the Música/Festivais/Talks split in the Figma reference."* Os chips do FilterBar (`Todos, Concerto, Festival, Teatro, Stand-up Comedy, Conferência, Desporto, Família, Outro`) e as seções por gênero da tela "Eventos" (Samba, Reggae, Talks…) **precisam de uma coluna/tabela de categoria** que hoje não existe ligada a `events`. Isso é uma decisão de modelagem que precisa ser tomada antes de implementar `/api/eventos` com filtro de categoria.
2. **`event` vs `group`**: o código atual já modela dois tipos de item de listagem (`type: "event" | "group"`), vindo de uma `UNION` entre `events` e `groups` (grupos = ex. line-ups/séries com vários eventos). O contrato abaixo mantém esse campo `type`.
3. **Duas variantes da tela de detalhe** (mesma estrutura visual, ticketing diferente):
   - **Mapa colapsado**: evento com lugares marcados (venue com mapa de setores). Não lista lotes — só mostra "a partir de €X" e um botão único **"Selecionar lugares"** que abre o mapa (fluxo de compra separado, fora do escopo deste JSON).
   - **Mapa expandido**: evento com **lotes/tipos de bilhete sem mapa** (general admission). Lista cada lote com nome, descrição, preço, status (`Disponível` / `Limitado` / `Esgotado`) e um seletor de quantidade. Botão **"Continuar compra"**.
   - A API precisa expor um campo (`ticketing.mode`) para o frontend saber qual UI renderizar.
4. Textos como data/preço já vêm **formatados** hoje pelo próprio `lib/home-data.ts` (`formatDate`, `€X`). Sugiro a API devolver **os dois**: o valor cru (ISO date, number) e o label já formatado em PT — assim o frontend não perde a formatação atual nem fica preso a ela.
5. Seções puramente institucionais/estáticas da Home (**"Por que escolher a Tickett.com", "Alertas WhatsApp", "Venda o seu evento", Footer**) não dependem do banco de eventos — não estão neste escopo.
6. **Visibilidade: só listar `display_in_cover = '1'` E `date_sales_end > NOW()`** (em `events` e em `groups`), como o site PHP faz em todas as listagens (`IndexController`, `ControllerBase`: `WHERE t.date_sales_end > '" . $now . "' AND t.display_in_cover = '1'`). Isso vale para tudo o que lista: na `/home`, `hero`, `destaques`, `maisEventos` e `totalEventosCount`; na `/eventos`, `events`, `pagination.total`, `genres[].count` e `locations`. Em 23/09/2026 a API não filtrava nenhum dos dois campos: havia 5 eventos com `display_in_cover` NULL na lista (1585, 1986, 1994, 1995, 2082) e 3 com a venda encerrada há dias/semanas (1808, 1903, 2064) — não é uma janela de minutos, esses eventos ficam listados indefinidamente até alguém tirá-los à mão. O detalhe (`/eventos/{id}`) continua respondendo para qualquer evento nos dois casos — a página abre por link direto, como no site antigo, e mostra "Vendas online encerradas" no lugar do botão de compra quando é esse o motivo. Enquanto a API não filtrar, o frontend esconde esses eventos consultando o detalhe de cada um (`onlyListed` em `lib/evento-data.ts`, que agora testa os dois campos). Os cartões e a contagem da lista já saem certos, mas as contagens por categoria continuam vindo da API.

---

## 1. Tipos comuns

```ts
type EventType = "event" | "group";

interface EventCard {
  id: number;
  slug: string;
  type: EventType;
  href: string;              // ex.: "/event/123/marisa-monte-orquestra" ou "/group/festival-crato"
  title: string;
  image: string;              // URL absoluta da capa
  city: string | null;
  region: string | null;
  venue: string | null;       // nome do local (place)
  dateStart: string | null;   // ISO 8601
  dateLabel: string | null;   // já formatado em PT, ex.: "Qui, 09 Jul" ou "26–29 Ago"
  priceFrom: number | null;   // valor cru, em EUR (o front formata "€X")
}
```

Esse `EventCard` é o mesmo shape reaproveitado em **todos os carrosséis e grids** (Hero, Top 10, Destaque, seções por gênero, grid "mais eventos", listagem de /eventos) — inclusive já bate com `EventCardData` (`src/types/event.ts`) usado hoje pelos componentes `CardDestaque`, `CardGeneral`, `CardDefault`, `CardDestaqueMin`.

---

## 2. `GET /api/home`

Alimenta `Desktop/Home` (node `5471:7652`): Hero (banner rotativo), "Eventos em Destaque" (Top 10 ranqueado) e grid "Mais eventos" (3x3), além do contador da banner "+500 eventos".

```json
{
  "hero": [
    {
      "id": 91,
      "slug": "marisa-monte-orquestra",
      "type": "event",
      "href": "/event/91/marisa-monte-orquestra",
      "image": "https://cdn.tickett.com/img/banners/phonica-marisa-monte.jpg",
      "city": "Porto",
      "region": "Porto",
      "venue": "Super Bock Arena - Porto",
      "dateStart": "2026-09-20T21:30:00+01:00",
      "dateLabel": "Dom, 20 Set 2026",
      "priceFrom": 50
    }
  ],
  "destaques": [
    {
      "id": 88,
      "slug": "festival-crato-2026",
      "type": "group",
      "href": "/group/festival-crato-2026",
      "image": "https://cdn.tickett.com/img/shows/festival-crato-2026.jpg",
      "city": "Crato",
      "region": "Portalegre",
      "venue": "Vila de Crato - Crato",
      "dateStart": "2026-08-26T15:00:00+01:00",
      "dateLabel": "26–29 Ago",
      "priceFrom": 30
    },
    {
      "id": 91,
      "slug": "marisa-monte-orquestra",
      "type": "event",
      "href": "/event/91/marisa-monte-orquestra",
      "image": "https://cdn.tickett.com/img/shows/marisa-monte.jpg",
      "city": "Porto",
      "region": "Porto",
      "venue": "Super Bock Arena - Porto",
      "dateStart": "2026-09-20T21:30:00+01:00",
      "dateLabel": "Dom, 20 Set",
      "priceFrom": 30
    }
  ],
  "maisEventos": [
    {
      "id": 12,
      "slug": "all-about-bossanova",
      "type": "event",
      "href": "/event/12/all-about-bossanova",
      "image": "https://cdn.tickett.com/img/shows/bossanova.jpg",
      "city": "Lisboa",
      "region": "Lisboa",
      "venue": "Hot Five Jazz&Blues Club",
      "dateStart": "2026-07-09T21:00:00+01:00",
      "dateLabel": "Qui, 09 Jul",
      "priceFrom": null
    }
  ],
  "totalEventosCount": 500
}
```

Notas:
- `hero` é um array porque o banner tem carrossel (setas "anterior/seguinte"). Corresponde ao `featured_premium` no código atual.
- `destaques` = Top 10 ranqueado ("TOP 10 · Eventos em Destaque"), sempre até 10 itens. Hoje vem de `featured`, com *backfill* pelos próximos eventos quando há menos de 10 marcados.
- `maisEventos` = grid de 9 cards (3×3) exibidos abaixo do Top 10, sem preço visível no Figma (mas o campo existe no shape, pode vir `null`).
- `totalEventosCount` alimenta o texto "São **+500** eventos em toda a Europa, Portugal e África" — hoje é um número fixo no design; expor como campo permite trocar sem redeploy do front.

---

## 3. `GET /api/eventos`

Alimenta `Desktop/Eventos-ListaCompleta` (node `5471:7564`) e `Desktop/Eventos-ListaFiltrada` (node `5471:7618`) — é a **mesma tela**, com/sem filtro de categoria aplicado.

### Query params

| Param       | Tipo                                   | Exemplo         | Observação |
|-------------|-----------------------------------------|-----------------|------------|
| `genre`     | string (slug do chip)                   | `concerto`       | Se omitido ⇒ retorna agrupado por seção (ver abaixo). Ver observação 1 sobre a modelagem ainda não existir. |
| `dateFrom`  | string (YYYY-MM-DD)                     | `2026-07-10`     | Chip de data "10/07-17/07" |
| `dateTo`    | string (YYYY-MM-DD)                     | `2026-07-17`     | |
| `location`  | string                                   | `porto`          | Dropdown "Local" |
| `priceMin`  | number                                   | `10`             | Dropdown "Preço" |
| `priceMax`  | number                                   | `50`             | |
| `sort`      | `populares` \| `data` \| `preco_asc` \| `preco_desc` | `populares` | Dropdown "Ordenar" (default `populares`) |
| `page`      | number                                   | `1`              | |
| `pageSize`  | number                                   | `24`             | |

### Resposta — sem `genre` (lista completa, agrupada por seção)

```json
{
  "filters": {
    "genres": [
      { "slug": "todos", "label": "Todos", "count": 312 },
      { "slug": "concerto", "label": "Concerto", "count": 45 },
      { "slug": "festival", "label": "Festival", "count": 18 },
      { "slug": "teatro", "label": "Teatro", "count": 9 },
      { "slug": "stand-up-comedy", "label": "Stand-up Comedy", "count": 12 },
      { "slug": "conferencia", "label": "Conferência", "count": 4 },
      { "slug": "desporto", "label": "Desporto", "count": 7 },
      { "slug": "familia", "label": "Família", "count": 6 },
      { "slug": "outro", "label": "Outro", "count": 3 }
    ],
    "locations": [{ "slug": "porto", "label": "Porto" }, { "slug": "lisboa", "label": "Lisboa" }],
    "sortOptions": [
      { "value": "populares", "label": "Populares" },
      { "value": "data", "label": "Data" },
      { "value": "preco_asc", "label": "Menor preço" },
      { "value": "preco_desc", "label": "Maior preço" }
    ]
  },
  "destaques": [ "...mesmo shape de EventCard do Top 10 da Home..." ],
  "sections": [
    {
      "genre": "concerto",
      "title": "Concerto",
      "count": 45,
      "events": [ "...EventCard[]..." ]
    },
    {
      "genre": "festival",
      "title": "Festival",
      "count": 18,
      "events": [ "...EventCard[]..." ]
    }
  ],
  "pagination": null
}
```

### Resposta — com `?genre=concerto` (lista filtrada, achatada)

```json
{
  "filters": { "...mesmo objeto acima, com o chip 'concerto' marcado como ativo..." },
  "activeGenre": { "slug": "concerto", "label": "Concerto", "count": 45 },
  "destaques": null,
  "sections": null,
  "events": [ "...EventCard[], até 24 por página..." ],
  "pagination": { "page": 1, "pageSize": 24, "total": 45, "totalPages": 2 }
}
```

Notas:
- `sections` só é preenchido quando não há `genre` no filtro (mirror da tela "ListaCompleta", com seções tipo "Samba", "Reggae", "Talks" — cada seção tem um link "ver mais"). Com `genre` aplicado, some `sections`/`destaques` e aparece `events` + `pagination` (mirror da tela "ListaFiltrada", com contador "45 eventos" no topo = `activeGenre.count`).
- Ver Observação 1: os "gêneros" tanto do FilterBar quanto das seções (Samba, Reggae, Talks) precisam de uma tabela/coluna nova — hoje o banco não tem isso ligado a `events`.

---

## 4. `GET /api/eventos/[slug]`

Alimenta `Desktop/EventDetail-MapaColapsado` (node `5471:7354`) e `Desktop/EventDetail-MapaExpandido` (node `5471:7429`).

```json
{
  "id": 91,
  "slug": "marisa-monte-orquestra",
  "type": "event",
  "title": "Marisa Monte & Orquestra - Super Bock Arena",
  "genreLabel": "Concerto",
  "heroImage": "https://cdn.tickett.com/img/banners/phonica-marisa-monte.jpg",
  "city": "Porto",
  "dateStart": "2026-09-20T21:30:00+01:00",
  "dateLabel": "Dom, 20 Set 2026",
  "doorsTimeLabel": "Portas 19h",
  "startTimeLabel": "21:30h",
  "venue": {
    "name": "Super Bock Arena - Pavilhão Rosa Mota",
    "address": "Jardins do Palácio de Cristal, R. de Dom Manuel II, 4050-346 Porto",
    "gps": "41.150370,-8.653050",
    "directionsUrl": "https://maps.google.com/?q=41.150370,-8.653050"
  },
  "ageRating": "M/6 anos.",
  "promoter": "CONQUISTAPADRÃO PRODUÇÕES, LDA",
  "description": "Marisa Monte regressa a Portugal para um momento raro com PHONICA, de Marisa Monte & Orquestra ao vivo, no dia 20 de setembro, na Super Bock Arena — uma das propostas mais ambiciosas da sua carreira, num encontro singular entre a música popular brasileira e a linguagem sinfónica.\n\nEm palco, acompanhada pela sua banda e por uma orquestra sinfónica dirigida pelo maestro André Bachur, Marisa Monte revisita obras que atravessam gerações, em arranjos inéditos criados para este espetáculo.",
  "priceFrom": 30,
  "ticketing": {
    "mode": "seatmap",
    "ctaLabel": "Selecionar lugares",
    "tiers": []
  }
}
```

Exemplo da variante **`mode: "tiers"`** (Festival do Crato — lotes sem mapa de lugares):

```json
{
  "id": 88,
  "slug": "festival-crato-2026",
  "type": "group",
  "title": "Festival do Crato 2026",
  "genreLabel": "Festival",
  "heroImage": "https://cdn.tickett.com/img/banners/festival-crato-2026.jpg",
  "city": "Crato",
  "dateStart": "2026-08-26T15:00:00+01:00",
  "dateLabel": "26 a 29 Ago 2026",
  "doorsTimeLabel": "Portas 15h",
  "startTimeLabel": null,
  "venue": {
    "name": "Vila de Crato",
    "address": "Campo Primeiro de Maio 7430, 7430-115 Crato - Crato, AT",
    "gps": null,
    "directionsUrl": null
  },
  "ageRating": "Livre.",
  "promoter": "CÂMARA MUNICIPAL DO CRATO",
  "description": "No coração do Alto Alentejo, o Festival do Crato é um dos maiores eventos de verão em Portugal.\n\nDurante quatro noites inesquecíveis, os melhores artistas nacionais sobem ao palco num ambiente único de música, convívio e tradição — integrado na Feira de Artesanato e Gastronomia do Crato.",
  "priceFrom": 15,
  "ticketing": {
    "mode": "tiers",
    "ctaLabel": "Continuar compra",
    "tiers": [
      {
        "id": 501,
        "name": "PASSE - 4 DIAS",
        "description": "Acesso completo aos 4 dias do Festival do Crato 2026. A partir de 1 de agosto: 50€. Entrada gratuita para crianças até aos 11 anos, acompanhadas por um adulto.",
        "price": 45,
        "status": "esgotado",
        "maxPerOrder": 0
      },
      {
        "id": 502,
        "name": "BILHETE ÚNICO - DIA 26 DE AGOSTO",
        "description": "Acesso ao Festival do Crato — 1.º dia. A partir de 1 de agosto: 20€. Entrada gratuita para crianças até aos 11 anos, acompanhadas por um adulto.",
        "price": 15,
        "status": "disponivel",
        "maxPerOrder": 10
      },
      {
        "id": 503,
        "name": "BILHETE ÚNICO - DIA 27 DE AGOSTO",
        "description": "Acesso ao Festival do Crato — 2.º dia. A partir de 1 de agosto: 20€. Entrada gratuita para crianças até aos 11 anos, acompanhadas por um adulto.",
        "price": 15,
        "status": "limitado",
        "maxPerOrder": 10
      },
      {
        "id": 504,
        "name": "BILHETE ÚNICO - DIA 28 DE AGOSTO",
        "description": "Acesso ao Festival do Crato — 3.º dia. A partir de 1 de agosto: 25€. Entrada gratuita para crianças até aos 11 anos, acompanhadas por um adulto.",
        "price": 20,
        "status": "disponivel",
        "maxPerOrder": 10
      },
      {
        "id": 505,
        "name": "BILHETE ÚNICO - DIA 29 DE AGOSTO",
        "description": "Acesso ao Festival do Crato — dia final. A partir de 1 de agosto: 25€. Entrada gratuita para crianças até aos 11 anos, acompanhadas por um adulto.",
        "price": 20,
        "status": "disponivel",
        "maxPerOrder": 10
      }
    ]
  }
}
```

Notas:
- `ticketing.mode`: `"seatmap"` → o front mostra só o preço "a partir de" e o botão único abre o fluxo de mapa de lugares (fora deste escopo). `"tiers"` → o front lista `tiers[]` com stepper de quantidade (o total e o botão "Continuar compra" são calculados no client a partir de `tiers[].price` × quantidade selecionada).
- `status` do lote: `"disponivel"` | `"limitado"` | `"esgotado"` — motor de badge de cor no Figma (verde/amarelo/cinza). `maxPerOrder` controla até quanto o stepper permite incrementar (quando `"esgotado"`, o botão `+` fica desabilitado).
- A barra fixa inferior ("Sticky") e o card lateral "Bilhetes" não precisam de campos novos — reaproveitam `title`, `dateLabel`, `venue.name`, `priceFrom`/soma dos `tiers`.
- Botões de partilha (copiar link, SMS, X, TikTok, Facebook, Instagram, WhatsApp) não dependem de dados do banco — o front monta a partir da própria URL/título da página.

---

## 5. Mapeamento de referência com o banco atual

Para quem for escrever as queries, o shape acima mapeia aproximadamente para as tabelas já usadas em `lib/home-data.ts` / `lib/eventos-data.ts`, mais o que falta para a tela de detalhe (ainda não implementada no front):

| Campo da API              | Origem hoje (`events` / `groups` + joins)                                   |
|----------------------------|------------------------------------------------------------------------------|
| `id`, `slug`, `title`      | `events.id/slug/name` (ou `groups.id/slug/name`)                             |
| `image`                    | `events_images` (primeira imagem) / `groups.image`, servido via `BACKEND_ASSETS_URL` |
| `city`, `region`           | join `cities` / `regions` por `id_city` / `id_region`                        |
| `venue`                    | join `places` por `id_place`                                                 |
| `venue.address`, `venue.gps` | `places.location`, `places.gps`                                            |
| `dateStart`, `dateLabel`   | `events.date_start` / `date_opening`, `label_date` (formatado por `formatDate()`) |
| `doorsTimeLabel`           | `events.date_opening` formatado como hora                                    |
| `priceFrom`                | `MIN(products_lots.price)` com `hidden = 0` e sem esgotar                    |
| `ageRating`                | `events.parental_rating`                                                     |
| `description`              | `events.description`                                                         |
| `promoter`                  | join `organizers` por `events.id_organizer`                                  |
| `ticketing.tiers`          | `products_lots` (preço, nome do lote) + `products` (nome/descrição do ingresso) + `products_sales_limit` (estoque, define `status`/`maxPerOrder`) |
| `type`                      | `"event"` (tabela `events`) vs `"group"` (série/lineup — tabela `groups` + `events_groups`) |
| **categoria/gênero (chips, seções)** | **não existe hoje** — precisa de nova coluna/tabela ligada a `events` (ver Observação 1) |

---

## 6. Resumo do que falta decidir antes de implementar

- [ ] Modelagem de categoria/gênero do evento (chips + seções da tela Eventos).
- [ ] Se `location`/`priceMin`/`priceMax` filtram por cidade, região ou raio geográfico.
- [ ] De onde vem `doorsTimeLabel`/`startTimeLabel` quando `date_opening` é nulo.
- [ ] Regra de negócio do `totalEventosCount` da Home (contagem real vs. número fixo de marketing).
- [ ] Filtro `display_in_cover = '1' AND date_sales_end > NOW()` nas listagens da API (ver Observação 6). O frontend já aplica os dois do seu lado; falta só mover para a API.
