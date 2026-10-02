<?php

class HelpdeskAnswers extends \Phalcon\Mvc\Model
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
    public $id_helpdesk;

    /**
     *
     * @var string
     */
    public $author;

    /**
     *
     * @var integer
     */
    public $admin;

    /**
     *
     * @var string
     */
    public $message;

    /**
     *
     * @var string
     */
    public $ip;

    /**
     *
     * @var string
     */
    public $session;

    /**
     *
     * @var string
     */
    public $agent;

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
        $this->setSource("helpdesk_answers");
        $this->belongsTo('id_helpdesk', 'HelpdeskOpening', 'id', ['alias' => 'HelpdeskOpening']);
        $this->belongsTo('admin', 'Admins', 'id', ['alias' => 'Admins']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'helpdesk_answers';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return HelpdeskAnswers[]|HelpdeskAnswers|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return HelpdeskAnswers|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
