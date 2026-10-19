<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
{#
  Marca exibida no e-mail de confirmação enviado ao promotor.
  Para mudar o branding, edite apenas estas 3 URLs.
  - brandHeaderBg: imagem de fundo do cabeçalho (banner)
  - brandLogoHeader: logo branco sobreposto ao banner do cabeçalho
  - brandLogoFooter: logo do rodapé (fundo claro, usar versão escura/colorida)
#}
{% set brandHeaderBg = 'https://tickett.com/brand/email_header_bg.png' %}
{% set brandLogoHeader = 'https://tickett.com/brand/logo.png' %}
{% set brandLogoFooter = 'https://tickett.com/brand/logo_dark.png' %}
<html lang="pt">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>{{ config.company.full_name }} | Recebemos a sua submissão</title>
  <style type="text/css">
    a { color: #096f94; }
    body, td { font-family: Roboto, Arial, sans-serif; }
    .wrap  { width: 600px; background: #ffffff; }
    .sec-hd { background-color: #e3eef2; color: #00405a; font-size: 11px; font-weight: bold;
              text-transform: uppercase; letter-spacing: 1.5px; padding: 8px 20px;
              border-left: 4px solid #096f94; margin: 0; }
    .row   { font-size: 14px; border-bottom: 1px solid #edf2f5; }
    .lbl   { color: #6f7287; width: 160px; vertical-align: top; padding: 7px 10px 7px 20px;
             white-space: nowrap; font-size: 13px; }
    .val   { color: #1a2330; padding: 7px 20px 7px 0; font-weight: 500; vertical-align: top; font-size:14px; }
    .badge { display:inline-block; background:#096f94; color:#fff; border-radius:4px;
             padding:2px 10px; font-size:12px; font-weight:bold; letter-spacing:.5px; }
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
												background-image: url('{{ brandHeaderBg }}'); 
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
															<img src="{{ brandLogoHeader }}"
																class="logo-esquerda" alt="Tickett"
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

    <!-- SAUDAÇÃO -->
    <tr>
      <td align="center" style="padding: 30px 24px 20px; border-bottom: 1px solid #edf2f5;">
        <p style="font-size:22px; font-weight:bold; color:#00405a; margin:0 0 10px;">Olá, {{name}}! 👋</p>
        <p style="font-size:15px; color:#6f7287; margin:0; line-height:1.6;">
          Recebemos a sua proposta de evento e a nossa equipa vai analisá-la em breve.<br>
          Entraremos em contacto através do email <strong style="color:#00405a;">{{email}}</strong>.
        </p>
      </td>
    </tr>

    <!-- RESUMO DO EVENTO -->
    <tr><td style="padding: 18px 20px 6px;">
      <p class="sec-hd">Resumo da sua Submissão</p>
    </td></tr>

    <tr><td style="padding: 0 0 4px;">
      <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tr class="row"><td class="lbl">Evento</td><td class="val"><strong>{{eventoNome}}</strong></td></tr>
        <tr class="row"><td class="lbl">Categoria</td><td class="val">{{eventoCategoria}}</td></tr>
        <tr class="row"><td class="lbl">Data</td><td class="val">{{eventoDataInicio}}{% if eventoHoraInicio %} · {{eventoHoraInicio}}{% endif %}</td></tr>
        {% if eventoAberturaPortas %}<tr class="row"><td class="lbl">Abertura de portas</td><td class="val">{{eventoAberturaPortas}}</td></tr>{% endif %}
        <tr class="row"><td class="lbl">Local</td><td class="val">{{eventoLocal}}{% if eventoCidade %}, {{eventoCidade}}{% endif %}{% if eventoPais %} — {{eventoPais}}{% endif %}</td></tr>
        {% if lotacaoTotal %}<tr class="row"><td class="lbl">Lotação prevista</td><td class="val">{{lotacaoTotal}} bilhetes</td></tr>{% endif %}
        <tr class="row"><td class="lbl">Restrição de idade</td><td class="val">{{idadeRestricao}}</td></tr>
        {% if caracteristicas %}<tr class="row"><td class="lbl">Características</td><td class="val">{{caracteristicas}}</td></tr>{% endif %}
      </table>
    </td></tr>

    <!-- PRÓXIMOS PASSOS -->
    <tr>
      <td style="padding: 20px 20px 8px;">
        <p class="sec-hd">O que acontece a seguir?</p>
      </td>
    </tr>
    <tr>
      <td style="padding: 14px 24px 20px; font-size:14px; color:#1a2330; line-height:1.7;">
        <p style="margin:0 0 10px;">
          <span class="badge">1</span>&nbsp; A nossa equipa analisa os dados e as imagens que nos enviou.
        </p>
        <p style="margin:0 0 10px;">
          <span class="badge">2</span>&nbsp; Entramos em contacto consigo para confirmar detalhes e condições.
        </p>
        <p style="margin:0;">
          <span class="badge">3</span>&nbsp; Após acordo, o seu evento fica disponível para venda na plataforma.
        </p>
      </td>
    </tr>

    <!-- AVISO -->
    <tr>
      <td style="padding: 0 20px 20px;">
        <div style="background:#f0f7fa; border:1px solid #c8dfe8; border-radius:6px;
                    padding:14px 18px; font-size:13px; color:#00405a;">
          📧 Se tiver alguma dúvida ou quiser acrescentar informação,
          responda a este email ou contacte-nos em
          <a href="{{ url() }}">{{ url() }}</a>.
        </div>
      </td>
    </tr>

    <!-- FOOTER BRAND -->
    <tr>
       <td align="center" valign="top"
								style="color: #000000; padding: 20px; ">
								<a target="_blank" href="{{ url() }}">
									<img src="{{ brandLogoFooter }}" style="width: 20%;"/>
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