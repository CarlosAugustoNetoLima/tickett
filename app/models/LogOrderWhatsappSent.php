<?php

class LogOrderWhatsappSent extends \Phalcon\Mvc\Model
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
    public $id_order;

    /**
     *
     * @var string
     */
    public $whatsapp_to;

    /**
     *
     * @var string
     */
    public $message_id;

    /**
     *
     * @var string
     */
    public $obs;

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
        $this->setSource("_log_order_whatsapp_sent");
        $this->belongsTo('id_order', 'Orders', 'id', ['alias' => 'Orders']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return '_log_order_whatsapp_sent';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return LogOrderWhatsappSent[]|LogOrderWhatsappSent|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return LogOrderWhatsappSent|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
