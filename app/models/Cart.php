<?php

class Cart extends \Phalcon\Mvc\Model
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
    public $id_event;

    /**
     *
     * @var integer
     */
    public $id_product;

    /**
     *
     * @var integer
     */
    public $id_product_type;

    /**
     *
     * @var integer
     */
    public $id_delivery_type;

    /**
     *
     * @var integer
     */
    public $id_payment_type;

    /**
     *
     * @var integer
     */
    public $product_lot;

    /**
     *
     * @var integer
     */
    public $qty;

    /**
     *
     * @var double
     */
    public $price;

    /**
     *
     * @var double
     */
    public $price_tax;

    /**
     *
     * @var double
     */
    public $fee;

    /**
     *
     * @var double
     */
    public $fee_tax;

    /**
     *
     * @var double
     */
    public $fee_org;

    /**
     *
     * @var double
     */
    public $fee_org_tax;

    /**
     *
     * @var string
     */
    public $customer_session;

    /**
     *
     * @var string
     */
    public $customer_ip;

    /**
     *
     * @var string
     */
    public $customer_agent;

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
        $this->setSource("cart");
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'cart';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return Cart[]|Cart|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return Cart|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
