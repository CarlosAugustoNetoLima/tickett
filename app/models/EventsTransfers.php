<?php

class EventsTransfers extends \Phalcon\Mvc\Model
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
    public $status;

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
     * @var string
     */
    public $recipient;

    /**
     *
     * @var string
     */
    public $account;

    /**
     *
     * @var double
     */
    public $total_value;

    /**
     *
     * @var string
     */
    public $transfer_date;

    /**
     *
     * @var string
     */
    public $file;

    /**
     *
     * @var string
     */
    public $description;

    /**
     *
     * @var integer
     */
    public $request_by;

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
        $this->setSource("events_transfers");
        $this->belongsTo('id_event', 'Events', 'id', ['alias' => 'Events']);
        $this->belongsTo('request_by', 'Users', 'id', ['alias' => 'Users']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'events_transfers';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return EventsTransfers[]|EventsTransfers|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return EventsTransfers|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
