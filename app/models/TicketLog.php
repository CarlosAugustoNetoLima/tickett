<?php

class TicketLog extends \Phalcon\Mvc\Model
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
    public $ticket;

    /**
     *
     * @var integer
     */
    public $status;

    /**
     *
     * @var string
     */
    public $info;

    /**
     *
     * @var integer
     */
    public $id_admin;

    /**
     *
     * @var integer
     */
    public $id_user;

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
        $this->setSource("ticket_log");
        $this->belongsTo('id_event', 'Events', 'id', ['alias' => 'Events']);
        $this->belongsTo('ticket', 'SalesItems', 'ticket', ['alias' => 'SalesItems']);
        $this->belongsTo('status', 'TicketsStatus', 'id', ['alias' => 'TicketsStatus']);
        $this->belongsTo('id_admin', 'Admins', 'id', ['alias' => 'Admins']);
        $this->belongsTo('id_user', 'Users', 'id', ['alias' => 'Users']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'ticket_log';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return TicketLog[]|TicketLog|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return TicketLog|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
