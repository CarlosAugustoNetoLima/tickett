<?php

class LogOrderProccessPayment extends \Phalcon\Mvc\Model
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
    public $id_orders_payment;

    /**
     *
     * @var string
     */
    public $response;

    /**
     *
     * @var string
     */
    public $obs;

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
        $this->setSource("_log_order_proccess_payment");
        $this->belongsTo('id_order', 'Orders', 'id', ['alias' => 'Orders']);
        $this->belongsTo('id_orders_payment', 'OrdersPayment', 'id', ['alias' => 'OrdersPayment']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return '_log_order_proccess_payment';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return LogOrderProccessPayment[]|LogOrderProccessPayment|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return LogOrderProccessPayment|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
