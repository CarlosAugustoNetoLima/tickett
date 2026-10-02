<section class="page-title">
    <div class="container">
        <h1 class="title">{{ t._('Last Orders') }}</h1>
    </div>
</section>

{{ partial('account/menu') }}


<section class="page-last-orders">
    <div class="container">


                        {{ content() }}
                        {{ flashSession.output() }}

        <div class="page-last-orders-inner internal-page">
            <div class="internal-page-title">
                <h2 class="title">{{ t._('wellcome') }} <span class="title-featured">{{ customer.name }}</span></h2>
            </div>

            <div class="table-area">
                <table class="table table-blue">
                    <thead class="table-head">
                        <tr>
                            <th>{{ t._('Order') }}</th>
                            <th>{{ t._('Status') }}</th>
                            <th>{{ t._('Date') }}</th>
                            <th>{{ t._('Event') }}</th>
                            <th>{{ t._('Value') }}</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody class="table-body">
                        <?php if ( count($orders) > 0 ) : ?>
							<?php foreach ( $orders AS $order ) : ?>
                                <?php if ( !in_array($order->id_orders_status, array(2, 3, 10, 1) )  ) continue;  /* somente as compras ativas ou canceladas */  ?>
                                <tr>
                                    <td>
                                        <a href="{{ url() }}account/order/{{ order.id }}" class="btn btn-outline-primary">#{{ order.id }}</a>
                                    </td>
                                    <td>
                                        {{ t._(order.OrdersPaymentStatus.name) }}
                                    </td>
                                    <td>
                                        <?php echo $this->getDI()->getFormatdates()->format($order->created_at, '25/01/2000') ?>
                                    </td>
                                    <td>
                                        <?php foreach ( $order->OrderSale AS $order_sale ) : ?>
											<p>{{ order_sale.Sales.Events.name}}  <small> &nbsp; <?php echo $this->getDI()->getFormatdates()->format($order_sale->Sales->Events->date_start, '25/01/2000') ?></small> </p>
										<?php endforeach ;?>
                                    </td>
                                    <td>
                                        <?php echo formatMoney($order->value_total, true, COMPANY, true) ?>
                                    </td>
                                    <td>
                                        <a href="{{ url() }}account/order/{{ order.id }}" class="btn btn-outline-primary">{{ t._('View') }}</a>
                                    </td>
                                </tr>
                            <?php endforeach ; ?>
						<?php else : ?>
                            <tr>
                                <td colspan="6">
                                    <h5 class="text-center">{{ t._('not_having_orders') }}</h5>
                                </td>
                            </tr>
                        <?php endif ; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</section>