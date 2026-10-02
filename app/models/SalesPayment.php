<?php

class SalesPayment extends \Phalcon\Mvc\Model
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
    public $id_sale;

    /**
     *
     * @var integer
     */
    public $id_payment;

    /**
     *
     * @var double
     */
    public $amount;

    /**
     *
     * @var integer
     */
    public $id_payment_type;

    /**
     *
     * @var string
     */
    public $expiration_date;

    /**
     *
     * @var integer
     */
    public $id_cc;

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
        $this->setSource("sales_payment");
        $this->belongsTo('id_sale', 'Sales', 'id', ['alias' => 'Sales']);
        $this->belongsTo('id_payment_type', 'PaymentTypes', 'id', ['alias' => 'PaymentTypes']);
        $this->belongsTo('id_payment', 'Payments', 'id', ['alias' => 'Payments']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'sales_payment';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return SalesPayment[]|SalesPayment|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return SalesPayment|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
