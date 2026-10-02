<?php

class ProductsGroups extends \Phalcon\Mvc\Model
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
        $this->setSource("products_groups");
        $this->hasMany('id', 'ProductsGroupsTypes', 'id_product_group', ['alias' => 'ProductsGroupsTypes']);
        $this->hasMany('id', 'ProductsSalesLimit', 'id_product_group', ['alias' => 'ProductsSalesLimit']);
        $this->hasMany('id', 'ProductsTypeGroups', 'id_product_group', ['alias' => 'ProductsTypeGroups']);
        $this->belongsTo('id_event', 'Events', 'id', ['alias' => 'Events']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'products_groups';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return ProductsGroups[]|ProductsGroups|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return ProductsGroups|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
