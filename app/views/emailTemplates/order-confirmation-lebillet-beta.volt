<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
		<title>{{ config.company.msg_email_order_confirmation }}</title>
        <style>
            .blue-text {
                color: #0A6790;
            }

            .featured-text {
                font-weight: bold;
            }

            .inline-item {
                display: inline-block !important;
                text-align: center !important;
                width: 100% !important;
                padding-bottom: 10px !important;
            }

            .drop-line-mobile {
                display: block !important;
            }

            .content-table {
                width: 100%;
            }

            @media screen and (min-width: 600px) {
                .inline-item {
                    display: inline !important;
                    padding-bottom: 10px;
                    text-align: center !important;
                }

                .content-table {
                    width: 70%;
                }

                .drop-line-mobile {
                    display: inline-block !important;
                }
            }
        </style>
    </head>
    <body style="margin: 0; background-color: #ececec;">
        <main style="background-color: #ececec; width: 100%; min-height: 100vh; font-family: sans-serif; color: #6C6D6E;">
            <table cellpadding="0" cellspacing="0" style="max-width: 600px; margin-left: auto; margin-right: auto; background-color: #ffffff; table-layout:fixed;">
                <tr>
                    <td style="text-align:center"><img src="{{ url() }}assets/logo.jpeg" alt="InPeace" style="width: 13rem; margin-top: 50px; margin-left: auto; margin-right: auto;"></td>
                </tr>
                <tr>
                    <td style="padding: 60px 25px">
                        <table cellpadding="0" cellspacing="0" style="width: 100%; margin-left: auto; margin-right: auto; background-color: #ffffff; table-layout:fixed;">
                            <tr>
                                <td style="line-height: 20px; font-weight: bold; color: #000000">Olá <span class="blue-text">Fulano</span>!</td>
                            </tr>
                            <tr>
                                <td style="line-height: 20px; padding-top: 35px; padding-bottom: 15px; font-size: 1rem;">Você garantiu o seu lugar no evento <span class="blue-text featured-text">Wesley Safadão - 09/28/2019</span></td>
                            </tr>

                            <tr>
                                <td style="padding-top: 10px; padding-bottom: 4rem">
                                    <table cellpadding="0" cellspacing="0" class="content-table" style="margin-left: auto; margin-right: auto; table-layout:fixed;">
                                        <tr>
                                            <td>
                                                <h4 style="text-align: center; font-size: 1.2rem; color: #0A6790; margin-bottom: 1rem; text-transform: uppercase">Veja seus ingressos</h4>
                                            </td>
                                        </tr>
                                        <!-- Replicar para cada pagamento o TR inteiro alterando as informações
                                            Se tiver mais de um item, depois do primeiro colocar 'border-top: none' no style do TD
                                        -->
                                        <tr>
                                            <td style="border: 3px solid #0A6790; border-bottom: 3px dashed #0A6790; border-radius: 5px; padding: 1rem; margin-bottom: 2rem;">
                                                <div class="top-ticket" style="text-align: center;">
                                                    <img src="https://www.convertte.com.br/cvtt/wp-content/uploads/2017/02/WESLEY.png" alt="InPeace" style="width: 9rem; margin-left: auto; margin-right: auto; align-items: center; display: inline; margin: 0 auto;">
                                                </div>
                                                <div class="content" style="color: #0A6790">
                                                    <p style="font-weight: bold; font-size: 0.9rem; text-align: center;">Wesley Safadão</p>
                                                    <table cellpadding="0" cellspacing="0" style="width: 100%; margin-left: auto; margin-right: auto; table-layout:fixed;">
                                                        <tr>
                                                            <td>
                                                                <p style="font-weight: bold; font-size: 0.9rem; text-align: left; margin: 0;">Arena Delícias de Minas</p>
                                                            </td>
                                                            <td>
                                                                <p style="font-size: 0.9rem; text-align: right; margin: 0;">Newark - NJ</p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="padding-top: 0.8rem">
                                                                <p style="font-weight: bold; font-size: 0.9rem; text-align: left; margin: 0;">Credit</p>
                                                            </td>
                                                            <td style="padding-top: 0.8rem">
                                                                <p style="font-size: 0.9rem; text-align: right; margin: 0; ">66,00</p>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                                <div class="qrcode" style="color: #0A6790; text-align: center; padding-top: 2rem;">
                                                    <p style="font-weight: bold;">GA</p>
                                                    <img src="assets/qrcode.png" alt="Wesley Safadão" style="width: 8rem;">
                                                    <p style="font-weight: bold;">9584658128</p>
                                                </div>
                                                <!-- <div style="width: 2.2rem; height: 2.2rem; border: 2px solid #0A6790; border-radius: 50%; margin-bottom: -2.2rem; margin-left: auto; margin-right: auto; background: #fff;"></div> -->
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="border: 3px solid #0A6790; border-bottom: 3px dashed #0A6790; border-radius: 5px; padding: 1rem; margin-bottom: 1rem; border-top: none">
                                                <div class="top-ticket" style="text-align: center;">
                                                    <img src="https://www.convertte.com.br/cvtt/wp-content/uploads/2017/02/WESLEY.png" alt="InPeace" style="width: 9rem; margin-left: auto; margin-right: auto; align-items: center; display: inline; margin: 0 auto;">
                                                </div>
                                                <div class="content" style="color: #0A6790">
                                                    <p style="font-weight: bold; font-size: 0.9rem; text-align: center;">Wesley Safadão</p>
                                                    <table cellpadding="0" cellspacing="0" style="width: 100%; margin-left: auto; margin-right: auto; table-layout:fixed;">
                                                        <tr>
                                                            <td>
                                                                <p style="font-weight: bold; font-size: 0.9rem; text-align: left; margin: 0;">Arena Delícias de Minas</p>
                                                            </td>
                                                            <td>
                                                                <p style="font-size: 0.9rem; text-align: right; margin: 0;">Newark - NJ</p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="padding-top: 0.8rem">
                                                                <p style="font-weight: bold; font-size: 0.9rem; text-align: left; margin: 0;">Credit</p>
                                                            </td>
                                                            <td style="padding-top: 0.8rem">
                                                                <p style="font-size: 0.9rem; text-align: right; margin: 0; ">66,00</p>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                                <div class="qrcode" style="color: #0A6790; text-align: center; padding-top: 2rem;">
                                                    <p style="font-weight: bold;">GA</p>
                                                    <img src="assets/qrcode.png" alt="Wesley Safadão" style="width: 8rem;">
                                                    <p style="font-weight: bold;">9584658128</p>
                                                </div>
                                                <!-- <div style="width: 2.2rem; height: 2.2rem; border: 2px solid #0A6790; border-radius: 50%; margin-bottom: -2.2rem; margin-left: auto; margin-right: auto; background: #fff;"></div> -->
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <table cellpadding="0" cellspacing="0" style="margin-left: auto; margin-right: auto; background: #ececec; border-radius: 5px; table-layout:fixed; padding: 25px 10px; width: 100%">
                                        <tr>
                                            <td style="line-height: 20px; font-size: 0.81rem; vertical-align:top;">
                                                <div class="inline-item" style="display: block !important;"><b>Número da transição:</b> <span class="drop-line-mobile" style="font-size: 0.9rem;">{{ 1234567 }}</span></div>
                                                <div class="inline-item" style="display: block !important;"><b>Quantidade de Ingressos:</b> <span class="drop-line-mobile" style="font-size: 0.9rem;">{{ 02 }}</span></div>

                                                <div class="inline-item" style="display: block !important;"><b>Valor:</b> <span class="drop-line-mobile" style="font-size: 0.9rem;">{{ R$ 900,00 }}</span></div>
                                                <div class="inline-item" style="display: block !important;"><b>Meio de Pagamento:</b> <span class="drop-line-mobile" style="font-size: 0.9rem;">{{ **** **** **** 0202 }}</span></div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-top: 4rem; text-align: center;">
                                    <img src="assets/map.jpeg" alt="Como chegar?" style="width: 28rem; margin: 0 auto; display: block;">
                                    <a href="#" style="margin-top: 1.5rem; padding: 1rem 2rem; background: #145876; display: inline-block; font-weight: 600; text-transform: uppercase; color: #fff; text-decoration: none;">Como chegar?</a>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: center; padding-top: 5rem;">
                                    <img src="assets/v1.jpeg" alt="V1" style="height: 5rem; margin: 0 auto; display: block;">
                                    <p>Utilize o código LEBILLETV1 e ganhe desconto em suas viagens</p>
                                    <p style="padding: 0.7rem 0 0 0; margin: 0;">Código promocional: LEBILLETV1 (DESCONTO 20%)</p>
                                    <p style="padding: 0.2rem 0 0 0; margin: 0;">Validade: 31/10 (uso ilimitado até o período de validade)</p>
                                    <p style="padding: 0.6rem 0 0 0; font-size: 0.8rem;">Válido apenas na Grande Vitória (Vitória, Vila Velha, Serra e Cariacica)</p>
                                </td>
                            </tr>
                            <tr>
                                <td style="line-height: 20px; padding-top: 4rem; font-size: 1rem; font-weight: 700;">Obrigado por se inscrever, será muito bom te ver por lá!</td>
                            </tr>
                            <tr>
                                <td style="line-height: 20px; padding-top: 20px; font-size: 1rem; " class="blue-text">Equipe LeBillet</td>
                            </tr>
                            <tr>
                                <td style="line-height: 20px; padding-top: 35px; font-size: 0.8rem; font-weight: 400; color: #707173; text-align: center;">Este email é a confimação do seu pedido para o evento Wesley Safadão no dia 09/28/2019, para obter mais informações veja o PDF em anexo</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:center; background: #ececec; font-size: 0.75rem; padding: 8px 0; color: #707173">Equipe <img src="assets/logo.jpeg" alt="LeBillet" style="width: 2.4rem;"></td>
                </tr>
            </table>
        </main>
    </body>
</html>