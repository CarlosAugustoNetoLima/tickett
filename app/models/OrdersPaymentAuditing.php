<?php

class OrdersPaymentAuditing extends \Phalcon\Mvc\Model
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
     * @var string
     */
    public $gateway;

    /**
     *
     * @var string
     */
    public $ec;

    /**
     *
     * @var string
     */
    public $date;

    /**
     *
     * @var double
     */
    public $value;

    /**
     *
     * @var integer
     */
    public $installments;

    /**
     *
     * @var string
     */
    public $card_number;

    /**
     *
     * @var string
     */
    public $auth_number;

    /**
     *
     * @var string
     */
    public $transaction_number;

    /**
     *
     * @var double
     */
    public $fees;

    /**
     *
     * @var double
     */
    public $amount;

    /**
     *
     * @var string
     */
    public $brand;

    /**
     *
     * @var string
     */
    public $description;

    /**
     *
     * @var string
     */
    public $created_at;

    /**
     * Initialize method for model.
     */
    public function initialize()
    {
        $this->setSchema("ticket");
        $this->setSource("orders_payment_auditing");
        $this->belongsTo('id_order', 'Orders', 'id', ['alias' => 'Orders']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'orders_payment_auditing';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return OrdersPaymentAuditing[]|OrdersPaymentAuditing|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return OrdersPaymentAuditing|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
