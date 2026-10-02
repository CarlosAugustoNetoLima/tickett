<?php

class ProductsSeats extends \Phalcon\Mvc\Model
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
    public $id_map;

    /**
     *
     * @var integer
     */
    public $id_map_sector;

    /**
     *
     * @var integer
     */
    public $id_seat;

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
    public $info;

    /**
     *
     * @var string
     */
    public $type;

    /**
     *
     * @var string
     */
    public $salable;

    /**
     *
     * @var string
     */
    public $row;

    /**
     *
     * @var string
     */
    public $seat;

    /**
     *
     * @var string
     */
    public $label;

    /**
     *
     * @var string
     */
    public $left;

    /**
     *
     * @var string
     */
    public $top;

    /**
     *
     * @var string
     */
    public $reserved_by;

    /**
     *
     * @var string
     */
    public $reserved_at;

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
        $this->setSource("products_seats");
        $this->hasMany('id', 'SalesItems', 'id_product_seat', ['alias' => 'SalesItems']);
        $this->belongsTo('id_map', 'Maps', 'id', ['alias' => 'Maps']);
        $this->belongsTo('id_map_sector', 'MapsSector', 'id', ['alias' => 'MapsSector']);
        $this->belongsTo('id_event', 'Events', 'id', ['alias' => 'Events']);
        $this->belongsTo('id_product', 'Products', 'id', ['alias' => 'Products']);
        $this->belongsTo('ticket', 'SalesItems', 'ticket', ['alias' => 'SalesItems']);
        $this->belongsTo('id_seat', 'MapsSeats', 'id', ['alias' => 'MapsSeats']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'products_seats';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return ProductsSeats[]|ProductsSeats|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return ProductsSeats|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
