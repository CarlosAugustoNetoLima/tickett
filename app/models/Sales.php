<?php

class Sales extends \Phalcon\Mvc\Model
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
    public $id_event;

    /**
     *
     * @var integer
     */
    public $id_customer;

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
    public $id_payment_type;

    /**
     *
     * @var integer
     */
    public $id_delivery_type;

    /**
     *
     * @var double
     */
    public $value_total;

    /**
     *
     * @var double
     */
    public $value_product;

    /**
     *
     * @var double
     */
    public $value_product_tax;

    /**
     *
     * @var double
     */
    public $value_fee;

    /**
     *
     * @var double
     */
    public $value_fee_tax;

    /**
     *
     * @var double
     */
    public $value_fee_org;

    /**
     *
     * @var double
     */
    public $value_fee_org_tax;

    /**
     *
     * @var double
     */
    public $value_interest;

    /**
     *
     * @var double
     */
    public $value_interest_tax;

    /**
     *
     * @var double
     */
    public $value_delivery;

    /**
     *
     * @var double
     */
    public $value_delivery_tax;

    /**
     *
     * @var double
     */
    public $value_discount;

    /**
     *
     * @var integer
     */
    public $installments;

    /**
     *
     * @var integer
     */
    public $status;

    /**
     *
     * @var integer
     */
    public $id_identifier;

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
        $this->setSource("sales");
        $this->hasMany('id', 'Identifier', 'id_sale', ['alias' => 'Identifier']);
        $this->hasMany('id', 'OrderSale', 'id_sale', ['alias' => 'OrderSale']);
        $this->hasMany('id', 'SalesCancellation', 'id_sale', ['alias' => 'SalesCancellation']);
        $this->hasMany('id', 'SalesItems', 'id_sale', ['alias' => 'SalesItems']);
        $this->hasMany('id', 'SalesPayment', 'id_sale', ['alias' => 'SalesPayment']);
        $this->belongsTo('id_delivery_type', 'DeliveryTypes', 'id', ['alias' => 'DeliveryTypes']);
        $this->belongsTo('id_payment_type', 'PaymentTypes', 'id', ['alias' => 'PaymentTypes']);
        $this->belongsTo('id_sale_point', 'SalesPoints', 'id', ['alias' => 'SalesPoints']);
        $this->belongsTo('id_sale_terminal', 'SalesTerminal', 'id', ['alias' => 'SalesTerminal']);
        $this->belongsTo('id_customer', 'Customers', 'id', ['alias' => 'Customers']);
        $this->belongsTo('status', 'SalesStatus', 'id', ['alias' => 'SalesStatus']);
        $this->belongsTo('id_event', 'Events', 'id', ['alias' => 'Events']);
        $this->belongsTo('id_order', 'Orders', 'id', ['alias' => 'Orders']);
        $this->belongsTo('id_identifier', 'Identifier', 'id', ['alias' => 'Identifier']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'sales';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return Sales[]|Sales|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return Sales|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
