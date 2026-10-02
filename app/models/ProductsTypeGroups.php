<?php

class ProductsTypeGroups extends \Phalcon\Mvc\Model
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
    public $id_product_group;

    /**
     *
     * @var integer
     */
    public $id_product;

    /**
     *
     * @var integer
     */
    public $id_product_type;

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
        $this->setSource("products_type_groups");
        $this->belongsTo('id_product_group', 'ProductsGroups', 'id', ['alias' => 'ProductsGroups']);
        $this->belongsTo('id_product', 'Products', 'id', ['alias' => 'Products']);
        $this->belongsTo('id_product_type', 'ProductsTypes', 'id', ['alias' => 'ProductsTypes']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'products_type_groups';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return ProductsTypeGroups[]|ProductsTypeGroups|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return ProductsTypeGroups|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
