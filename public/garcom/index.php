<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <title>Chamar Garçom</title>
    <link rel="icon" type="image/svg+xml"
        href="data:image/svg+xml,
      <svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'>
        <style>
          text { font-size: 90px; }
          @media (prefers-color-scheme: dark) {
            text { fill: white; }
          }
        </style>
        <text y='0.9em'>🍽️</text>
      </svg>">

    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            transition: background .3s, color .3s;
        }

        body.dark {
            background: linear-gradient(180deg, #0f172a, #020617);
            color: #e5e7eb;
        }

        body.dark button {
            background: none;
            border: none;
            padding: 0;
            margin: 0;
            box-shadow: none;
            outline: none;
            cursor: pointer;
            appearance: none;
            -webkit-appearance: none;
            color: #FFFFFF;
        }

        body.light button {
            background: none;
            border: none;
            padding: 0;
            margin: 0;
            box-shadow: none;
            outline: none;
            cursor: pointer;
            appearance: none;
            -webkit-appearance: none;
            color: #000000;
        }

        body.light {
            background: linear-gradient(180deg, #f8fafc, #e5e7eb);
            color: #0f172a;
        }

        /* Título */
        body.dark h4 {
            color: #ffffff;
        }

        body.light h4 {
            color: #0f172a;
        }

        .card {
            border-radius: 16px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, .4);
        }

        body.dark .card {
            background-color: #020617;
            border: 1px solid #1e293b;
        }

        body.light .card {
            background-color: #ffffff;
            border: 1px solid #cbd5f5;
        }

        body.dark .alert-warning {
            --bs-alert-color: #ffffff;
            --bs-alert-bg: #8f343cbd;
            --bs-alert-border-color: #8f343cbd;
            --bs-alert-link-color: #8f343cbd;
            border-radius: 14px;
        }

        body.light .alert-warning {
            --bs-alert-color: #ffffff;
            --bs-alert-bg: #8f343cff;
            --bs-alert-border-color: #8f343cff;
            --bs-alert-link-color: #8f343cff;
            border-radius: 14px;
        }

        .mesa-badge {
            font-size: 1rem;
            padding: 6px 14px;
            border-radius: 50px;
        }

        body.dark .mesa-badge {
            background-color: #1e293b;
            color: #e5e7eb;
        }

        body.light .mesa-badge {
            background-color: #e2e8f0;
            color: #0f172a;
        }

        .btn-success {
            background: linear-gradient(135deg, #16a34a, #22c55e);
            border: none;
            border-radius: 14px;
            font-size: 1.25rem;
        }

        .btn-success:disabled {
            background: #94a3b8;
        }

        .theme-toggle {
            position: fixed;
            top: 15px;
            right: 15px;

            width: 42px;
            height: 42px;

            border-radius: 50%;
            border: none;

            display: flex;
            align-items: center;
            justify-content: center;

            font-size: 1.2rem;
            cursor: pointer;

            transition: background .3s, transform .2s;
        }

        .theme-toggle:hover {
            transform: scale(1.05);
        }

        /* Aparência por tema */
        body.dark .theme-toggle {
            background-color: #1e293b;
            color: #facc15;
            /* amarelo do sol */
        }

        body.light .theme-toggle {
            background-color: #e2e8f0;
            color: #0f172a;
        }

        .alert-success {
            border-radius: 14px;
        }
    </style>
</head>

<body class="d-flex align-items-center justify-content-center vh-100">

    <div class="container px-3">
        <div class="card mx-auto p-4 text-center position-relative" style="max-width: 380px;">

            <!-- Toggle Tema -->
            <button id="toggleTheme" class="theme-toggle">🌙</button>

            <!-- Mesa -->
            <div class="mb-3">
                <span class="mesa-badge">
                    🪑 Mesa <strong id="mesaNumero">--</strong>
                </span>
            </div>

            <h4 class="mb-4">Pedir serviço de Bar</h4>

             <div id="msg" class=""></div>

            <button id="btnChamar" class="w-100 py-3 ">
                <img src="btn.png" style="width: 50%;">
            </button>
           

            <p class="text-secondary small mt-3" id="toque-info">
                Toque no botão
            </p>
        </div>
    </div>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <script>
        /* =====================================================
   TEMA INTELIGENTE (usuário → sistema → horário)
===================================================== */
        const THEME_KEY = 'theme_preference';

        function aplicarTema(theme) {
            $('body').removeClass('dark light').addClass(theme);
            $('#toggleTheme').text(theme === 'dark' ? '☀️' : '🌙');
        }

        function temaPorHorario() {
            const h = new Date().getHours();
            return (h >= 7 && h < 19) ? 'light' : 'dark';
        }

        function temaDoSistema() {
            if (!window.matchMedia) return null;
            return window.matchMedia('(prefers-color-scheme: dark)').matches ?
                'dark' :
                'light';
        }

        function temaInicial() {
            const salvo = sessionStorage.getItem(THEME_KEY);
            if (salvo) return salvo;

            const sistema = temaDoSistema();
            if (sistema) return sistema;

            return temaPorHorario();
        }

        function setTheme(theme) {
            sessionStorage.setItem(THEME_KEY, theme);
            aplicarTema(theme);
        }

        // Aplica tema inicial
        aplicarTema(temaInicial());

        // Toggle manual
        $('#toggleTheme').on('click', function() {
            const atual = $('body').hasClass('dark') ? 'dark' : 'light';
            setTheme(atual === 'dark' ? 'light' : 'dark');
        });

        // Escuta mudança do sistema
        if (window.matchMedia) {
            window.matchMedia('(prefers-color-scheme: dark)')
                .addEventListener('change', e => {
                    if (!sessionStorage.getItem(THEME_KEY)) {
                        aplicarTema(e.matches ? 'dark' : 'light');
                    }
                });
        }

        /* =====================================================
           MESA VIA URL
        ===================================================== */
        function getMesaFromURL() {
            return new URLSearchParams(window.location.search).get('mesa');
        }

        const mesa = getMesaFromURL();
        $('#mesaNumero').text(mesa.padStart(2, '0') ?? '--');

        const btn = $('#btnChamar');
        const msg = $('#msg');
        const TEXTO_PADRAO = '<img src="btn.png" style="width: 50%;">';
        const STORAGE_KEY = `contador_mesa_${mesa}`;

        let countdownInterval = null;

        /* =====================================================
           CONTADOR REGRESSIVO (persistente)
        ===================================================== */
        function iniciarContador(segundos) {
            clearInterval(countdownInterval);

            const fim = Date.now() + segundos * 1000;
            sessionStorage.setItem(STORAGE_KEY, fim);

            atualizarUI();
            countdownInterval = setInterval(atualizarUI, 1000);
        }

        function atualizarUI() {
            $('#toque-info').show();
            const fim = sessionStorage.getItem(STORAGE_KEY);

            if (countdownInterval == null) {
                countdownInterval = setInterval(atualizarUI, 1000);
            }

            if (!fim) {
                btn.prop('disabled', false).html(TEXTO_PADRAO);
                clearInterval(countdownInterval);
                return;
            }

            const restante = Math.ceil((fim - Date.now()) / 1000);

            if (restante <= 0) {
                sessionStorage.removeItem(STORAGE_KEY);
                btn.prop('disabled', false).html(TEXTO_PADRAO);
                clearInterval(countdownInterval);
                return;
            }

            const min = Math.floor(restante / 60);
            const sec = restante % 60;

            btn.prop('disabled', true)
                .html(`⏳ Próximo pedido disponível em ${min}:${sec.toString().padStart(2, '0')}`);
            $('#toque-info').hide();
        }

        /* =====================================================
           AJAX
        ===================================================== */
        btn.on('click', function() {
            btn.prop('disabled', true);
            $.ajax({
                url: 'chamar_garcom.php',
                type: 'GET',
                dataType: 'json',
                data: {
                    mesa
                },

                success: function(data) {
                    msg.html(`
                        <div class="alert alert-${data.status === 'success' ? 'success' : 'warning'}">
                            ${data.message}
                        </div>
                    `);

                    if (data.remaining) {
                        iniciarContador(data.remaining);
                    }

                    btn.prop('disabled', true);
                },

                error: function() {
                    btn.prop('disabled', false);
                    msg.html('<div class="alert alert-danger">Erro ao chamar o garçom</div>');
                }
            });
        });

        // Recupera contador ao abrir
        $(document).ready(function() {
            atualizarUI();
            if (!mesa) {
                btn.prop('disabled', true)
                    .html(`Mesa não informada`);
            }

        });
    </script>

</body>

</html>