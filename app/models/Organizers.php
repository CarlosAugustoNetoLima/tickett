<?php

class Organizers extends \Phalcon\Mvc\Model
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
    public $doc;

    /**
     *
     * @var string
     */
    public $slug;

    /**
     *
     * @var string
     */
    public $description;

    /**
     *
     * @var string
     */
    public $information;

    /**
     *
     * @var string
     */
    public $negotiation;

    /**
     *
     * @var string
     */
    public $ticket_system;

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
        $this->setSource("organizers");
        $this->hasMany('id', 'Accounts', 'id_organizer', ['alias' => 'Accounts']);
        $this->hasMany('id', 'Events', 'id_organizer', ['alias' => 'Events']);
        $this->hasMany('id', 'SalesPoints', 'id_organizer', ['alias' => 'SalesPoints']);
        $this->hasMany('id', 'UsersOrganizers', 'id_organizer', ['alias' => 'UsersOrganizers']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'organizers';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return Organizers[]|Organizers|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return Organizers|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
