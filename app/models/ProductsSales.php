<?php

class ProductsSales extends \Phalcon\Mvc\Model
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
    public $id_product;

    /**
     *
     * @var integer
     */
    public $id_type;

    /**
     *
     * @var integer
     */
    public $id_sale_point;

    /**
     *
     * @var integer
     */
    public $id_fee;

    /**
     *
     * @var integer
     */
    public $id_fee_org;

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
        $this->setSource("products_sales");
        $this->belongsTo('id_event', 'Events', 'id', ['alias' => 'Events']);
        $this->belongsTo('id_fee', 'Fees', 'id', ['alias' => 'Fees']);
        $this->belongsTo('id_fee_org', 'FeesOrg', 'id', ['alias' => 'FeesOrg']);
        $this->belongsTo('id_product', 'Products', 'id', ['alias' => 'Products']);
        $this->belongsTo('id_type', 'ProductsTypes', 'id', ['alias' => 'ProductsTypes']);
        $this->belongsTo('id_sale_point', 'SalesPoints', 'id', ['alias' => 'SalesPoints']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'products_sales';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return ProductsSales[]|ProductsSales|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return ProductsSales|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
