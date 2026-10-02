<?php

class Places extends \Phalcon\Mvc\Model
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
    public $location;

    /**
     *
     * @var string
     */
    public $description;

    /**
     *
     * @var integer
     */
    public $id_city;

    /**
     *
     * @var integer
     */
    public $id_region;

    /**
     *
     * @var integer
     */
    public $id_country;

    /**
     *
     * @var string
     */
    public $zipcode;

    /**
     *
     * @var string
     */
    public $gps;

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
        $this->setSource("places");
        $this->hasMany('id', 'Events', 'id_place', ['alias' => 'Events']);
        $this->hasMany('id', 'PlacesMaps', 'id_place', ['alias' => 'PlacesMaps']);
        $this->belongsTo('id_city', 'Cities', 'id', ['alias' => 'Cities']);
        $this->belongsTo('id_country', 'Countries', 'id', ['alias' => 'Countries']);
        $this->belongsTo('id_region', 'Regions', 'id', ['alias' => 'Regions']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'places';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return Places[]|Places|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return Places|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
