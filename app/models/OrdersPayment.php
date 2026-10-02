<?php

class OrdersPayment extends \Phalcon\Mvc\Model
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
    public $id_order;

    /**
     *
     * @var integer
     */
    public $id_payment_type;

    /**
     *
     * @var double
     */
    public $amount;

    /**
     *
     * @var string
     */
    public $expiration_date;

    /**
     *
     * @var string
     */
    public $release_date;

    /**
     *
     * @var string
     */
    public $cc_name;

    /**
     *
     * @var string
     */
    public $cc_number;

    /**
     *
     * @var string
     */
    public $cc_expiration;

    /**
     *
     * @var string
     */
    public $cc_cvv;

    /**
     *
     * @var string
     */
    public $cc_zipcode;

    /**
     *
     * @var string
     */
    public $cc_authcode;

    /**
     *
     * @var string
     */
    public $cc_transactionid;

    /**
     *
     * @var string
     */
    public $cc_response;

    /**
     *
     * @var string
     */
    public $billet_number;

    /**
     *
     * @var string
     */
    public $billet_expiration;

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
        $this->setSource("orders_payment");
        $this->hasMany('id', 'LogOrderProccessPayment', 'id_orders_payment', ['alias' => 'LogOrderProccessPayment']);
        $this->belongsTo('id_order', 'Orders', 'id', ['alias' => 'Orders']);
        $this->belongsTo('id_payment_type', 'PaymentTypes', 'id', ['alias' => 'PaymentTypes']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'orders_payment';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return OrdersPayment[]|OrdersPayment|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return OrdersPayment|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
