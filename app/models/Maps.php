<?php

class Maps extends \Phalcon\Mvc\Model
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
        $this->setSource("maps");
        $this->hasMany('id', 'MapsSeats', 'id_map', ['alias' => 'MapsSeats']);
        $this->hasMany('id', 'MapsSector', 'id_map', ['alias' => 'MapsSector']);
        $this->hasMany('id', 'PlacesMaps', 'id_map', ['alias' => 'PlacesMaps']);
        $this->hasMany('id', 'ProductsSeats', 'id_map', ['alias' => 'ProductsSeats']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'maps';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return Maps[]|Maps|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return Maps|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
