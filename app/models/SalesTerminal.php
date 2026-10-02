<?php


class SalesTerminal extends \Phalcon\Mvc\Model
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
    public $id_sales_points;

    /**
     *
     * @var string
     */
    public $name;

    /**
     *
     * @var string
     */
    public $description;

    /**
     *
     * @var string
     */
    public $password;

    /**
     *
     * @var string
     */
    public $email;

    /**
     *
     * @var string
     */
    public $serial;

    /**
     *
     * @var string
     */
    public $token_embedded;

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
        $this->setSource("sales_terminal");
        $this->hasMany('id', 'CheckoutEmbedded', 'id_sale_terminal', ['alias' => 'CheckoutEmbedded']);
        $this->hasMany('id', 'EventsDeliveriesTerminal', 'id_terminal', ['alias' => 'EventsDeliveriesTerminal']);
        $this->hasMany('id', 'Orders', 'id_sale_terminal', ['alias' => 'Orders']);
        $this->hasMany('id', 'Sales', 'id_sale_terminal', ['alias' => 'Sales']);
        $this->hasMany('id', 'TerminalWithdrawal', 'id_sale_terminal', ['alias' => 'TerminalWithdrawal']);
        $this->belongsTo('id_sales_points', 'SalesPoints', 'id', ['alias' => 'SalesPoints']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'sales_terminal';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return SalesTerminal[]|SalesTerminal|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return SalesTerminal|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
