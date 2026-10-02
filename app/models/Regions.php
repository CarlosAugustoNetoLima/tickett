<?php

class Regions extends \Phalcon\Mvc\Model
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
    public $id_country;

    /**
     *
     * @var string
     */
    public $acronym;

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
        $this->setSource("regions");
        $this->hasMany('id', 'Cities', 'id_region', ['alias' => 'Cities']);
        $this->hasMany('id', 'Events', 'id_region', ['alias' => 'Events']);
        $this->hasMany('id', 'Groups', 'id_region', ['alias' => 'Groups']);
        $this->hasMany('id', 'Places', 'id_region', ['alias' => 'Places']);
        $this->hasMany('id', 'Zipcode', 'id_region', ['alias' => 'Zipcode']);
        $this->belongsTo('id_country', 'Countries', 'id', ['alias' => 'Countries']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'regions';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return Regions[]|Regions|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return Regions|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
