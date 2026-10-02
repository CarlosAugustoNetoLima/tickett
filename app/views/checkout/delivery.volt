<h2 class="fs-title">{{ t._('Delivery') }}</h2>
<h3 class="fs-subtitle">{{ t._('Email to send ticket') }}</h3>

<form id="form-delivery">
	<input type="hidden" name="deliveryMethod" value="6" />
	<input type="email" class="form-control email" name="email" placeholder="{{ t._('Email') }}" value="<?php echo isset($customer) ? $customer->email : ''  ?>" />
	<div   id="text-error-delivery"></div>
</form>
