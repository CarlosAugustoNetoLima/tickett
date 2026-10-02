<?php

class SalesPoints extends \Phalcon\Mvc\Model
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
     * @var integer
     */
    public $id_organizer;

    /**
     *
     * @var string
     */
    public $description;

    /**
     *
     * @var string
     */
    public $information;

    /**
     *
     * @var integer
     */
    public $default_fee;

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
        $this->setSource("sales_points");
        $this->hasMany('id', 'CheckoutEmbedded', 'id_sale_point', ['alias' => 'CheckoutEmbedded']);
        $this->hasMany('id', 'EventsDeliveries', 'id_sale_point', ['alias' => 'EventsDeliveries']);
        $this->hasMany('id', 'EventsPayments', 'id_sale_point', ['alias' => 'EventsPayments']);
        $this->hasMany('id', 'Orders', 'id_sale_point', ['alias' => 'Orders']);
        $this->hasMany('id', 'ProductsSales', 'id_sale_point', ['alias' => 'ProductsSales']);
        $this->hasMany('id', 'ProductsSalesLimit', 'id_sale_point', ['alias' => 'ProductsSalesLimit']);
        $this->hasMany('id', 'Sales', 'id_sale_point', ['alias' => 'Sales']);
        $this->hasMany('id', 'SalesPointsPaymentType', 'id_sale_point', ['alias' => 'SalesPointsPaymentType']);
        $this->hasMany('id', 'SalesTerminal', 'id_sales_points', ['alias' => 'SalesTerminal']);
        $this->hasMany('id', 'TerminalWithdrawal', 'id_sale_point', ['alias' => 'TerminalWithdrawal']);
        $this->belongsTo('id_organizer', 'Organizers', 'id', ['alias' => 'Organizers']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'sales_points';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return SalesPoints[]|SalesPoints|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return SalesPoints|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
