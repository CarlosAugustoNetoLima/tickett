<?php

class ProductsTypes extends \Phalcon\Mvc\Model
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
        $this->setSource("products_types");
        $this->hasMany('id', 'CouponsProducts', 'id_products_types', ['alias' => 'CouponsProducts']);
        $this->hasMany('id', 'EventsExtraData', 'id_product_type', ['alias' => 'EventsExtraData']);
        $this->hasMany('id', 'Identifier', 'id_product_type', ['alias' => 'Identifier']);
        $this->hasMany('id', 'ProductsGroupsTypes', 'id_type', ['alias' => 'ProductsGroupsTypes']);
        $this->hasMany('id', 'ProductsLots', 'id_type', ['alias' => 'ProductsLots']);
        $this->hasMany('id', 'ProductsSales', 'id_type', ['alias' => 'ProductsSales']);
        $this->hasMany('id', 'ProductsSalesLimit', 'id_product_type', ['alias' => 'ProductsSalesLimit']);
        $this->hasMany('id', 'ProductsTypeGroups', 'id_product_type', ['alias' => 'ProductsTypeGroups']);
        $this->hasMany('id', 'SalesItems', 'id_product_type', ['alias' => 'SalesItems']);
        $this->hasMany('id', 'TicketStock', 'id_product_type', ['alias' => 'TicketStock']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'products_types';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return ProductsTypes[]|ProductsTypes|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return ProductsTypes|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
