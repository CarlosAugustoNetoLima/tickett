<?php

class EventsCopy extends \Phalcon\Mvc\Model
{

    /**
     *
     * @var integer
     * @Column(type="integer", length=11, nullable=false)
     */
    public $id;

    /**
     *
     * @var string
     * @Column(type="string", length=200, nullable=true)
     */
    public $name;

    /**
     *
     * @var string
     * @Column(type="string", length=200, nullable=true)
     */
    public $ticket_sub_name;

    /**
     *
     * @var integer
     * @Column(type="integer", length=11, nullable=true)
     */
    public $id_place;

    /**
     *
     * @var integer
     * @Column(type="integer", length=11, nullable=true)
     */
    public $id_city;

    /**
     *
     * @var integer
     * @Column(type="integer", length=11, nullable=true)
     */
    public $id_region;

    /**
     *
     * @var integer
     * @Column(type="integer", length=11, nullable=true)
     */
    public $id_organizer;

    /**
     *
     * @var string
     * @Column(type="string", nullable=true)
     */
    public $date_start;

    /**
     *
     * @var string
     * @Column(type="string", nullable=true)
     */
    public $date_opening;

    /**
     *
     * @var string
     * @Column(type="string", nullable=true)
     */
    public $date_sales_start;

    /**
     *
     * @var string
     * @Column(type="string", nullable=true)
     */
    public $date_sales_end;

    /**
     *
     * @var string
     * @Column(type="string", nullable=true)
     */
    public $resume;

    /**
     *
     * @var string
     * @Column(type="string", nullable=true)
     */
    public $description;

    /**
     *
     * @var string
     * @Column(type="string", nullable=true)
     */
    public $instructions;

    /**
     *
     * @var string
     * @Column(type="string", length=200, nullable=true)
     */
    public $slug;

    /**
     *
     * @var string
     * @Column(type="string", length=255, nullable=true)
     */
    public $logo;

    /**
     *
     * @var string
     * @Column(type="string", length=255, nullable=true)
     */
    public $logo_pos;

    /**
     *
     * @var integer
     * @Column(type="integer", length=11, nullable=true)
     */
    public $visit;

    /**
     *
     * @var string
     * @Column(type="string", nullable=false)
     */
    public $created_at;

    /**
     *
     * @var string
     * @Column(type="string", nullable=true)
     */
    public $updated_at;

    /**
     * Initialize method for model.
     */
    public function initialize()
    {
        $this->setSchema("ticket");
        $this->setSource("events_copy");
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'events_copy';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return EventsCopy[]|EventsCopy|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return EventsCopy|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
