<?php

class EventsPayments extends \Phalcon\Mvc\Model
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
    public $id_payment_types;

    /**
     *
     * @var integer
     */
    public $id_sale_point;

    /**
     *
     * @var integer
     */
    public $qtt_plots;

    /**
     *
     * @var integer
     */
    public $qtt_plots_fee;

    /**
     *
     * @var double
     */
    public $plots_fee;

    /**
     *
     * @var integer
     */
    public $fee_type;

    /**
     *
     * @var double
     */
    public $value_minimum;

    /**
     *
     * @var double
     */
    public $value_maximum;

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
        $this->setSource("events_payments");
        $this->belongsTo('id_event', 'Events', 'id', ['alias' => 'Events']);
        $this->belongsTo('id_sale_point', 'SalesPoints', 'id', ['alias' => 'SalesPoints']);
        $this->belongsTo('id_payment_types', 'PaymentTypes', 'id', ['alias' => 'PaymentTypes']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'events_payments';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return EventsPayments[]|EventsPayments|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return EventsPayments|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
