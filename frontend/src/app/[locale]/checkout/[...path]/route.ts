import { NextRequest } from "next/server";
import { CONSENT_COOKIE, hasMarketingConsent } from "@/lib/consent";
import { readTrackingParam, TRACKING_PARAMS, trackingCookie } from "@/lib/ref-tracking";

const CHECKOUT_ORIGIN = process.env.CHECKOUT_ORIGIN ?? "https://checkout.lebillet.eu";

const HARDCODED_ROOT_PATHS = ["/img/mapas/", "/Seats/checkSeats", "/Seats/getAllSeats"];

const STRIPPED_RESPONSE_HEADERS = new Set([
  "content-length",
  "content-encoding",
  "transfer-encoding",
  "connection",
  "set-cookie",
  "content-security-policy",
  "x-frame-options",
]);

function withoutThirdPartyTracking(html: string): string {
  return html
    .replace(/https:\/\/connect\.facebook\.net\/\w+\/fbevents\.js/g, "data:text/javascript,")
    .replace(/<noscript>\s*<img[^>]*facebook\.com\/tr[^>]*>\s*<\/noscript>/gi, "")
    .replace(/<script[^>]*translate\.google\.com\/translate_a\/element\.js[^>]*>\s*<\/script>/gi, "");
}

async function proxy(req: NextRequest, locale: string, path: string[]) {
  const proxyPrefix = `/${locale}/checkout`;
  let search = req.nextUrl.search;
  // O checkout PHP lê ref/mkt só em minúsculo e guarda-os na sessão dele; o ref vai para orders.ref.
  for (const name of TRACKING_PARAMS) {
    const value = readTrackingParam(req.nextUrl.searchParams, name) ?? req.cookies.get(trackingCookie(name))?.value;
    if (value && !req.nextUrl.searchParams.has(name)) {
      search += `${search ? "&" : "?"}${name}=${encodeURIComponent(value)}`;
    }
  }
  const upstreamUrl = `${CHECKOUT_ORIGIN}/${path.join("/")}${search}`;

  const headers = new Headers();
  const cookie = req.headers.get("cookie");
  if (cookie) headers.set("cookie", cookie);
  const contentType = req.headers.get("content-type");
  if (contentType) headers.set("content-type", contentType);
  headers.set("accept", req.headers.get("accept") ?? "*/*");
  headers.set("user-agent", req.headers.get("user-agent") ?? "Mozilla/5.0");

  const init: RequestInit = { method: req.method, headers, redirect: "manual" };
  if (req.method !== "GET" && req.method !== "HEAD") {
    init.body = await req.arrayBuffer();
  }

  const upstreamRes = await fetch(upstreamUrl, init);

  const resHeaders = new Headers();
  upstreamRes.headers.forEach((value, key) => {
    if (!STRIPPED_RESPONSE_HEADERS.has(key)) resHeaders.set(key, value);
  });
  resHeaders.set("x-robots-tag", "noindex, nofollow");

  const setCookies = upstreamRes.headers.getSetCookie?.() ?? [];
  for (const raw of setCookies) {
    resHeaders.append("set-cookie", raw.replace(/;\s*Domain=[^;]*/i, ""));
  }

  if (upstreamRes.status >= 300 && upstreamRes.status < 400) {
    const location = upstreamRes.headers.get("location");
    if (location) resHeaders.set("location", rewriteUrls(location, proxyPrefix));
    return new Response(null, { status: upstreamRes.status, headers: resHeaders });
  }

  const upstreamContentType = upstreamRes.headers.get("content-type") ?? "";
  if (upstreamContentType.includes("text/html")) {
    let html = rebrandHead(rewriteUrls(await upstreamRes.text(), proxyPrefix));
    if (!hasMarketingConsent(req.cookies.get(CONSENT_COOKIE)?.value)) html = withoutThirdPartyTracking(html);
    html = html
      .replace(/<link[^>]*rel=["'][^"']*icon[^"']*["'][^>]*>\s*/gi, "")
      .replace(
        "</head>",
        `<link rel="icon" href="/brand/favicon.png" type="image/png">
<link rel="apple-touch-icon" href="/brand/apple-icon.png">
<link rel="preload" href="/fonts/inter-v20-latin.woff2" as="font" type="font/woff2" crossorigin>
<link rel="stylesheet" href="/fonts/fonts.css">
<link rel="stylesheet" href="/checkout-theme.css">
</head>`
      );

    html = html.replace(
      /<body([^>]*)>/,
      `<body$1>
<div class="tkt-checkout-header">
  <a href="/" class="tkt-checkout-header__logo"><img src="/brand/logo.png" alt="tickett.com"></a>
  <div class="tkt-checkout-steps">
    <div class="tkt-checkout-step is-active"><span class="tkt-checkout-step__badge">1</span><span class="tkt-checkout-step__label">Bilhetes</span></div>
    <span class="tkt-checkout-step__line"></span>
    <div class="tkt-checkout-step"><span class="tkt-checkout-step__badge">2</span><span class="tkt-checkout-step__label">Os seus dados</span></div>
    <span class="tkt-checkout-step__line"></span>
    <div class="tkt-checkout-step"><span class="tkt-checkout-step__badge">3</span><span class="tkt-checkout-step__label">Pagamento</span></div>
  </div>
  <div class="tkt-checkout-header__right">
    <a href="/" class="tkt-checkout-header__close" aria-label="Fechar" onclick="if(window.self!==window.top){window.parent.postMessage('tkt-close-checkout','*');return false;}if(window.history.length>1){window.history.back();return false;}">
      <span class="tkt-checkout-header__close-bar"></span>
      <span class="tkt-checkout-header__close-bar"></span>
    </a>
  </div>
</div>
<div class="tkt-checkout-header-mobile">
  <div class="tkt-checkout-header-mobile__row">
    <button type="button" class="tkt-checkout-header__back" aria-label="Voltar" onclick="if(typeof goProducts==='function'){goProducts();}">
      <span class="tkt-checkout-header__back-icon"></span>
    </button>
    <a href="/" class="tkt-checkout-header__logo"><img src="/brand/logo.png" alt="tickett.com"></a>
    <div class="tkt-checkout-header__right">
      <a href="/" class="tkt-checkout-header__close" aria-label="Fechar" onclick="if(window.self!==window.top){window.parent.postMessage('tkt-close-checkout','*');return false;}if(window.history.length>1){window.history.back();return false;}">
        <span class="tkt-checkout-header__close-bar"></span>
        <span class="tkt-checkout-header__close-bar"></span>
      </a>
    </div>
  </div>
  <div class="tkt-checkout-header-mobile__divider"></div>
  <div class="tkt-checkout-header-mobile__row tkt-checkout-header-mobile__steps-row">
    <div class="tkt-checkout-steps-mobile">
      <div class="tkt-checkout-step is-active"><span class="tkt-checkout-step__badge">1</span><span class="tkt-checkout-step__label">Bilhetes</span></div>
      <div class="tkt-checkout-step"><span class="tkt-checkout-step__badge">2</span><span class="tkt-checkout-step__label">Os seus dados</span></div>
      <div class="tkt-checkout-step"><span class="tkt-checkout-step__badge">3</span><span class="tkt-checkout-step__label">Pagamento</span></div>
    </div>
  </div>
  <div class="tkt-checkout-header-mobile__divider"></div>
</div>
<script>
(function () {
  function setActiveStep(n) {
    document.querySelectorAll(".tkt-checkout-step").forEach(function (el, i) {
      var isActive = i % 3 === n - 1;
      el.classList.toggle("is-active", isActive);
      if (isActive && n === 1) {
        var row = document.querySelector(".tkt-checkout-header-mobile__steps-row");
        if (row) row.scrollLeft = 0;
      } else if (isActive && el.scrollIntoView) {
        el.scrollIntoView({ inline: "nearest", block: "nearest" });
      }
    });
    document.querySelectorAll(".tkt-checkout-header__back").forEach(function (el) {
      el.classList.toggle("is-visible", n > 1);
    });
  }
  function classify(url) {
    if (!url) return null;
    if (url.indexOf("/payment/") !== -1 || url.indexOf("delivery-payment") !== -1) return 3;
    if (/\\/login(\\/register)?(\\?|$)/.test(url)) return 2;
    if (/\\/products(\\?|$)/.test(url)) return 1;
    return null;
  }
  var origOpen = XMLHttpRequest.prototype.open;
  XMLHttpRequest.prototype.open = function (method, url) {
    try {
      var step = classify(url);
      if (step) setActiveStep(step);
    } catch (e) {}
    return origOpen.apply(this, arguments);
  };

  // O formulário do passo 2 "traduz" cada país e cada concelho com um fetch ao
  // translate.googleapis.com, de pt para pt_pt (o destino é forçado): 367 pedidos a
  // cada abertura do passo, todos recusados por CORS, com o País desativado até
  // acabarem — e cada um leva o IP do visitante ao Google sem consentimento. Quando a
  // tradução falha o upstream fica com o texto original; aqui responde-se logo com
  // ele, sem sair para a rede.
  var origFetch = window.fetch;
  if (origFetch && window.Response) {
    window.fetch = function (input) {
      var url = typeof input === "string" ? input : input && input.url;
      if (url && url.indexOf("translate.googleapis.com/translate_a/single") !== -1) {
        var text = "";
        try {
          text = new URL(url).searchParams.get("q") || "";
        } catch (e) {}
        return Promise.resolve(
          new Response(JSON.stringify([[[text]]]), { status: 200, headers: { "content-type": "application/json" } })
        );
      }
      return origFetch.apply(this, arguments);
    };
  }

  document.addEventListener("click", function (e) {
    var formCheck = e.target.closest(".form-check");
    if (!formCheck) return;
    var input = formCheck.querySelector('input[type="radio"], input[type="checkbox"]');
    if (!input || input.disabled || e.target === input) return;
    var label = formCheck.querySelector("label[for]");
    var forId = label ? label.getAttribute("for") : null;
    if (forId && document.getElementById(forId) === input) return;
    if (input.type === "checkbox") {
      input.checked = !input.checked;
    } else if (!input.checked) {
      input.checked = true;
    } else {
      return;
    }
    input.dispatchEvent(new Event("click", { bubbles: true }));
    input.dispatchEvent(new Event("change", { bubbles: true }));
  });

  function restyleTicketRows() {
    document.querySelectorAll("tr.table-tr-no-hover").forEach(function (nameRow) {
      var h6 = nameRow.querySelector("h6");
      var nameTd = nameRow.querySelector("td.td-product-name");
      if (!h6 || !nameTd || h6.querySelector(".tkt-inline-price, .tkt-lote-badge")) return;

      var infoRows = [];
      for (var sib = nameRow.nextElementSibling; sib && sib.classList.contains("tr-products"); sib = sib.nextElementSibling) {
        infoRows.push(sib);
      }
      if (!infoRows.length) return;

      var bulletsSmall = h6.querySelector("small");

      infoRows.forEach(function (infoRow) {
        var qtySelect = infoRow.querySelector("select.quantity-select");
        if (!qtySelect) {
          var soldLoteCell = infoRow.querySelector("td.td-product-name");
          var soldStatusCell = infoRow.querySelector("td:last-child");
          if (soldLoteCell && soldLoteCell.textContent.trim()) {
            var soldWrap = document.createElement("div");
            soldWrap.className = "tkt-soldout-lote";

            var soldBadge = document.createElement("span");
            soldBadge.className = "tkt-lote-badge tkt-lote-badge--soldout";
            while (soldLoteCell.firstChild) soldBadge.appendChild(soldLoteCell.firstChild);
            soldWrap.appendChild(soldBadge);

            if (soldStatusCell && soldStatusCell !== soldLoteCell && soldStatusCell.textContent.trim()) {
              var statusEl = document.createElement("span");
              statusEl.className = "tkt-soldout-status";
              while (soldStatusCell.firstChild) statusEl.appendChild(soldStatusCell.firstChild);
              soldWrap.appendChild(statusEl);
            }

            h6.insertBefore(soldWrap, bulletsSmall || null);
          }
          infoRow.style.display = "none";
          return;
        }

        var qtyTd = qtySelect.closest("td");
        var priceCell = qtyTd ? qtyTd.previousElementSibling : null;
        var loteCell = infoRow.querySelector("td.td-product-name");

        if (priceCell && priceCell.textContent.trim()) {
          var priceEl = document.createElement("span");
          priceEl.className = "tkt-inline-price";
          while (priceCell.firstChild) priceEl.appendChild(priceCell.firstChild);
          h6.insertBefore(priceEl, h6.firstChild);
        }

        if (loteCell && loteCell.textContent.trim()) {
          var loteEl = document.createElement("div");
          loteEl.className = "tkt-lote-badge";
          while (loteCell.firstChild) loteEl.appendChild(loteCell.firstChild);
          h6.insertBefore(loteEl, bulletsSmall || null);
        }

        if (qtyTd) {
          var footer = document.createElement("div");
          footer.className = "tkt-card-footer";
          while (qtyTd.firstChild) footer.appendChild(qtyTd.firstChild);
          nameTd.appendChild(footer);
        }

        infoRow.style.display = "none";
      });
    });
  }
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", restyleTicketRows);
  } else {
    restyleTicketRows();
  }

  window.__tktRestyleTicketRows = restyleTicketRows;
})();

(function () {
  function syncCartTotal() {
    var title = document.querySelector(".cart-resume-title");
    if (!title) return;

    var row = document.querySelector(".cart-sidebar tr.total-all");
    var cells = row ? row.querySelectorAll("td") : null;
    var value = cells && cells.length > 1 ? cells[cells.length - 1].textContent.trim() : "";
    if (!value) return;

    var mirror = title.querySelector(".tkt-cart-total");
    if (!mirror) {
      mirror = document.createElement("div");
      mirror.className = "tkt-cart-total";
      mirror.innerHTML =
        '<span class="tkt-cart-total__label"></span><span class="tkt-cart-total__value"></span>';
      mirror.querySelector(".tkt-cart-total__label").textContent =
        (cells[0] && cells[0].textContent.trim()) || "Total";
      title.insertBefore(mirror, title.querySelector(".tkt-cart-timer"));
    }
    var out = mirror.querySelector(".tkt-cart-total__value");
    if (out.textContent !== value) out.textContent = value;
  }

  // O cronómetro da reserva (arranca depois do registo/login, no passo 3) vive no
  // corpo da gaveta, que recolhida não se vê: o tempo acabava sem aviso e o
  // upstream fazia logout a meio do pagamento. Espelhado no cabeçalho como o total.
  function syncCartTimer() {
    var title = document.querySelector(".cart-resume-title");
    if (!title) return;

    var row = document.querySelector(".cart-sidebar tr.cronometro");
    var clock = document.getElementById("timeCron");
    var value = row && clock && !row.classList.contains("d-none") ? clock.textContent.trim() : "";
    var mirror = title.querySelector(".tkt-cart-timer");

    if (!value) {
      if (mirror) mirror.remove();
      return;
    }
    if (!mirror) {
      mirror = document.createElement("div");
      mirror.className = "tkt-cart-timer";
      mirror.innerHTML =
        '<span class="tkt-cart-timer__label"></span><span class="tkt-cart-timer__value"></span>';
      var label = row.querySelector("td");
      mirror.querySelector(".tkt-cart-timer__label").textContent = label ? label.textContent.trim() : "";
      title.appendChild(mirror);
    }
    var out = mirror.querySelector(".tkt-cart-timer__value");
    if (out.textContent !== value) out.textContent = value;
  }

  // A seta que abre e fecha a gaveta é um <button> só com um SVG: sem nome nem
  // estado para leitores de ecrã. O nome vem do título ao lado, que já está
  // traduzido pelo upstream.
  function labelDrawerToggle() {
    var btn = document.getElementById("button-cart-sider");
    var drawer = document.querySelector(".cart-sidebar");
    if (!btn || !drawer) return;

    var heading = document.querySelector(".cart-resume-title h2");
    if (heading) {
      if (!heading.id) heading.id = "tkt-cart-heading";
      if (btn.getAttribute("aria-labelledby") !== heading.id) btn.setAttribute("aria-labelledby", heading.id);
    }
    var open = drawer.classList.contains("open") || drawer.classList.contains("openAuto");
    if (btn.getAttribute("aria-expanded") !== String(open)) btn.setAttribute("aria-expanded", String(open));
  }

  var ERROR_FIELDS = [
    { re: /nome completo/i, fields: ["name", "name_apelido"] },
    { re: /email v[aá]lido/i, fields: ["email"] },
    { re: /email de confirma/i, fields: ["email_confirm", "email"] },
    { re: /n[uú]mero de telefone/i, fields: ["cell_number"] },
    { re: /telem[oó]vel de confirma/i, fields: ["cell_number_confirm"] },
  ];

  function clearFieldErrors() {
    document.querySelectorAll(".tkt-invalid").forEach(function (el) {
      el.classList.remove("tkt-invalid");
      el.removeAttribute("aria-invalid");
      el.removeAttribute("aria-describedby");
    });
    document.querySelectorAll(".tkt-invalid-group").forEach(function (el) {
      el.classList.remove("tkt-invalid-group");
    });
    document.querySelectorAll(".tkt-field-error").forEach(function (el) {
      el.remove();
    });
  }

  function markField(input, message, index) {
    input.classList.add("tkt-invalid");
    input.setAttribute("aria-invalid", "true");

    var group = input.closest(".input-group");
    if (group) group.classList.add("tkt-invalid-group");

    var id = "tkt-err-" + index;
    var note = document.createElement("span");
    note.className = "tkt-field-error";
    note.id = id;
    note.setAttribute("role", "alert");
    note.textContent = message;
    (group || input).insertAdjacentElement("afterend", note);
    input.setAttribute("aria-describedby", id);

    var reset = function () {
      input.classList.remove("tkt-invalid");
      input.removeAttribute("aria-invalid");
      input.removeAttribute("aria-describedby");
      if (group) group.classList.remove("tkt-invalid-group");
      var n = document.getElementById(id);
      if (n) n.remove();
      input.removeEventListener("input", reset);
      input.removeEventListener("change", reset);
    };
    input.addEventListener("input", reset);
    input.addEventListener("change", reset);
  }

  function headerOffset() {
    var h = document.querySelector(".tkt-checkout-header-mobile");
    if (!h || !h.offsetParent) h = document.querySelector(".tkt-checkout-header");
    var r = h ? h.getBoundingClientRect() : null;
    return r && r.height ? r.height + 16 : 16;
  }

  function drawerTop() {
    var drawer = document.querySelector(".cart-sidebar");
    if (!drawer || getComputedStyle(drawer).position !== "fixed") return window.innerHeight;
    return drawer.getBoundingClientRect().top;
  }

  function scrollParent(el) {
    for (var p = el.parentElement; p; p = p.parentElement) {
      var oy = getComputedStyle(p).overflowY;
      if ((oy === "auto" || oy === "scroll") && p.scrollHeight > p.clientHeight + 1) return p;
    }
    return null;
  }

  function scrollToWithOffset(el) {
    var top = headerOffset();
    var bottom = drawerTop() - 16;
    var r = el.getBoundingClientRect();
    var delta = 0;

    if (r.bottom > bottom) {
      delta = r.bottom - bottom;
      if (r.height > bottom - top) delta = r.top - top;
    } else if (r.top < top) {
      delta = r.top - top;
    }
    if (!delta) return;

    var sp = scrollParent(el);
    if (sp) sp.scrollTo({ top: Math.max(0, sp.scrollTop + delta), behavior: "smooth" });
    else window.scrollTo({ top: Math.max(0, window.pageYOffset + delta), behavior: "smooth" });
  }

  function handleRegisterError(message) {
    clearFieldErrors();
    if (!message) return;

    var form = document.getElementById("tickets-form-register");
    if (!form) return;

    var targets = [];
    ERROR_FIELDS.forEach(function (rule) {
      if (!rule.re.test(message)) return;
      rule.fields.forEach(function (name) {
        var el = form.querySelector('[name="' + name + '"]');
        if (el && targets.indexOf(el) === -1) targets.push(el);
      });
    });

    if (!targets.length) {
      var box = document.getElementById("div-msg-register");
      if (box) scrollToWithOffset(box);
      return;
    }

    if (targets.length > 1) {
      var empty = targets.filter(function (el) {
        return !String(el.value || "").trim();
      });
      targets = empty.length ? empty : [targets[0]];
    }

    targets.forEach(function (el, i) {
      markField(el, message, i);
    });

    var first = targets[0];
    setTimeout(function () {
      scrollToWithOffset(first);
      try {
        first.focus({ preventScroll: true });
      } catch (e) {
        first.focus();
      }
    }, 120);
  }

  function watchRegisterErrors() {
    var box = document.getElementById("div-msg-register");
    if (!box || box.dataset.tktWatched) return;
    box.dataset.tktWatched = "1";
    new MutationObserver(function () {
      var alert = box.querySelector(".alert-danger");
      handleRegisterError(alert ? alert.textContent.trim() : "");
    }).observe(box, { childList: true, subtree: true });
  }

  var drawerWatch = { node: null, obs: null };

  function reserveDrawerSpace() {
    var drawer = document.querySelector(".cart-sidebar");
    if (!drawer || getComputedStyle(drawer).position !== "fixed") {
      document.documentElement.style.removeProperty("--tkt-drawer-h");
      return;
    }
    var h = Math.ceil(drawer.getBoundingClientRect().height);
    document.documentElement.style.setProperty("--tkt-drawer-h", h + "px");

    // Abrir e fechar a gaveta só troca classes e anima a altura, e nada disso é uma
    // mudança de nós: o MutationObserver do body não voltava a medir e a reserva
    // ficava com a altura do estado anterior (488px de vazio por baixo do conteúdo
    // depois de fechar a gaveta que abriu sozinha).
    if (drawerWatch.node !== drawer && window.ResizeObserver) {
      if (drawerWatch.obs) drawerWatch.obs.disconnect();
      drawerWatch.node = drawer;
      drawerWatch.obs = new ResizeObserver(function () {
        reserveDrawerSpace();
        labelDrawerToggle();
      });
      drawerWatch.obs.observe(drawer);
    }
  }

  // O formulário do passo 2 traz inline "height: 90vh; overflow: auto !important;
  // scrollbar-width: none", pensado para a coluna do desktop. No telemóvel era uma
  // caixa com scroll próprio e sem barra dentro de uma página que já scrolla: a
  // 375x812, País e Distrito ficavam 149px abaixo do fundo dela e só apareciam a
  // deslizar por cima do formulário — de resto a página chegava ao fim sem eles.
  // Um !important inline não se vence por CSS, daí ser aqui. O estilo original fica
  // guardado para voltar se a janela passar para desktop.
  var MOBILE = window.matchMedia("(max-width: 900px)");

  function unboxRegisterForm() {
    var form = document.getElementById("tickets-form-register");
    if (!form) return;
    var saved = form.getAttribute("data-tkt-style");

    if (MOBILE.matches && saved === null) {
      form.setAttribute("data-tkt-style", form.getAttribute("style") || "");
      form.style.setProperty("overflow", "visible", "important");
      form.style.setProperty("height", "auto", "important");
      form.style.setProperty("margin-bottom", "0px", "important");
    } else if (!MOBILE.matches && saved !== null) {
      form.setAttribute("style", saved);
      form.removeAttribute("data-tkt-style");
    }
  }

  // No modelo table.ticket-box (ex.: evento 2089), que o restyleTicketRows não
  // converte, o -/select/+ vem solto na célula do preço: com um lote de nome comprido
  // a célula estreitava e o "+" caía sozinho para a linha de baixo. Agrupado, o preço
  // pode descer mas os três controlos ficam juntos.
  function groupTicketBoxSteppers() {
    [].forEach.call(document.querySelectorAll(".ticket-box select.quantity-select"), function (sel) {
      var cell = sel.parentElement;
      if (!cell || cell.classList.contains("tkt-qty")) return;
      var minus = sel.previousElementSibling;
      var plus = sel.nextElementSibling;
      if (!minus || !plus) return;
      if (!minus.classList.contains("button-select-product") || !plus.classList.contains("button-select-product")) return;

      var wrap = document.createElement("span");
      wrap.className = "tkt-qty";
      cell.insertBefore(wrap, minus);
      wrap.appendChild(minus);
      wrap.appendChild(sel);
      wrap.appendChild(plus);
    });
  }

  // Os selects de quantidade não têm label e o nameUnlabelledFields dava-lhes o texto
  // à volta: um leitor de ecrã ouvia "- 0" ou o preço, sem saber de que bilhete era.
  // O nome vem do título do cartão, sem o preço e o lote que o restyleTicketRows lá põe.
  function labelQuantitySelects() {
    [].forEach.call(document.querySelectorAll("select.quantity-select:not([data-tkt-labelled])"), function (sel) {
      var box = sel.closest(".ticket-box") || sel.closest("tr");
      var heading = box ? box.querySelector("h5, h6") : null;
      var name = "";
      if (heading) {
        var copy = heading.cloneNode(true);
        [].forEach.call(copy.querySelectorAll(".tkt-inline-price, .tkt-lote-badge, .tkt-soldout-lote, small"), function (n) {
          n.remove();
        });
        name = copy.textContent.replace(/\\s+/g, " ").trim();
      }
      sel.setAttribute("aria-label", name ? "Quantidade, " + name : "Quantidade");
      sel.setAttribute("data-tkt-labelled", "1");
    });
  }

  var MAP_MIN_H = 240;
  var lastMapH = null;

  function fitMapHeight() {
    var cont = document.querySelector(".map-container");
    var root = document.documentElement;
    if (!cont || window.innerWidth > 900) {
      root.style.removeProperty("--tkt-map-h");
      lastMapH = null;
      return;
    }
    var svg = cont.querySelector("svg");
    var vb = svg && svg.getAttribute("viewBox");
    var parts = vb ? vb.split(/[ ,]+/).map(Number) : null;
    if (!parts || parts.length !== 4 || !(parts[2] > 0) || !(parts[3] > 0)) return;

    var width = cont.clientWidth;
    if (!width) return;

    var ideal = Math.round(width * (parts[3] / parts[2]));
    var max = Math.round(window.innerHeight * 0.6);
    var h = Math.max(MAP_MIN_H, Math.min(ideal, max));
    if (h === lastMapH) return;
    lastMapH = h;
    root.style.setProperty("--tkt-map-h", h + "px");

    window.dispatchEvent(new Event("resize"));
  }

  function labelFrom(input) {
    var wrap = input.closest(".form-check") || input.parentElement;
    if (!wrap) return "";
    var alts = [].slice
      .call(wrap.querySelectorAll("img[alt]"))
      .map(function (img) {
        return img.getAttribute("alt").trim();
      })
      .filter(Boolean);
    if (alts.length) return alts.join(", ");
    var text = (wrap.textContent || "").replace(/\s+/g, " ").trim();
    return text.slice(0, 80);
  }

  var PAYMENT_NAMES = {
    "mb_way.png": "MB WAY",
    "mb_multibanco.png": "Multibanco",
    "groupcard.png": "Cartao de credito ou debito",
  };

  function labelPaymentImages() {
    [].forEach.call(document.querySelectorAll(".div-tipos img:not([alt])"), function (img) {
      var file = (img.getAttribute("src") || "").split("/").pop();
      var name = PAYMENT_NAMES[file];
      if (name) img.setAttribute("alt", name);
    });
  }

  var uid = 0;

  function repairFormIds() {
    var seen = {};
    [].forEach.call(document.querySelectorAll(".form-check"), function (wrap) {
      var input = wrap.querySelector("input[type=radio], input[type=checkbox]");
      var label = wrap.querySelector("label");
      if (!input) return;

      var id = input.id;
      if (!id || seen[id]) {
        id = "tkt-field-" + ++uid;
        input.id = id;
      }
      seen[id] = true;

      if (label) {
        var current = label.getAttribute("for");
        if (!current || current !== id) {
          var target = current ? document.getElementById(current) : null;
          if (!target || !wrap.contains(target)) label.setAttribute("for", id);
        }
      }
    });
  }

  var DEDUPE_IDS = ["contentseats", "selectWhatsapp", "inputWhatsapp", "whatsHelp"];

  function dedupeKnownIds() {
    DEDUPE_IDS.forEach(function (id) {
      var nodes = document.querySelectorAll('[id="' + id + '"]');
      for (var i = 1; i < nodes.length; i++) {
        var node = nodes[i];
        var fresh = "tkt-dup-" + id + "-" + i;
        node.id = fresh;

        var scope = node.closest(".div-delivery");
        if (!scope) continue;
        [].forEach.call(scope.querySelectorAll('label[for="' + id + '"]'), function (l) {
          l.setAttribute("for", fresh);
        });
        ["aria-describedby", "aria-labelledby"].forEach(function (attr) {
          [].forEach.call(scope.querySelectorAll("[" + attr + "]"), function (el) {
            var tokens = (el.getAttribute(attr) || "").split(/\\s+/);
            var at = tokens.indexOf(id);
            if (at !== -1) {
              tokens[at] = fresh;
              el.setAttribute(attr, tokens.join(" "));
            }
          });
        });
      }
    });
  }

  function syncDeliveryFields() {
    var form = document.getElementById("tickets-form-delivery-payment");
    var select = document.getElementById("delivery-method");
    if (!form || !select) return;

    [].forEach.call(form.querySelectorAll("[data-tkt-off]"), function (el) {
      el.disabled = false;
      el.removeAttribute("data-tkt-off");
    });

    var opt = select.options[select.selectedIndex];
    var id = opt ? opt.getAttribute("data-delivery_id") : null;
    var active = id ? document.getElementById("delivery_" + id) : null;
    if (!active) return;

    var FIELDS = "input[name], select[name], textarea[name]";
    var keep = {};
    [].forEach.call(active.querySelectorAll(FIELDS), function (el) {
      keep[el.name] = true;
    });

    [].forEach.call(form.querySelectorAll(".div-delivery"), function (panel) {
      if (panel === active) return;
      [].forEach.call(panel.querySelectorAll(FIELDS), function (el) {
        if (keep[el.name] && !el.disabled) {
          el.disabled = true;
          el.setAttribute("data-tkt-off", "1");
        }
      });
    });
  }

  document.addEventListener(
    "change",
    function (e) {
      if (e.target && e.target.id === "delivery-method") syncDeliveryFields();
    },
    true
  );

  function nameUnlabelledFields() {
    var fields = document.querySelectorAll(
      "input:not([type=hidden]):not([aria-label]):not([aria-labelledby])," +
        "select:not([aria-label]):not([aria-labelledby])," +
        "textarea:not([aria-label]):not([aria-labelledby])"
    );
    [].forEach.call(fields, function (el) {
      if (el.id && document.querySelector('label[for="' + CSS.escape(el.id) + '"]')) return;
      if (el.closest("label")) return;
      var name = el.getAttribute("placeholder") || labelFrom(el);
      if (name) el.setAttribute("aria-label", name);
    });
  }

  var btnMemo = { node: null, onclick: null, step: 0, obs: null };

  function currentStep() {
    var all = document.querySelectorAll(".tkt-checkout-step");
    for (var i = 0; i < all.length; i++) {
      if (all[i].classList.contains("is-active")) return (i % 3) + 1;
    }
    return 0;
  }

  function rememberButton() {
    if (!btnMemo.node) return;
    btnMemo.onclick = btnMemo.node.getAttribute("onclick");
    btnMemo.step = currentStep();
  }

  function keepContinueStep() {
    var btn = document.getElementById("button-products");
    if (!btn || btn === btnMemo.node) return;

    var replaced = !!btnMemo.node;
    var was = btnMemo.onclick;
    var wasStep = btnMemo.step;

    if (replaced && was && wasStep && currentStep() === wasStep && btn.getAttribute("onclick") !== was) {
      btn.setAttribute("onclick", was);
    }

    if (btnMemo.obs) btnMemo.obs.disconnect();
    btnMemo.node = btn;
    btnMemo.obs = new MutationObserver(rememberButton);
    btnMemo.obs.observe(btn, { attributes: true, attributeFilter: ["onclick"] });
    rememberButton();
  }

  function wireUp() {
    try {
      keepContinueStep();
      if (typeof window.__tktRestyleTicketRows === "function") window.__tktRestyleTicketRows();
      groupTicketBoxSteppers();
      labelQuantitySelects();
      syncCartTotal();
      syncCartTimer();
      labelDrawerToggle();
      reserveDrawerSpace();
      unboxRegisterForm();
      fitMapHeight();
      labelPaymentImages();
      repairFormIds();
      dedupeKnownIds();
      syncDeliveryFields();
      nameUnlabelledFields();
      watchRegisterErrors();
    } catch (e) {
      if (window.console) console.warn("[tkt] wireUp falhou:", e);
    }
    window.__tktWired = (window.__tktWired || 0) + 1;
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", wireUp);
  } else {
    wireUp();
  }

  var scheduled = false;
  new MutationObserver(function () {
    if (scheduled) return;
    scheduled = true;
    setTimeout(function () {
      scheduled = false;
      wireUp();
    }, 0);
  }).observe(document.body, { childList: true, subtree: true });

  window.addEventListener("orientationchange", wireUp);
  window.addEventListener("resize", function () {
    if (scheduled) return;
    scheduled = true;
    setTimeout(function () {
      scheduled = false;
      wireUp();
    }, 150);
  });
})();
</script>`
    );
    resHeaders.set("content-type", upstreamContentType);
    return new Response(html, { status: upstreamRes.status, headers: resHeaders });
  }

  if (upstreamContentType.includes("javascript")) {
    let js = rewriteUrls(await upstreamRes.text(), proxyPrefix);

    if (path.at(-1) === "checkout.js") {
      js = js.replace(
        "window.self.frameElement.getAttribute('id')",
        "(window.self.frameElement && window.self.frameElement.getAttribute('id'))"
      );
    }

    if (path.at(-1) === "novomapa.js") {
      js = js
        .split("`/${this.eventId}/seats/add`")
        .join("`" + proxyPrefix + "/${this.eventId}/seats/add`")
        .split("`/${this.eventId}/seats/add?reservation=`")
        .join("`" + proxyPrefix + "/${this.eventId}/seats/add?reservation=`")
        .split("this.tooltipFixed = true;")
        .join("this.tooltipFixed = false;");
    }

    resHeaders.set("content-type", upstreamContentType);
    return new Response(js, { status: upstreamRes.status, headers: resHeaders });
  }

  return new Response(await upstreamRes.arrayBuffer(), { status: upstreamRes.status, headers: resHeaders });
}

function rebrandHead(html: string): string {
  const end = html.search(/<\/head>/i);
  if (end < 0) return html;
  const head = html
    .slice(0, end)
    .replace(/lebillet\.pt/gi, "Tickett.com")
    .replace(/Checkout(\s+Checkout)+/g, "Checkout")
    .replace(/(<title>[^<]*?)\s{2,}/g, "$1 ")
    .replace(/(property=["']og:site_name["']\s+content=["'])LeBillet(["'])/i, "$1Tickett.com$2");
  return head + html.slice(end);
}

function rewriteUrls(text: string, proxyPrefix: string): string {
  const host = new URL(CHECKOUT_ORIGIN).host;
  let out = text
    .split(`https://${host}`).join(proxyPrefix)
    .split(`//${host}`).join(proxyPrefix)
    .replace(/((?:href|src|action)=["'])\/(?!\/)(?!checkout\/|[a-z]{2}-?[A-Z]{0,2}\/checkout\/)/g, `$1${proxyPrefix}/`);
  for (const p of HARDCODED_ROOT_PATHS) {
    out = out.split(`'${p}`).join(`'${proxyPrefix}${p}`).split(`"${p}`).join(`"${proxyPrefix}${p}`);
  }
  return out;
}

type Ctx = { params: Promise<{ locale: string; path: string[] }> };

export async function GET(req: NextRequest, ctx: Ctx) {
  const { locale, path } = await ctx.params;
  return proxy(req, locale, path);
}
export async function POST(req: NextRequest, ctx: Ctx) {
  const { locale, path } = await ctx.params;
  return proxy(req, locale, path);
}
export async function HEAD(req: NextRequest, ctx: Ctx) {
  const { locale, path } = await ctx.params;
  return proxy(req, locale, path);
}
