<?php

class SalesItems extends \Phalcon\Mvc\Model
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
    public $ticket;

    /**
     *
     * @var integer
     */
    public $status;

    /**
     *
     * @var string
     */
    public $validated;

    /**
     *
     * @var string
     */
    public $validated_at;

    /**
     *
     * @var integer
     */
    public $id_sale;

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
    public $product_lot;

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
    public $value_discount;

    /**
     *
     * @var double
     */
    public $value_discount_tax;

    /**
     *
     * @var integer
     */
    public $id_product_seat;

    /**
     *
     * @var integer
     */
    public $fraction;

    /**
     *
     * @var integer
     */
    public $ticket_sequence;

    /**
     *
     * @var string
     */
    public $swap;

    /**
     *
     * @var string
     */
    public $swap_at;

    /**
     *
     * @var integer
     */
    public $product_sequence;

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
        $this->setSource("sales_items");
        $this->hasMany('ticket', 'ProductsSeats', 'ticket', ['alias' => 'ProductsSeats']);
        $this->hasMany('ticket', 'TicketExtraData', 'ticket', ['alias' => 'TicketExtraData']);
        $this->hasMany('ticket', 'TicketLog', 'ticket', ['alias' => 'TicketLog']);
        $this->belongsTo('id_event', 'Events', 'id', ['alias' => 'Events']);
        $this->belongsTo('id_product', 'Products', 'id', ['alias' => 'Products']);
        $this->belongsTo('id_product_type', 'ProductsTypes', 'id', ['alias' => 'ProductsTypes']);
        $this->belongsTo('id_sale', 'Sales', 'id', ['alias' => 'Sales']);
        $this->belongsTo('id_product_seat', 'ProductsSeats', 'id', ['alias' => 'ProductsSeats']);
        $this->belongsTo('status', 'TicketsStatus', 'id', ['alias' => 'TicketsStatus']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'sales_items';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return SalesItems[]|SalesItems|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return SalesItems|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
