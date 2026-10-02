<?php

class Users extends \Phalcon\Mvc\Model
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
    public $email;

    /**
     *
     * @var string
     */
    public $password;

    /**
     *
     * @var string
     */
    public $push_subscriber_id;

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
        $this->setSource("users");
        $this->hasMany('id', 'LogSendPush', 'id_user', ['alias' => 'LogSendPush']);
        $this->hasMany('id', 'Accounts', 'created_by', ['alias' => 'Accounts']);
        $this->hasMany('id', 'EventsTransfers', 'request_by', ['alias' => 'EventsTransfers']);
        $this->hasMany('id', 'Identifier', 'created_by', ['alias' => 'Identifier']);
        $this->hasMany('id', 'TicketLog', 'id_user', ['alias' => 'TicketLog']);
        $this->hasMany('id', 'UsersEvents', 'id_user', ['alias' => 'UsersEvents']);
        $this->hasMany('id', 'UsersOrganizers', 'id_user', ['alias' => 'UsersOrganizers']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'users';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return Users[]|Users|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return Users|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
