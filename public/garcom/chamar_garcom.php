<?php

require __DIR__ . '/vendor/autoload.php';

use Twilio\Rest\Client;

// ===============================
// CONFIGURAÇÕES
// ===============================
$tempoBloqueio = 5 * 60; // 3 minutos

$accountSid = 'ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
$authToken  = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';

$twilio = new Client($accountSid, $authToken);

// ===============================
// ARRAY MESAS -> GARÇOM
// ===============================
$mesas = require __DIR__ . '/mesas.php';

// ===============================
// RECEBE MESA
// ===============================
$mesaNumero = $_GET['mesa'] ?? null;

if (!$mesaNumero) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Mesa não informada'
    ]);
    exit;
}

// ===============================
// BLOQUEIO DE SPAM
// ===============================
$agora = time();

if (isset($_SESSION['ultima_chamada'][$mesaNumero])) {
    $ultima = $_SESSION['ultima_chamada'][$mesaNumero];

    if (($agora - $ultima) < $tempoBloqueio) {
        $restante = ceil(($tempoBloqueio - ($agora - $ultima)) / 60);

        echo json_encode([
            'status' => 'blocked',
            'remaining' => $restante,
            'message' => 'Aguarde para chamar novamente'
        ]);
        exit;
    }
}

// ===============================
// BUSCA GARÇOM
// ===============================
$telefoneGarcom = null;

foreach ($mesas as $mesa) {
    if ($mesa['mesa'] == $mesaNumero) {
        $telefoneGarcom = $mesa['garcom'];
        break;
    }
}

if (!$telefoneGarcom) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Pedido não efectuado.'
    ]);
    exit;
}

// salva horário da chamada
$_SESSION['ultima_chamada'][$mesaNumero] = $agora;

// ===============================
// ENVIA WHATSAPP
// ===============================

if (is_array($telefoneGarcom)) {
    $message = null;
    foreach ($telefoneGarcom as $telefone) {
        try {

            $contentVariables = json_encode([
                "1" => "" . str_pad($mesaNumero, 2, '0', STR_PAD_LEFT)
            ]);

            $message = $twilio->messages->create(
                "whatsapp:" . $telefone, // to
                [
                    "from" => "whatsapp:+19897122639", // from
                    "contentVariables" => $contentVariables,
                    "contentSid" => 'HX50fda145225e15054d060708bd1204bb'
                ]
            );

            usleep(500000); // 0.5 segundos
        } catch (Exception $e) {
            echo '<pre>';
            var_dump($e);
            die;
            echo json_encode([
                'status' => 'error',
                'remaining' => $tempoBloqueio,
                'message' => 'Pedido não efectuado.'
            ]);
        }
    }

    // ✅ VALIDAÇÃO REAL
    if (!empty($message->sid) && $message->status == 'sent' || $message->status == 'queued' || $message->status == 'delivered') {
        echo json_encode([
            'status' => 'success',
            'remaining' => $tempoBloqueio,
            'message' => 'Pedido efectuado!',
        ]);
        exit;
    }

    // Fallback improvável
    echo json_encode([
        'status' => 'error',
        'remaining' => $tempoBloqueio,
        'message' => 'Pedido não efectuado.'
    ]);
} else {
    try {

        $contentVariables = json_encode([
            "1" => "" . str_pad($mesaNumero, 2, '0', STR_PAD_LEFT)
        ]);

        $message = $twilio->messages->create(
            "whatsapp:" . $telefoneGarcom, // to
            [
                "from" => "whatsapp:+19897122639", // from
                "contentVariables" => $contentVariables,
                "contentSid" => 'HX50fda145225e15054d060708bd1204bb'
            ]
        );


        // ✅ VALIDAÇÃO REAL
        if (!empty($message->sid) && $message->status == 'sent' || $message->status == 'queued' || $message->status == 'delivered') {
            echo json_encode([
                'status' => 'success',
                'remaining' => $tempoBloqueio,
                'message' => 'Pedido efectuado!',
            ]);
            exit;
        }

        // Fallback improvável
        echo json_encode([
            'status' => 'error',
            'remaining' => $tempoBloqueio,
            'message' => 'Pedido não efectuado.'
        ]);
    } catch (Exception $e) {
        echo '<pre>';
        var_dump($e);
        die;
        echo json_encode([
            'status' => 'error',
            'remaining' => $tempoBloqueio,
            'message' => 'Pedido não efectuado.'
        ]);
    }
}
