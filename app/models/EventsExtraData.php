<?php

class EventsExtraData extends \Phalcon\Mvc\Model
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
    public $id_extra_data;

    /**
     *
     * @var integer
     */
    public $limit_order;

    /**
     *
     * @var integer
     */
    public $limit_customer;

    /**
     *
     * @var integer
     */
    public $editable;

    /**
     *
     * @var string
     */
    public $description;

    /**
     *
     * @var string
     */
    public $required_start;

    /**
     *
     * @var string
     */
    public $required_end;

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
        $this->setSource("events_extra_data");
        $this->belongsTo('id_event', 'Events', 'id', ['alias' => 'Events']);
        $this->belongsTo('id_product', 'Products', 'id', ['alias' => 'Products']);
        $this->belongsTo('id_product_type', 'ProductsTypes', 'id', ['alias' => 'ProductsTypes']);
        $this->belongsTo('id_extra_data', 'ExtraData', 'id', ['alias' => 'ExtraData']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'events_extra_data';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return EventsExtraData[]|EventsExtraData|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return EventsExtraData|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
