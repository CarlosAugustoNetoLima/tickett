<?php

class CustomersVerify extends \Phalcon\Mvc\Model
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
    public $id_helpdesk;

    /**
     *
     * @var string
     */
    public $name;

    /**
     *
     * @var string
     */
    public $base64;

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
        $this->setSource("customers_verify");
        $this->belongsTo('id_customer', 'Customers', 'id', ['alias' => 'Customers']);
        $this->belongsTo('id_helpdesk', 'HelpdeskOpening', 'id', ['alias' => 'HelpdeskOpening']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'customers_verify';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return CustomersVerify[]|CustomersVerify|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return CustomersVerify|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
