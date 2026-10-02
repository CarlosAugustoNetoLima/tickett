<?php

class PaymentTypes extends \Phalcon\Mvc\Model
{

    /**
     *
     * @var integer
     */
    public $id;

    /**
     *
     * @var string
     */
    public $name;

    /**
     *
     * @var double
     */
    public $default_cust;

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
        $this->setSource("payment_types");
        $this->hasMany('id', 'EventsPayments', 'id_payment_types', ['alias' => 'EventsPayments']);
        $this->hasMany('id', 'Orders', 'id_payment_type', ['alias' => 'Orders']);
        $this->hasMany('id', 'OrdersActive', 'id_payment_type', ['alias' => 'OrdersActive']);
        $this->hasMany('id', 'OrdersPayment', 'id_payment_type', ['alias' => 'OrdersPayment']);
        $this->hasMany('id', 'Payments', 'id_payment_type', ['alias' => 'Payments']);
        $this->hasMany('id', 'Sales', 'id_payment_type', ['alias' => 'Sales']);
        $this->hasMany('id', 'SalesPayment', 'id_payment_type', ['alias' => 'SalesPayment']);
        $this->hasMany('id', 'SalesPointsPaymentType', 'id_payment_type', ['alias' => 'SalesPointsPaymentType']);
        $this->hasMany('id', 'TerminalWithdrawal', 'id_payment_type', ['alias' => 'TerminalWithdrawal']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'payment_types';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return PaymentTypes[]|PaymentTypes|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return PaymentTypes|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
