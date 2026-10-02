<?php

class EventsFinances extends \Phalcon\Mvc\Model
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
     * @var string
     */
    public $type;

    /**
     *
     * @var integer
     */
    public $qty;

    /**
     *
     * @var double
     */
    public $unitary_value;

    /**
     *
     * @var double
     */
    public $total_value;

    /**
     *
     * @var string
     */
    public $description;

    /**
     *
     * @var string
     */
    public $created_at;

    /**
     * Initialize method for model.
     */
    public function initialize()
    {
        $this->setSchema("ticket");
        $this->setSource("events_finances");
        $this->belongsTo('id_event', 'Events', 'id', ['alias' => 'Events']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'events_finances';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return EventsFinances[]|EventsFinances|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return EventsFinances|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
