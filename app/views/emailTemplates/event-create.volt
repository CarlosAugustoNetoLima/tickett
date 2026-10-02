<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="pt">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>{{ config.company.full_name }} | Nova Submissão de Evento</title>
  <style type="text/css">
    a { color: #096f94; }
    body, td { font-family: Roboto, Arial, sans-serif; }
    .wrap   { width: 600px; background: #ffffff; }
    .sec-hd { background-color: #096f94; color: #ffffff; font-size: 11px; font-weight: bold;
              text-transform: uppercase; letter-spacing: 1.5px; padding: 9px 20px; margin: 0; }
    .row    { font-size: 14px; border-bottom: 1px solid #edf2f5; }
    .lbl    { color: #6f7287; width: 185px; vertical-align: top; padding: 8px 12px 8px 20px;
              white-space: nowrap; font-size: 13px; }
    .val    { color: #1a2330; padding: 8px 20px 8px 0; font-weight: 500; vertical-align: top; }
    .val-pre{ white-space: pre-wrap; }
    .attach-note { background: #f0f7fa; border-left: 4px solid #096f94; padding: 12px 20px;
                   font-size: 13px; color: #00405a; }
  </style>
</head>
<body style="margin:0; padding:0; background-color:#545454;">
<center>
<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#545454">
<tr><td align="center" valign="top" style="padding: 24px 0;">

  <table class="wrap" width="600" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">

    <!-- HEADER IMAGE -->
    <tr>
      <td align="center" valign="top">
        <table width="600px" cellpadding="0" cellspacing="0" border="0" align="center" style="width:600px;"
						bgcolor="#F2F2F2">
						<tr>
							<td align="center" valign="top" style=" ">

								<table cellspacing="0" cellpadding="0" border="0" align="center" style="  width:100%;">
									<tr>
										<td width="100%" align="center" valign="top" style=" ">
											<div style="
												justify-content: space-between;
												align-items: center;
												background-image: url('https://lebillet.eu/logos/lebillet_pt/header_clean.png'); 
												background-size: cover; 
												background-position: center; 
												height: auto;
												display: flex;
												padding: 20px;
												">

												<table width="100%" border="0" cellspacing="0" cellpadding="0"
													style="height: 100%;">
													<tr>
														<td valign="middle" align="left">
															<img src="{{ url() }}{{ config.company.logos }}white_new.png"
																class="logo-esquerda" alt="Logo"
																style="display: block; height: auto; width: 30%;">
														</td>
														<td valign="middle" align="right" style="color: #ffffff;">
															<p style="font-size: 18px;">
                                Nova Submissão<br><span style="font-size:55%; opacity:.85; letter-spacing:2px; text-transform:uppercase;">de Evento</span>
															</p>
														</td>
													</tr>
												</table>
											</div>
										</td>
									</tr>
								</table>


							</td>
						</tr>
					</table>
      </td>
    </tr>

    <!-- INTRO -->
    <tr>
      <td style="padding: 22px 20px 10px; font-size:15px; color:#00405a; border-bottom:2px solid #096f94;">
        <strong style="font-size:16px;">{{name}}</strong> submeteu um novo evento pelo site.<br>
        <span style="color:#6f7287; font-size:13px;">Recebido em {{ date('d/m/Y \à\s H:i') }}</span>
      </td>
    </tr>

    <!-- NOTA SOBRE ANEXOS -->
    <tr>
      <td style="padding: 12px 20px;">
        <div class="attach-note">
          📎 As imagens enviadas (cartaz, banner e outros) seguem em anexo neste email.
        </div>
      </td>
    </tr>

    <!-- ===== PROMOTOR ===== -->
    <tr><td style="padding: 14px 0 0;"><p class="sec-hd">Dados do Promotor</p></td></tr>
    <tr><td>
      <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tr class="row"><td class="lbl">Nome</td><td class="val">{{name}}</td></tr>
        {% if promotorEntidade %}<tr class="row"><td class="lbl">Entidade / Empresa</td><td class="val">{{promotorEntidade}}</td></tr>{% endif %}
        <tr class="row"><td class="lbl">NIF</td><td class="val">{{promotorNif}}</td></tr>
        <tr class="row"><td class="lbl">Email</td><td class="val"><a href="mailto:{{email}}">{{email}}</a></td></tr>
        <tr class="row"><td class="lbl">Telefone</td><td class="val">{{phone}}</td></tr>
        {% if promotorWebsite %}<tr class="row"><td class="lbl">Website / Rede social</td><td class="val"><a href="{{promotorWebsite}}" target="_blank">{{promotorWebsite}}</a></td></tr>{% endif %}
      </table>
    </td></tr>

    <!-- ===== EVENTO ===== -->
    <tr><td style="padding: 16px 0 0;"><p class="sec-hd">Dados do Evento</p></td></tr>
    <tr><td>
      <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tr class="row"><td class="lbl">Nome do evento</td><td class="val">{{eventoNome}}</td></tr>
        <tr class="row"><td class="lbl">Categoria</td><td class="val">{{eventoCategoria}}</td></tr>
        <tr class="row"><td class="lbl">Descrição</td><td class="val val-pre">{{message}}</td></tr>
        <tr class="row"><td class="lbl">Data</td><td class="val">{{eventoDataInicio}}</td></tr>
        {% if eventoAberturaPortas %}<tr class="row"><td class="lbl">Abertura de portas</td><td class="val">{{eventoAberturaPortas}}</td></tr>{% endif %}
        <tr class="row"><td class="lbl">Hora de início</td><td class="val">{{eventoHoraInicio}}</td></tr>
        {% if vendasFim %}<tr class="row"><td class="lbl">Fim das vendas</td><td class="val">{{vendasFim}}{% if vendasFimHora %} às {{vendasFimHora}}{% endif %}</td></tr>{% endif %}
        <tr class="row"><td class="lbl">Recinto / Local</td><td class="val">{{eventoLocal}}</td></tr>
        {% if eventoMorada %}<tr class="row"><td class="lbl">Morada</td><td class="val">{{eventoMorada}}</td></tr>{% endif %}
        <tr class="row"><td class="lbl">Cidade</td><td class="val">{{eventoCidade}}</td></tr>
        <tr class="row"><td class="lbl">País</td><td class="val">{{eventoPais}}</td></tr>
      </table>
    </td></tr>

    <!-- ===== BILHÉTICA ===== -->
    <tr><td style="padding: 16px 0 0;"><p class="sec-hd">Bilhética</p></td></tr>
    <tr><td>
      <table width="100%" cellpadding="0" cellspacing="0" border="0">
        {% if bilhetes %}<tr class="row"><td class="lbl">Bilhetes</td><td class="val val-pre">{{bilhetes}}</td></tr>{% endif %}
        {% if lotacaoTotal %}<tr class="row"><td class="lbl">Lotação total</td><td class="val">{{lotacaoTotal}} bilhetes</td></tr>{% endif %}
        <tr class="row"><td class="lbl">Restrição de idade</td><td class="val">{{idadeRestricao}}</td></tr>
        {% if caracteristicas %}<tr class="row"><td class="lbl">Características</td><td class="val">{{caracteristicas}}</td></tr>{% endif %}
        {% if mobilidadeLotacao %}<tr class="row"><td class="lbl">Mobilidade reduzida</td><td class="val">{{mobilidadeLotacao}} lugares</td></tr>{% endif %}
        {% if descontos %}<tr class="row"><td class="lbl">Descontos</td><td class="val">{{descontos}}</td></tr>{% endif %}
        {% if observacoes %}<tr class="row"><td class="lbl">Observações</td><td class="val val-pre">{{observacoes}}</td></tr>{% endif %}
      </table>
    </td></tr>

    <!-- FOOTER BRAND -->
    <tr>
     <td align="center" valign="top"
								style="color: #000000; padding: 20px; ">
								<a target="_blank" href="{{ urlSite }}">
									<img src="{{ url() }}{{ config.company.logos }}logo.png" style="width: 20%;"/>
								</a>

								<p>
									<b>{{ config.company.name }}</b>: Inovação, Segurança e Tecnologia de ponta!
								</p>

								<p>
									<small>
										Este é um e-mail automático, <b>favor não responder.</b>
									</small>
								</p>
							</td>
    </tr>

  </table>

</td></tr>
</table>
</center>
</body>
</html>