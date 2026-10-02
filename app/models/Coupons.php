<?php

class Coupons extends \Phalcon\Mvc\Model
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
    public $start_at;

    /**
     *
     * @var string
     */
    public $end_at;

    /**
     *
     * @var double
     */
    public $discount_fixed;

    /**
     *
     * @var double
     */
    public $discount_percentage;

    /**
     *
     * @var integer
     */
    public $free_tax;

    /**
     *
     * @var integer
     */
    public $limit_general;

    /**
     *
     * @var integer
     */
    public $limit_personal;

    /**
     *
     * @var integer
     */
    public $active;

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
        $this->setSource("coupons");
        $this->hasMany('id', 'CouponsCodes', 'id_coupon', ['alias' => 'CouponsCodes']);
        $this->hasMany('id', 'CouponsProducts', 'id_coupons', ['alias' => 'CouponsProducts']);
        $this->belongsTo('id_event', 'Events', 'id', ['alias' => 'Events']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'coupons';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return Coupons[]|Coupons|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return Coupons|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
