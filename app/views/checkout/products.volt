<h2 class="fs-title">{{ t._('products') }}</h2>
<h3 class="fs-subtitle">{{ t._('Select your products') }}</h3>


<form id="form-products">
	<input type="hidden" name="event" value="{{ event.id }}" />
	<div class=" ">
		<table class="table   table-hover">
			<thead>
				<tr>
					<th>{{ t._('name') }}</th>
					<th class="text-center">{{ t._('lot') }}</th>
					<th class="text-center">
						{{ t._('price') }} <br/>
					</th>
					<th class="text-center">{{ t._('qty') }}</th>
				</tr>
			</thead>
			<tbody>
				{% for product in products %}

				<tr>
					<td class="text-left">
						{{ product['name'] }}
						<?php if ( $product['genre_id'] > 1 ) : ?>
							<i>&nbsp; {{ t._(product['genre']) }}</i>
						<?php endif ; ?>
						<?php if ( $product['type_id'] > 1 ) : ?>
							<i>&nbsp; {{ t._(product['type_name']) }}</i>
						<?php endif ; ?>

					</th>
						<td>
							<?php echo ( $product['lot_name'] ? $product['lot_name'] : $product['current_lot']) ?>

							</td>
						<td>
							<?php
							$available = 6;
							if ( isset($product['type_name'])  AND  $product['available'] > 0 ) :
								if ( $product['available'] < 6  ) $available = $product['available'];
								/*
								$lot_price = (
									$product['price'] +
									$product['tax'] +
									$product['duty_value'] +
									$product['duty_tax_value'] +
									$product['duty_org_value'] +
									$product['duty_org_tax_value']
								);
								*/
								// Não gostei disto - Mas segundo o Manga nao irá dar problema - Vamos testar
								$lot_price = $product['price'];
								$total_tax =  $product['tax'] +  $product['duty_value'] +  $product['duty_tax_value'] +  $product['duty_org_value'] +  $product['duty_org_tax_value'];
								?>
								<button type="button" class=" btn-link" data-toggle="tooltip" data-html="true"
								title="
								<table class='table'>
									<thead>
										<tr>
											<th scope='col'>{{ t._('product') }}</th>
											<?php if ( $total_tax > 0 ) : ?>
												<th scope='col'>{{ t._('fee') }}</th>
											<?php endif ; ?>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td><?php echo formatMoney($product['price'], false) ?></td>
											<?php if ( $total_tax > 0 ) : ?>
												<td><?php echo formatMoney($total_tax, false) ?></td>
											<?php endif ; ?>
										</tr>
									</tbody>
								</table>
								">
								<?php echo formatMoney($lot_price) ?>
							</button>

						<?php else  :// if ( isset($product['type_name']) ) ?>
							{{ t._("soldout") }}
						<?php endif ; ?>
					</td>
					<td class="td-touchspin " style="max-width: 100px;">
						{% if product['type_name']  AND  product['available'] > 0  %}
						<?php
							// Isto é pra saber se ja tem no carrinho este produto, entao já inicia com a qtd selecionada
						$tmp_qty = isset($cart['event'][$event->id]['products'][$product['id']][$product['type_id']]['qty']) ? $cart['event'][$event->id]['products'][$product['id']][$product['type_id']]['qty'] : 0;
						?>
						<input type="text" data-price='{{ lot_price }}' data-available='{{ available }}' class="input_qty text-center"  name="product[{{ product['id'] }}][{{ product['type_id'] }}][qty]" value="{{ tmp_qty }}" >
						{% else %}
						{{ t._('soldout') }}
						{% endif  %}

						<?php
/*
						echo '<br>id: ' . $product['id'] ;
						 echo '<br>type_id: ' . $product['type_id'];
						 echo '<br>available: ' . $product['available'] ;
						    echo '<br>id_sale_point: ' . $id_sale_point;
*/
						     ?>
					</td>
				</tr>
				{% endfor  %}
			</tbody>
		</table>
	</div>
</form>

