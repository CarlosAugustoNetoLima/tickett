<?php

class Identifier extends \Phalcon\Mvc\Model
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
    public $code;

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
    public $id_product_type;

    /**
     *
     * @var integer
     */
    public $id_lot;

    /**
     *
     * @var double
     */
    public $price;

    /**
     *
     * @var double
     */
    public $fee;

    /**
     *
     * @var integer
     */
    public $quantity;

    /**
     *
     * @var integer
     */
    public $created_by;

    /**
     *
     * @var string
     */
    public $description;

    /**
     *
     * @var integer
     */
    public $id_sale;

    /**
     *
     * @var string
     */
    public $printed_at;

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
        $this->setSource("identifier");
        $this->hasMany('id', 'Sales', 'id_identifier', ['alias' => 'Sales']);
        $this->belongsTo('id_event', 'Events', 'id', ['alias' => 'Events']);
        $this->belongsTo('id_product', 'Products', 'id', ['alias' => 'Products']);
        $this->belongsTo('id_product_type', 'ProductsTypes', 'id', ['alias' => 'ProductsTypes']);
        $this->belongsTo('created_by', 'Users', 'id', ['alias' => 'Users']);
        $this->belongsTo('id_sale', 'Sales', 'id', ['alias' => 'Sales']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'identifier';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return Identifier[]|Identifier|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return Identifier|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
