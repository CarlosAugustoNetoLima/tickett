<?php

class MapsSeats extends \Phalcon\Mvc\Model
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
        $this->setSource("maps_seats");
        $this->hasMany('id', 'ProductsSeats', 'id_seat', ['alias' => 'ProductsSeats']);
        $this->belongsTo('id_map', 'Maps', 'id', ['alias' => 'Maps']);
        $this->belongsTo('id_map_sector', 'MapsSector', 'id', ['alias' => 'MapsSector']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'maps_seats';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return MapsSeats[]|MapsSeats|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return MapsSeats|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
