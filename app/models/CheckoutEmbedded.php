<?php

class CheckoutEmbedded extends \Phalcon\Mvc\Model
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
    public $token;

    /**
     *
     * @var integer
     */
    public $id_sale_point;

    /**
     *
     * @var integer
     */
    public $id_sale_terminal;

    /**
     *
     * @var string
     */
    public $config;

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
        $this->setSource("checkout_embedded");
        $this->belongsTo('id_sale_point', 'SalesPoints', 'id', ['alias' => 'SalesPoints']);
        $this->belongsTo('id_sale_terminal', 'SalesTerminal', 'id', ['alias' => 'SalesTerminal']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'checkout_embedded';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return CheckoutEmbedded[]|CheckoutEmbedded|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return CheckoutEmbedded|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
