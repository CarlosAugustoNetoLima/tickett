<?php

class Orders extends \Phalcon\Mvc\Model
{

    /**
     *
     * @var integer
     */
    public $id;

    /**
     *
     * @var integer
     */
    public $id_customer;

    /**
     *
     * @var integer
     */
    public $id_payment_type;

    /**
     *
     * @var integer
     */
    public $id_sale_point;

    /**
     *
     * @var integer
     */
    public $id_sale_terminal;

    /**
     *
     * @var integer
     */
    public $id_orders_status;

    /**
     *
     * @var integer
     */
    public $id_orders_payment_status;

    /**
     *
     * @var integer
     */
    public $id_billing_address;

    /**
     *
     * @var double
     */
    public $value_total;

    /**
     *
     * @var double
     */
    public $value_tax;

    /**
     *
     * @var double
     */
    public $value_interest;

    /**
     *
     * @var double
     */
    public $value_discount;

    /**
     *
     * @var string
     */
    public $coupon;

    /**
     *
     * @var integer
     */
    public $installments;

    /**
     *
     * @var integer
     */
    public $email_sent;

    /**
     *
     * @var string
     */
    public $send_to_email;

    /**
     *
     * @var integer
     */
    public $whatsapp_sent;

    /**
     *
     * @var string
     */
    public $send_to_whatsapp;

    /**
     *
     * @var integer
     */
    public $sms_sent;

    /**
     *
     * @var string
     */
    public $send_to_sms;

    /**
     *
     * @var string
     */
    public $customer_id;

    /**
     *
     * @var string
     */
    public $billing_address;

    /**
     *
     * @var string
     */
    public $ref;

    /**
     *
     * @var string
     */
    public $created_at;

    /**
     *
     * @var string
     */
    public $updated_at;

    /**
     * Initialize method for model.
     */
    public function initialize()
    {
        $this->setSchema("ticket");
        $this->setSource("orders");
        $this->hasMany('id', 'LogOrderEmailSent', 'id_order', ['alias' => 'LogOrderEmailSent']);
        $this->hasMany('id', 'LogOrderProccessPayment', 'id_order', ['alias' => 'LogOrderProccessPayment']);
        $this->hasMany('id', 'LogOrderSmsSent', 'id_order', ['alias' => 'LogOrderSmsSent']);
        $this->hasMany('id', 'LogOrderWhatsappSent', 'id_order', ['alias' => 'LogOrderWhatsappSent']);
        $this->hasMany('id', 'LogSendPush', 'id_order', ['alias' => 'LogSendPush']);
        $this->hasMany('id', 'OrderSale', 'id_order', ['alias' => 'OrderSale']);
        $this->hasMany('id', 'OrdersActive', 'id_order', ['alias' => 'OrdersActive']);
        $this->hasMany('id', 'OrdersAnalysis', 'id_order', ['alias' => 'OrdersAnalysis']);
        $this->hasMany('id', 'OrdersPayment', 'id_order', ['alias' => 'OrdersPayment']);
        $this->hasMany('id', 'OrdersPaymentAuditing', 'id_order', ['alias' => 'OrdersPaymentAuditing']);
        $this->hasMany('id', 'Sales', 'id_order', ['alias' => 'Sales']);
        $this->belongsTo('id_customer', 'Customers', 'id', ['alias' => 'Customers']);
        $this->belongsTo('id_payment_type', 'PaymentTypes', 'id', ['alias' => 'PaymentTypes']);
        $this->belongsTo('id_orders_status', 'OrdersStatus', 'id', ['alias' => 'OrdersStatus']);
        $this->belongsTo('id_sale_point', 'SalesPoints', 'id', ['alias' => 'SalesPoints']);
        $this->belongsTo('id_sale_terminal', 'SalesTerminal', 'id', ['alias' => 'SalesTerminal']);
        $this->belongsTo('id_orders_payment_status', 'OrdersPaymentStatus', 'id', ['alias' => 'OrdersPaymentStatus']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'orders';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return Orders[]|Orders|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return Orders|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
