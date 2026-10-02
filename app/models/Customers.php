<?php

use Phalcon\Validation;
use Phalcon\Validation\Validator\Email as EmailValidator;

class Customers extends \Phalcon\Mvc\Model
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
    public $password;

    /**
     *
     * @var string
     */
    public $email;

    /**
     *
     * @var string
     */
    public $id_number;

    /**
     *
     * @var integer
     */
    public $email_confirmed;

    /**
     *
     * @var string
     */
    public $cell_number;

    /**
     *
     * @var integer
     */
    public $cell_number_confirmed;

    /**
     *
     * @var string
     */
    public $dob;

    /**
     *
     * @var integer
     */
    public $suspect;

    /**
     *
     * @var string
     */
    public $information;

    /**
     *
     * @var string
     */
    public $zipcode;

    /**
     *
     * @var string
     */
    public $address_1;

    /**
     *
     * @var string
     */
    public $address_2;

    /**
     *
     * @var string
     */
    public $city;

    /**
     *
     * @var string
     */
    public $region;

    /**
     *
     * @var string
     */
    public $country;

    /**
     *
     * @var integer
     */
    public $verify;

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
     *
     * @var string
     */
    public $face_picture;

    /**
     *
     * @var string
     */
    public $doc_picture;

    /**
     * Validations and business logic
     *
     * @return boolean
     */
    public function validation()
    {
        $validator = new Validation();

        $validator->add(
            'email',
            new EmailValidator(
                [
                    'model'   => $this,
                    'message' => 'Please enter a correct email address',
                ]
            )
        );

        return $this->validate($validator);
    }

    /**
     * Initialize method for model.
     */
    public function initialize()
    {
        $this->setSchema("ticket");
        $this->setSource("customers");
        $this->hasMany('id', 'CustomerBillingAddress', 'id_customer', ['alias' => 'CustomerBillingAddress']);
        $this->hasMany('id', 'CustomersVerify', 'id_customer', ['alias' => 'CustomersVerify']);
        $this->hasMany('id', 'Orders', 'id_customer', ['alias' => 'Orders']);
        $this->hasMany('id', 'Sales', 'id_customer', ['alias' => 'Sales']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'customers';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return Customers[]|Customers|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return Customers|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
