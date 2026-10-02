<?php

class TerminalWithdrawal extends \Phalcon\Mvc\Model
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
    public $id_sale_point;

    /**
     *
     * @var integer
     */
    public $id_sale_terminal;

    /**
     *
     * @var integer
     */
    public $id_payment_type;

    /**
     *
     * @var double
     */
    public $value_total;

    /**
     *
     * @var double
     */
    public $value_product;

    /**
     *
     * @var double
     */
    public $value_product_tax;

    /**
     *
     * @var double
     */
    public $value_fee;

    /**
     *
     * @var double
     */
    public $value_fee_tax;

    /**
     *
     * @var double
     */
    public $value_fee_org;

    /**
     *
     * @var double
     */
    public $value_fee_org_tax;

    /**
     *
     * @var double
     */
    public $value_interest;

    /**
     *
     * @var double
     */
    public $value_interest_tax;

    /**
     *
     * @var double
     */
    public $value_delivery;

    /**
     *
     * @var double
     */
    public $value_delivery_tax;

    /**
     *
     * @var integer
     */
    public $status;

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
        $this->setSource("terminal_withdrawal");
        $this->belongsTo('id_event', 'Events', 'id', ['alias' => 'Events']);
        $this->belongsTo('id_sale_point', 'SalesPoints', 'id', ['alias' => 'SalesPoints']);
        $this->belongsTo('id_sale_terminal', 'SalesTerminal', 'id', ['alias' => 'SalesTerminal']);
        $this->belongsTo('id_payment_type', 'PaymentTypes', 'id', ['alias' => 'PaymentTypes']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'terminal_withdrawal';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return TerminalWithdrawal[]|TerminalWithdrawal|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return TerminalWithdrawal|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
