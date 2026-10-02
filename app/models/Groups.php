<?php

class Groups extends \Phalcon\Mvc\Model
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
    public $ticket_sub_name;

    /**
     *
     * @var string
     */
    public $label_date;

    /**
     *
     * @var integer
     */
    public $id_place;

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
     * @var string
     */
    public $date_start;

    /**
     *
     * @var string
     */
    public $date_opening;

    /**
     *
     * @var string
     */
    public $date_sales_start;

    /**
     *
     * @var string
     */
    public $date_sales_end;

    /**
     *
     * @var string
     */
    public $slug;

    /**
     *
     * @var string
     */
    public $image;

    /**
     *
     * @var integer
     */
    public $visit;

    /**
     *
     * @var integer
     */
    public $featured_premium;

    /**
     *
     * @var integer
     */
    public $featured;

    /**
     *
     * @var string
     */
    public $display_in_cover;

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
        $this->setSource("groups");
        $this->hasMany('id', 'EventsGroups', 'id_group', ['alias' => 'EventsGroups']);
        $this->belongsTo('id_city', 'Cities', 'id', ['alias' => 'Cities']);
        $this->belongsTo('id_region', 'Regions', 'id', ['alias' => 'Regions']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'groups';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return Groups[]|Groups|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return Groups|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
