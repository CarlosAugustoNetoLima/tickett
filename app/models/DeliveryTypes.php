<?php

class DeliveryTypes extends \Phalcon\Mvc\Model
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
        $this->setSource("delivery_types");
        $this->hasMany('id', 'EventsDeliveries', 'id_delivery_type', ['alias' => 'EventsDeliveries']);
        $this->hasMany('id', 'EventsDeliveriesAntiga', 'id_delivery_type', ['alias' => 'EventsDeliveriesAntiga']);
        $this->hasMany('id', 'EventsDeliveriesTerminal', 'id_delivery_type', ['alias' => 'EventsDeliveriesTerminal']);
        $this->hasMany('id', 'Sales', 'id_delivery_type', ['alias' => 'Sales']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'delivery_types';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return DeliveryTypes[]|DeliveryTypes|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return DeliveryTypes|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
