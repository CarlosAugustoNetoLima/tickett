<?php


	foreach ($withdrawals as $withdrawal)
	{
		// sangrias por evento e por forma de pgto
		$values_withdrawal[$withdrawal['id_event']][$withdrawal['id_payment_type']]['value_product'] = $withdrawal['value_product'];
		$values_withdrawal[$withdrawal['id_event']][$withdrawal['id_payment_type']]['value_product_tax'] = $withdrawal['value_product_tax'];
		$values_withdrawal[$withdrawal['id_event']][$withdrawal['id_payment_type']]['value_fee'] = $withdrawal['value_fee'];
		$values_withdrawal[$withdrawal['id_event']][$withdrawal['id_payment_type']]['value_fee_tax'] = $withdrawal['value_fee_tax'];
		$values_withdrawal[$withdrawal['id_event']][$withdrawal['id_payment_type']]['value_fee_org'] = $withdrawal['value_fee_org'];
		$values_withdrawal[$withdrawal['id_event']][$withdrawal['id_payment_type']]['value_fee_org_tax'] = $withdrawal['value_fee_org_tax'];
		$values_withdrawal[$withdrawal['id_event']][$withdrawal['id_payment_type']]['value_total'] = $withdrawal['value_total'];

		// valor total de sangria agrupado
		$values_withdrawal_total['value_product'] = isset($values_withdrawal_total['value_product']) ? $values_withdrawal_total['value_product'] +  $withdrawal['value_product'] :  $withdrawal['value_product'] ;
		$values_withdrawal_total['value_product_tax'] = isset($values_withdrawal_total['value_product_tax']) ? $values_withdrawal_total['value_product_tax'] +  $withdrawal['value_product_tax'] :  $withdrawal['value_product_tax'] ;
		$values_withdrawal_total['value_fee'] = isset($values_withdrawal_total['value_fee']) ? $values_withdrawal_total['value_fee'] +  $withdrawal['value_fee'] :  $withdrawal['value_fee'] ;
		$values_withdrawal_total['value_fee_tax'] = isset($values_withdrawal_total['value_fee_tax']) ? $values_withdrawal_total['value_fee_tax'] +  $withdrawal['value_fee_tax'] :  $withdrawal['value_fee_tax'] ;
		$values_withdrawal_total['value_fee_org'] = isset($values_withdrawal_total['value_fee_org']) ? $values_withdrawal_total['value_fee_org'] +  $withdrawal['value_fee_org'] :  $withdrawal['value_fee_org'] ;
		$values_withdrawal_total['value_fee_org_tax'] = isset($values_withdrawal_total['value_fee_org_tax']) ? $values_withdrawal_total['value_fee_org_tax'] +  $withdrawal['value_fee_org_tax'] :  $withdrawal['value_fee_org_tax'] ;
		$values_withdrawal_total['value_total'] = isset($values_withdrawal_total['value_total']) ? $values_withdrawal_total['value_total'] +  $withdrawal['value_total'] :  $withdrawal['value_total'] ;

		// sangrias por forma de pgt
		$values_withdrawal_payment[$withdrawal['id_payment_type']]['value_product'] = isset($values_withdrawal_payment[$withdrawal['id_payment_type']]['value_product']) ? $values_withdrawal_payment[$withdrawal['id_payment_type']]['value_product'] +  $withdrawal['value_product'] :  $withdrawal['value_product'];
		$values_withdrawal_payment[$withdrawal['id_payment_type']]['value_product_tax'] = isset($values_withdrawal_payment[$withdrawal['id_payment_type']]['value_product_tax']) ? $values_withdrawal_payment[$withdrawal['id_payment_type']]['value_product_tax'] +  $withdrawal['value_product_tax'] :  $withdrawal['value_product_tax'];
		$values_withdrawal_payment[$withdrawal['id_payment_type']]['value_fee'] = isset($values_withdrawal_payment[$withdrawal['id_payment_type']]['value_fee']) ? $values_withdrawal_payment[$withdrawal['id_payment_type']]['value_fee'] +  $withdrawal['value_fee'] :  $withdrawal['value_fee'];
		$values_withdrawal_payment[$withdrawal['id_payment_type']]['value_fee_tax'] = isset($values_withdrawal_payment[$withdrawal['id_payment_type']]['value_fee_tax']) ? $values_withdrawal_payment[$withdrawal['id_payment_type']]['value_fee_tax'] +  $withdrawal['value_fee_tax'] :  $withdrawal['value_fee_tax'];
		$values_withdrawal_payment[$withdrawal['id_payment_type']]['value_fee_org'] = isset($values_withdrawal_payment[$withdrawal['id_payment_type']]['value_fee_org']) ? $values_withdrawal_payment[$withdrawal['id_payment_type']]['value_fee_org'] +  $withdrawal['value_fee_org'] :  $withdrawal['value_fee_org'];
		$values_withdrawal_payment[$withdrawal['id_payment_type']]['value_fee_org_tax'] = isset($values_withdrawal_payment[$withdrawal['id_payment_type']]['value_fee_org_tax']) ? $values_withdrawal_payment[$withdrawal['id_payment_type']]['value_fee_org_tax'] +  $withdrawal['value_fee_org_tax'] :  $withdrawal['value_fee_org_tax'];
		$values_withdrawal_payment[$withdrawal['id_payment_type']]['value_total'] = isset($values_withdrawal_payment[$withdrawal['id_payment_type']]['value_total']) ? $values_withdrawal_payment[$withdrawal['id_payment_type']]['value_total'] +  $withdrawal['value_total'] :  $withdrawal['value_total'];

	}


	$distinct_payment_type = $distinct_event = $values_sales_total = array();
	foreach ($salesResume as  $sales )
	{
		if ( $sales['value_product'] > 0 )
		{
			$distinct_payment_type[$sales['id_payment_type']] = $sales['name_payment_type'];
			$distinct_event[$sales['id_event']] = $sales['name_event'];

			// Vendas por evento e forma de pgto
			$values_sales[$sales['id_event']][$sales['id_payment_type']]['value_product'] = $sales['value_product'];
			$values_sales[$sales['id_event']][$sales['id_payment_type']]['value_product_tax'] = $sales['value_product_tax'];
			$values_sales[$sales['id_event']][$sales['id_payment_type']]['value_fee'] = $sales['value_fee'];
			$values_sales[$sales['id_event']][$sales['id_payment_type']]['value_fee_tax'] = $sales['value_fee_tax'];
			$values_sales[$sales['id_event']][$sales['id_payment_type']]['value_fee_org'] = $sales['value_fee_org'];
			$values_sales[$sales['id_event']][$sales['id_payment_type']]['value_fee_org_tax'] = $sales['value_fee_org_tax'];
			$values_sales[$sales['id_event']][$sales['id_payment_type']]['value_total'] = $sales['value_total'];


			// Vendas totais agrupadas
			$values_sales_total['value_product'] = isset($values_sales_total['value_product']) ? $values_sales_total['value_product'] + $sales['value_product'] :  $sales['value_product'];
			$values_sales_total['value_product_tax'] = isset($values_sales_total['value_product_tax']) ? $values_sales_total['value_product_tax'] + $sales['value_product_tax'] :  $sales['value_product_tax'];
			$values_sales_total['value_fee'] = isset($values_sales_total['value_fee']) ? $values_sales_total['value_fee'] + $sales['value_fee'] :  $sales['value_fee'];
			$values_sales_total['value_fee_tax'] = isset($values_sales_total['value_fee_tax']) ? $values_sales_total['value_fee_tax'] + $sales['value_fee_tax'] :  $sales['value_fee_tax'];
			$values_sales_total['value_fee_org'] = isset($values_sales_total['value_fee_org']) ? $values_sales_total['value_fee_org'] + $sales['value_fee_org'] :  $sales['value_fee_org'];
			$values_sales_total['value_fee_org_tax'] = isset($values_sales_total['value_fee_org_tax']) ? $values_sales_total['value_fee_org_tax'] + $sales['value_fee_org_tax'] :  $sales['value_fee_org_tax'];
			$values_sales_total['value_total'] = isset($values_sales_total['value_total']) ? $values_sales_total['value_total'] + $sales['value_total'] :  $sales['value_total'];


			// Vendas por forma de pgto
			$values_sales_payment[$sales['id_payment_type']]['value_product'] = isset($values_sales_payment[$sales['id_payment_type']]['value_product']) ? $values_sales_payment[$sales['id_payment_type']]['value_product'] +  $sales['value_product'] :  $sales['value_product'];
			$values_sales_payment[$sales['id_payment_type']]['value_product_tax'] = isset($values_sales_payment[$sales['id_payment_type']]['value_product_tax']) ? $values_sales_payment[$sales['id_payment_type']]['value_product_tax'] +  $sales['value_product_tax'] :  $sales['value_product_tax'];
			$values_sales_payment[$sales['id_payment_type']]['value_fee'] = isset($values_sales_payment[$sales['id_payment_type']]['value_fee']) ? $values_sales_payment[$sales['id_payment_type']]['value_fee'] +  $sales['value_fee'] :  $sales['value_fee'];
			$values_sales_payment[$sales['id_payment_type']]['value_fee_tax'] = isset($values_sales_payment[$sales['id_payment_type']]['value_fee_tax']) ? $values_sales_payment[$sales['id_payment_type']]['value_fee_tax'] +  $sales['value_fee_tax'] :  $sales['value_fee_tax'];
			$values_sales_payment[$sales['id_payment_type']]['value_fee_org'] = isset($values_sales_payment[$sales['id_payment_type']]['value_fee_org']) ? $values_sales_payment[$sales['id_payment_type']]['value_fee_org'] +  $sales['value_fee_org'] :  $sales['value_fee_org'];
			$values_sales_payment[$sales['id_payment_type']]['value_fee_org_tax'] = isset($values_sales_payment[$sales['id_payment_type']]['value_fee_org_tax']) ? $values_sales_payment[$sales['id_payment_type']]['value_fee_org_tax'] +  $sales['value_fee_org_tax'] :  $sales['value_fee_org_tax'];
			$values_sales_payment[$sales['id_payment_type']]['value_total'] = isset($values_sales_payment[$sales['id_payment_type']]['value_total']) ? $values_sales_payment[$sales['id_payment_type']]['value_total'] +  $sales['value_total'] :  $sales['value_total'];
		}
	}


	// Monta o saldo - BALANCE por forma de pgto
	foreach ($distinct_payment_type as $id_payment_type => $name_payment_type)
	{
		$values_balance_payment[$id_payment_type]['value_total'] =  (isset($values_sales_payment[$id_payment_type]['value_total']) ? $values_sales_payment[$id_payment_type]['value_total'] : 0) - (isset($values_withdrawal_payment[$id_payment_type]['value_total']) ? $values_withdrawal_payment[$id_payment_type]['value_total'] : 0);

		$values_balance_payment[$id_payment_type]['value_product'] =  (isset($values_sales_payment[$id_payment_type]['value_product']) ? $values_sales_payment[$id_payment_type]['value_product'] : 0) - (isset($values_withdrawal_payment[$id_payment_type]['value_product']) ? $values_withdrawal_payment[$id_payment_type]['value_product'] : 0);

		$values_balance_payment[$id_payment_type]['value_product_tax'] =  (isset($values_sales_payment[$id_payment_type]['value_product_tax']) ? $values_sales_payment[$id_payment_type]['value_product_tax'] : 0) - (isset($values_withdrawal_payment[$id_payment_type]['value_product_tax']) ? $values_withdrawal_payment[$id_payment_type]['value_product_tax'] : 0);

		$values_balance_payment[$id_payment_type]['value_fee'] =  (isset($values_sales_payment[$id_payment_type]['value_fee']) ? $values_sales_payment[$id_payment_type]['value_fee'] : 0) - (isset($values_withdrawal_payment[$id_payment_type]['value_fee']) ? $values_withdrawal_payment[$id_payment_type]['value_fee'] : 0);

		$values_balance_payment[$id_payment_type]['value_fee_tax'] =  (isset($values_sales_payment[$id_payment_type]['value_fee_tax']) ? $values_sales_payment[$id_payment_type]['value_fee_tax'] : 0) - (isset($values_withdrawal_payment[$id_payment_type]['value_fee_tax']) ? $values_withdrawal_payment[$id_payment_type]['value_fee_tax'] : 0);

		$values_balance_payment[$id_payment_type]['value_fee_org'] =  (isset($values_sales_payment[$id_payment_type]['value_fee_org']) ? $values_sales_payment[$id_payment_type]['value_fee_org'] : 0) - (isset($values_withdrawal_payment[$id_payment_type]['value_fee_org']) ? $values_withdrawal_payment[$id_payment_type]['value_fee_org'] : 0);

		$values_balance_payment[$id_payment_type]['value_fee_org_tax'] =  (isset($values_sales_payment[$id_payment_type]['value_fee_org_tax']) ? $values_sales_payment[$id_payment_type]['value_fee_org_tax'] : 0) - (isset($values_withdrawal_payment[$id_payment_type]['value_fee_org_tax']) ? $values_withdrawal_payment[$id_payment_type]['value_fee_org_tax'] : 0);

		$values_balance_payment[$id_payment_type]['value_total'] =  (isset($values_sales_payment[$id_payment_type]['value_total']) ? $values_sales_payment[$id_payment_type]['value_total'] : 0) - (isset($values_withdrawal_payment[$id_payment_type]['value_total']) ? $values_withdrawal_payment[$id_payment_type]['value_total'] : 0);

	}



	// Monta o saldo - BALANCE - total, agrupado
	$values_balance_total['value_total']  = ( ( isset($values_sales_total['value_total']) ? $values_sales_total['value_total'] : 0 ) - ( isset($values_withdrawal_total['value_total']) ? $values_withdrawal_total['value_total'] : 0 ) ) ;

	$values_balance_total['value_product']  = ( ( isset($values_sales_total['value_product']) ? $values_sales_total['value_product'] : 0 ) - ( isset($values_withdrawal_total['value_product']) ? $values_withdrawal_total['value_product'] : 0 ) ) ;

	$values_balance_total['value_product_tax']  = ( ( isset($values_sales_total['value_product_tax']) ? $values_sales_total['value_product_tax'] : 0 ) - ( isset($values_withdrawal_total['value_product_tax']) ? $values_withdrawal_total['value_product_tax'] : 0 ) ) ;

	$values_balance_total['value_fee']  = ( ( isset($values_sales_total['value_fee']) ? $values_sales_total['value_fee'] : 0 ) - ( isset($values_withdrawal_total['value_fee']) ? $values_withdrawal_total['value_fee'] : 0 ) ) ;

	$values_balance_total['value_fee_tax']  = ( ( isset($values_sales_total['value_fee_tax']) ? $values_sales_total['value_fee_tax'] : 0 ) - ( isset($values_withdrawal_total['value_fee_tax']) ? $values_withdrawal_total['value_fee_tax'] : 0 ) ) ;

	$values_balance_total['value_fee_org']  = ( ( isset($values_sales_total['value_fee_org']) ? $values_sales_total['value_fee_org'] : 0 ) - ( isset($values_withdrawal_total['value_fee_org']) ? $values_withdrawal_total['value_fee_org'] : 0 ) ) ;

	$values_balance_total['value_fee_org_tax']  = ( ( isset($values_sales_total['value_fee_org_tax']) ? $values_sales_total['value_fee_org_tax'] : 0 ) - ( isset($values_withdrawal_total['value_fee_org_tax']) ? $values_withdrawal_total['value_fee_org_tax'] : 0 ) ) ;

	$values_balance_total['value_total']  = ( ( isset($values_sales_total['value_total']) ? $values_sales_total['value_total'] : 0 ) - ( isset($values_withdrawal_total['value_total']) ? $values_withdrawal_total['value_total'] : 0 ) ) ;


	// Monta o saldo - BALANCE - por evento e forma de pgto
	/**
	* Percorre todos os registros de venda
	* Diminui o valor da sangria
	* Obtem o saldo de cada evento e cada forma de pagamento
	*/
	foreach ( $distinct_event AS $id_event => $name_event )
	{
		foreach ($distinct_payment_type as $id_payment_type => $name_payment_type)
		{
			$values_balance[$id_event][$id_payment_type]['value_product'] = (isset($values_sales[$id_event][$id_payment_type]['value_product']) ? $values_sales[$id_event][$id_payment_type]['value_product'] : 0 ) - ( isset($values_withdrawal[$id_event][$id_payment_type]['value_product']) ? $values_withdrawal[$id_event][$id_payment_type]['value_product'] : 0 );

			$values_balance[$id_event][$id_payment_type]['value_product_tax'] = (isset($values_sales[$id_event][$id_payment_type]['value_product_tax']) ? $values_sales[$id_event][$id_payment_type]['value_product_tax'] : 0 ) - ( isset($values_withdrawal[$id_event][$id_payment_type]['value_product_tax']) ? $values_withdrawal[$id_event][$id_payment_type]['value_product_tax'] : 0 );

			$values_balance[$id_event][$id_payment_type]['value_fee'] = (isset($values_sales[$id_event][$id_payment_type]['value_fee']) ? $values_sales[$id_event][$id_payment_type]['value_fee'] : 0 ) - ( isset($values_withdrawal[$id_event][$id_payment_type]['value_fee']) ? $values_withdrawal[$id_event][$id_payment_type]['value_fee'] : 0 );

			$values_balance[$id_event][$id_payment_type]['value_fee_tax'] = (isset($values_sales[$id_event][$id_payment_type]['value_fee_tax']) ? $values_sales[$id_event][$id_payment_type]['value_fee_tax'] : 0 ) - ( isset($values_withdrawal[$id_event][$id_payment_type]['value_fee_tax']) ? $values_withdrawal[$id_event][$id_payment_type]['value_fee_tax'] : 0 );

			$values_balance[$id_event][$id_payment_type]['value_fee_org'] = (isset($values_sales[$id_event][$id_payment_type]['value_fee_org']) ? $values_sales[$id_event][$id_payment_type]['value_fee_org'] : 0 ) - ( isset($values_withdrawal[$id_event][$id_payment_type]['value_fee_org']) ? $values_withdrawal[$id_event][$id_payment_type]['value_fee_org'] : 0 );

			$values_balance[$id_event][$id_payment_type]['value_fee_org_tax'] = (isset($values_sales[$id_event][$id_payment_type]['value_fee_org_tax']) ? $values_sales[$id_event][$id_payment_type]['value_fee_org_tax'] : 0 ) - ( isset($values_withdrawal[$id_event][$id_payment_type]['value_fee_org_tax']) ? $values_withdrawal[$id_event][$id_payment_type]['value_fee_org_tax'] : 0 );

			$values_balance[$id_event][$id_payment_type]['value_total'] = ( $values_balance[$id_event][$id_payment_type]['value_product'] + $values_balance[$id_event][$id_payment_type]['value_product_tax'] + $values_balance[$id_event][$id_payment_type]['value_fee'] + $values_balance[$id_event][$id_payment_type]['value_fee_tax'] + $values_balance[$id_event][$id_payment_type]['value_fee_org'] + $values_balance[$id_event][$id_payment_type]['value_fee_org_tax']  );


		}
	}



?>




{{ content() }}


<h3 class="mt-5">{{ t._('Cash Balance') }}</h3>





<form id="form-withdrawal" method="POST">
	<table class="table table-striped  table-hover table-responsive"  id="table-balance">
		<thead class="thead-light">
			<tr>
				<th scope="col">
					{{ t._('Events') }}
					<label style=" float: right; font-size: 10px;  font-weight: normal;" >
						<input type="checkbox" onchange="showDetail('#table-balance .div-tax-fee', '#table-balance')" >{{ t._('Detailed') }}
					</label>
				</th>
				<?php foreach ($distinct_payment_type as $id_payment_type => $name_payment_type) : ?>
					<th scope="col" class="td-divider text-center">{{ t._(name_payment_type) }}</th>
				<?php endforeach ; ?>

			</tr>
		</thead>
		<tbody>
			<?php foreach ( $distinct_event AS $id_event => $name_event ) : ?>
				<tr>

					<td class="align-middle">
						{{ id_event }}) {{ name_event }}
					</td>

					<?php foreach ($distinct_payment_type as $id_payment_type => $name_payment_type) : ?>
						<td class="td-divider text-right">
							<?php echo  number_format($values_balance[$id_event][$id_payment_type]['value_total'], 2) ?>
							<div class="div-tax-fee">
								<small>
									{{ t._('Products') }} : <input type="text" name="withdrawal[{{ id_event }}][{{ id_payment_type }}][value_product]" value="<?php echo  $values_balance[$id_event][$id_payment_type]['value_product'] ?>"><br>
									{{ t._('Products Tax') }} : <input type="text" name="withdrawal[{{ id_event }}][{{ id_payment_type }}][value_product_tax]" value="<?php echo  $values_balance[$id_event][$id_payment_type]['value_product_tax'] ?>"><br>
									{{ t._('Fee') }} : <input type="text" name="withdrawal[{{ id_event }}][{{ id_payment_type }}][value_fee]" value="<?php echo  $values_balance[$id_event][$id_payment_type]['value_fee'] ?>"><br>
									{{ t._('Fee Tax') }} : <input type="text" name="withdrawal[{{ id_event }}][{{ id_payment_type }}][value_fee_tax]" value="<?php echo  $values_balance[$id_event][$id_payment_type]['value_fee_tax'] ?>"><br>
									{{ t._('Fee Org') }} : <input type="text" name="withdrawal[{{ id_event }}][{{ id_payment_type }}][value_fee_org]" value="<?php echo  $values_balance[$id_event][$id_payment_type]['value_fee_org'] ?>"><br>
									{{ t._('Fee Org Tax') }} : <input type="text" name="withdrawal[{{ id_event }}][{{ id_payment_type }}][value_fee_org_tax]" value="<?php echo  $values_balance[$id_event][$id_payment_type]['value_fee_org_tax'] ?>">
								</small>
							</div>
						</td>
					<?php endforeach ; ?>
				</tr>
			<?php endforeach ; ?>


				<tr class="table-info">

					<td class="align-middle">
						{{ t._('Total') }}
					</td>

					<?php foreach ($distinct_payment_type as $id_payment_type => $name_payment_type) : ?>
						<td class="td-divider text-right">
							<?php echo  number_format($values_balance_payment[$id_payment_type]['value_total'], 2) ?>

						</td>
					<?php endforeach ; ?>

				</tr>

		</tbody>
	</table>
</form>


<p class="text-center">
	<?php if ( $values_balance_total['value_total'] > 0 ) : ?>
		<button type="button" class="btn btn-success btn-lg " onclick="submitWithdrawal();">{{ t._('withdrawal') }} <?php echo number_format($values_balance_total['value_total'], 2) ?> </button>
	<?php else : ?>
		<button type="button" class="btn btn-secondary btn-lg" disabled>{{ t._('No Cash Balance') }} </button>
	<?php endif ; ?>
</p>






<?php if ( isset($values_sales_total['value_total']) ) : ?>

<hr class="mt-5 mb-5" />


<h3 class="mt-5">{{ t._('Balance') }}</h3>


<table class="table table-striped  table-hover table-responsive"  id="table-balance">
	<thead class="thead-light">
		<tr>
			<th scope="col">
				{{ t._('Payment') }}
			</th>
			<th scope="col" class="td-divider text-center">{{ t._('Sales') }}</th>
			<th scope="col" class="td-divider text-center">{{ t._('Withdrawal') }}</th>
			<th scope="col" class="td-divider text-center">{{ t._('Balance') }}</th>
		</tr>
	</thead>
	<tbody>
		<?php foreach ( $distinct_payment_type AS $id_payment_type => $name_payment_type ) : ?>
			<tr>

				<td class="align-middle">
					{{ t._(name_payment_type) }}
				</td>

				<td class="td-divider text-right">
					<?php echo  number_format($values_sales_payment[$id_payment_type]['value_total'], 2)  ?>
				</td>
				<td class="td-divider text-right">
					<?php echo isset($values_withdrawal_payment[$id_payment_type]['value_total']) ? number_format($values_withdrawal_payment[$id_payment_type]['value_total'], 2) : 0 ?>
				</td>
				<td class="td-divider text-right">
					<?php echo number_format( ( $values_sales_payment[$id_payment_type]['value_total'] - (isset($values_withdrawal_payment[$id_payment_type]['value_total']) ? $values_withdrawal_payment[$id_payment_type]['value_total'] : 0) ), 2)  ?>
				</td>

			</tr>
		<?php endforeach ; ?>

			<tr class="table-info">

				<td class="align-middle">
					{{ t._('Total') }}
				</td>

				<td class="td-divider text-right">
					<?php echo  number_format($values_sales_total['value_total'], 2)  ?>
				</td>
				<td class="td-divider text-right">
					<?php echo isset($values_withdrawal_total['value_total']) ? number_format($values_withdrawal_total['value_total'], 2) : 0 ?>
				</td>
				<td class="td-divider text-right">
					<?php echo  number_format($values_balance_total['value_total'], 2)  ?>
				</td>

			</tr>

	</tbody>
</table>

<?php endif ; ?>