<?php

class ProductsSalesLimit extends \Phalcon\Mvc\Model
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
    public $id_product_group;

    /**
     *
     * @var integer
     */
    public $id_product_type;

    /**
     *
     * @var integer
     */
    public $id_sale_point;

    /**
     *
     * @var integer
     */
    public $product_lot;

    /**
     *
     * @var integer
     */
    public $sales_limit;

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
        $this->setSource("products_sales_limit");
        $this->belongsTo('id_product', 'Products', 'id', ['alias' => 'Products']);
        $this->belongsTo('id_product_group', 'ProductsGroups', 'id', ['alias' => 'ProductsGroups']);
        $this->belongsTo('id_product_type', 'ProductsTypes', 'id', ['alias' => 'ProductsTypes']);
        $this->belongsTo('id_sale_point', 'SalesPoints', 'id', ['alias' => 'SalesPoints']);
        $this->belongsTo('id_event', 'Events', 'id', ['alias' => 'Events']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'products_sales_limit';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return ProductsSalesLimit[]|ProductsSalesLimit|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return ProductsSalesLimit|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
