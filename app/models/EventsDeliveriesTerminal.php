<?php

class EventsDeliveriesTerminal extends \Phalcon\Mvc\Model
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
    public $id_terminal;

    /**
     *
     * @var integer
     */
    public $id_delivery_type;

    /**
     *
     * @var double
     */
    public $value;

    /**
     *
     * @var double
     */
    public $value_tax;

    /**
     *
     * @var string
     */
    public $title;

    /**
     *
     * @var string
     */
    public $resume;

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
        $this->setSource("events_deliveries_terminal");
        $this->belongsTo('id_event', 'Events', 'id', ['alias' => 'Events']);
        $this->belongsTo('id_terminal', 'SalesTerminal', 'id', ['alias' => 'SalesTerminal']);
        $this->belongsTo('id_delivery_type', 'DeliveryTypes', 'id', ['alias' => 'DeliveryTypes']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'events_deliveries_terminal';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return EventsDeliveriesTerminal[]|EventsDeliveriesTerminal|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return EventsDeliveriesTerminal|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
