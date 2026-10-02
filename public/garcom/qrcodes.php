<?php
$mesas = require __DIR__ . '/mesas.php';

$baseUrl = (isset($_SERVER['HTTPS']) ? 'https' : 'http') . '://' . $_SERVER['HTTP_HOST'] . dirname($_SERVER['PHP_SELF']);
?>
<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <title>QR Codes das Mesas</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🔲</text></svg>">


    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <!-- QRCode -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>

    <!-- JSZip -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js"></script>

    <style>
        body {
            min-height: 100vh;
            padding: 30px 10px;
            transition: background .3s, color .3s;
        }

        body.dark {
            background: linear-gradient(180deg, #0f172a, #020617);
            color: #e5e7eb;
        }

        body.light {
            background: linear-gradient(180deg, #f8fafc, #e5e7eb);
            color: #0f172a;
        }

        .card {
            border-radius: 20px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, .25);
            border: none;
            position: relative;
        }

        body.dark .card {
            background: #020617;
            border: 1px solid #1e293b;
        }

        body.light .card {
            background: #ffffff;
            border: 1px solid #cbd5f5;
        }

        .mesa-title {
            font-weight: 600;
            margin-bottom: 10px;
        }

        .qr-box {
            background: #fff;
            padding: 10px;
            border-radius: 12px;
            display: inline-block;
        }

        .btn-download {
            margin-bottom: 25px;
        }

        .theme-toggle {
            position: absolute;
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
        }

        body.dark .theme-toggle {
            background: #1e293b;
            color: #facc15;
        }

        body.light .theme-toggle {
            background: #e2e8f0;
            color: #0f172a;
        }

        /* Título da mesa */
        .mesa-title {
            font-weight: 600;
            margin-bottom: 10px;
        }

        /* Dark mode */
        body.dark .mesa-title {
            color: #ffffff;
        }

        /* Light mode */
        body.light .mesa-title {
            color: #000000;
        }

        .qr-box {
            background: #ffffff;
            padding: 10px;
            border-radius: 12px;
            width: 100%;
        }

        .qr-box canvas,
        .qr-box img {
            width: 100% !important;
            height: auto !important;
            display: block;
        }
    </style>
</head>

<body>

    <button id="toggleTheme" class="theme-toggle">🌙</button>

    <div class="container">
        <div class="text-center mb-4">
            <h3>QR Codes das Mesas</h3>
            <button id="downloadAll" class="btn btn-primary btn-download">
                Baixar todos os QR Codes
            </button>
        </div>

        <div class="row g-4">
            <?php foreach ($mesas as $m): ?>
                <div class="col-6 col-md-4 col-lg-3 text-center">
                    <div class="card p-3">
                        <div class="mesa-title">Mesa <?= str_pad($m['mesa'], 2, '0', STR_PAD_LEFT) ?></div>
                        <div class="qr-box">
                            <div
                                class="qrcode"
                                data-mesa="<?= $m['mesa'] ?>"
                                data-url="<?= $baseUrl ?>?mesa=<?= $m['mesa'] ?>">
                            </div>
                        </div>
                        <a class="mt-3 btn btn-sm btn-primary" href="<?= $baseUrl ?>?mesa=<?= $m['mesa'] ?>">Abrir Mesa </a>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>
    </div>

    <script>
        /* =============================
   TEMA INTELIGENTE
============================= */
        const THEME_KEY = 'theme_preference';

        function aplicarTema(theme) {
            $('body').removeClass('dark light').addClass(theme);
            $('#toggleTheme').text(theme === 'dark' ? '☀️' : '🌙');
        }

        const temaInicial =
            sessionStorage.getItem(THEME_KEY) ||
            (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');

        aplicarTema(temaInicial);

        $('#toggleTheme').on('click', function() {
            const atual = $('body').hasClass('dark') ? 'dark' : 'light';
            const novo = atual === 'dark' ? 'light' : 'dark';
            sessionStorage.setItem(THEME_KEY, novo);
            aplicarTema(novo);
        });

        /* =============================
           GERAR QRCODES
        ============================= */
        $('.qrcode').each(function() {
            const url = $(this).data('url');

            new QRCode(this, {
                text: url,
                width: 160,
                height: 160,
                correctLevel: QRCode.CorrectLevel.H
            });
        });

        /* =============================
           DOWNLOAD TODOS
        ============================= */
        $('#downloadAll').on('click', function() {
            const zip = new JSZip();

            $('.qrcode').each(function() {
                const mesa = $(this).data('mesa');
                const canvas = $(this).find('canvas')[0];
                const imgData = canvas.toDataURL('image/png').split(',')[1];

                zip.file(`mesa_${String(mesa).padStart(2, '0')}.png`, imgData, {
                    base64: true
                });
            });

            zip.generateAsync({
                type: 'blob'
            }).then(function(content) {
                saveAs(content, 'qrcodes_mesas.zip');
            });
        });
    </script>

</body>

</html>