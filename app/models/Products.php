<?php

class Products extends \Phalcon\Mvc\Model
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
    public $id_event;

    /**
     *
     * @var integer
     */
    public $id_genre;

    /**
     *
     * @var string
     */
    public $name;

    /**
     *
     * @var string
     */
    public $description;

    /**
     *
     * @var integer
     */
    public $current_lot;

    /**
     *
     * @var integer
     */
    public $fraction;

    /**
     *
     * @var integer
     */
    public $priority;

    /**
     *
     * @var integer
     */
    public $show_previous_lot;

    /**
     *
     * @var integer
     */
    public $show_next_lot;

    /**
     *
     * @var integer
     */
    public $id_maps_sector;

    /**
     *
     * @var integer
     */
    public $hidden;

    /**
     *
     * @var integer
     */
    public $purchase_limit;

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
        $this->setSource("products");
        $this->hasMany('id', 'CouponsProducts', 'id_products', ['alias' => 'CouponsProducts']);
        $this->hasMany('id', 'EventsExtraData', 'id_product', ['alias' => 'EventsExtraData']);
        $this->hasMany('id', 'Identifier', 'id_product', ['alias' => 'Identifier']);
        $this->hasMany('id', 'ProductsGroupsTypes', 'id_product', ['alias' => 'ProductsGroupsTypes']);
        $this->hasMany('id', 'ProductsLots', 'id_product', ['alias' => 'ProductsLots']);
        $this->hasMany('id', 'ProductsSales', 'id_product', ['alias' => 'ProductsSales']);
        $this->hasMany('id', 'ProductsSalesLimit', 'id_product', ['alias' => 'ProductsSalesLimit']);
        $this->hasMany('id', 'ProductsSeats', 'id_product', ['alias' => 'ProductsSeats']);
        $this->hasMany('id', 'ProductsTypeGroups', 'id_product', ['alias' => 'ProductsTypeGroups']);
        $this->hasMany('id', 'SalesItems', 'id_product', ['alias' => 'SalesItems']);
        $this->hasMany('id', 'TicketStock', 'id_product', ['alias' => 'TicketStock']);
        $this->belongsTo('id_event', 'Events', 'id', ['alias' => 'Events']);
        $this->belongsTo('id_genre', 'ProductsGenres', 'id', ['alias' => 'ProductsGenres']);
        $this->belongsTo('id_maps_sector', 'MapsSector', 'id', ['alias' => 'MapsSector']);
        $this->belongsTo('id_maps_sector', 'MapsSector', 'id', ['alias' => 'MapsSector']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'products';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return Products[]|Products|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return Products|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
