<?php

class MapsSector extends \Phalcon\Mvc\Model
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
     * @var string
     */
    public $name;

    /**
     *
     * @var string
     */
    public $img_or_html;

    /**
     *
     * @var string
     */
    public $img;

    /**
     *
     * @var string
     */
    public $html;

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
        $this->setSource("maps_sector");
        $this->hasMany('id', 'MapsSeats', 'id_map_sector', ['alias' => 'MapsSeats']);
        $this->hasMany('id', 'Products', 'id_maps_sector', ['alias' => 'Products']);
        $this->hasMany('id', 'Products', 'id_maps_sector', ['alias' => 'Products']);
        $this->hasMany('id', 'ProductsSeats', 'id_map_sector', ['alias' => 'ProductsSeats']);
        $this->belongsTo('id_map', 'Maps', 'id', ['alias' => 'Maps']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'maps_sector';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return MapsSector[]|MapsSector|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return MapsSector|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
