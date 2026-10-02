<?php

class FeeOrgValues extends \Phalcon\Mvc\Model
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
        $this->setSource("fee_org_values");
        $this->belongsTo('id_fee', 'FeesOrg', 'id', ['alias' => 'FeesOrg']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'fee_org_values';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return FeeOrgValues[]|FeeOrgValues|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return FeeOrgValues|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
