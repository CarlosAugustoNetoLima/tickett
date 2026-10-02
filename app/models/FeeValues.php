<?php

class FeeValues extends \Phalcon\Mvc\Model
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
    public $id_fee;

    /**
     *
     * @var double
     */
    public $start_value;

    /**
     *
     * @var double
     */
    public $end_value;

    /**
     *
     * @var double
     */
    public $duty;

    /**
     *
     * @var integer
     */
    public $type;

    /**
     *
     * @var double
     */
    public $tax;

    /**
     *
     * @var integer
     */
    public $tax_type;

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
        $this->setSource("fee_values");
        $this->belongsTo('id_fee', 'Fees', 'id', ['alias' => 'Fees']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'fee_values';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return FeeValues[]|FeeValues|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return FeeValues|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
