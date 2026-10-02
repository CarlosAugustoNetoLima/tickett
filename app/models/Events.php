<?php

class Events extends \Phalcon\Mvc\Model
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
    public $ticket_sub_name;

    /**
     *
     * @var string
     */
    public $label_purchase;

    /**
     *
     * @var string
     */
    public $label_date;

    /**
     *
     * @var integer
     */
    public $id_place;

    /**
     *
     * @var integer
     */
    public $id_city;

    /**
     *
     * @var integer
     */
    public $id_region;

    /**
     *
     * @var integer
     */
    public $id_organizer;

    /**
     *
     * @var string
     */
    public $date_start;

    /**
     *
     * @var string
     */
    public $date_opening;

    /**
     *
     * @var string
     */
    public $date_sales_start;

    /**
     *
     * @var string
     */
    public $date_sales_end;

    /**
     *
     * @var string
     */
    public $resume;

    /**
     *
     * @var string
     */
    public $description;

    /**
     *
     * @var string
     */
    public $tags;

    /**
     *
     * @var string
     */
    public $instructions;

    /**
     *
     * @var string
     */
    public $parental_rating;

    /**
     *
     * @var string
     */
    public $slug;

    /**
     *
     * @var string
     */
    public $logo;

    /**
     *
     * @var string
     */
    public $logo_pos;

    /**
     *
     * @var string
     */
    public $map;

    /**
     *
     * @var integer
     */
    public $visit;

    /**
     *
     * @var integer
     */
    public $featured_premium;

    /**
     *
     * @var integer
     */
    public $featured;

    /**
     *
     * @var string
     */
    public $display_in_cover;

    /**
     *
     * @var integer
     */
    public $max_installment_without_interest;

    /**
     *
     * @var integer
     */
    public $max_installment_with_interest;

    /**
     *
     * @var double
     */
    public $interest_rate;

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
    public $antifraud;

    /**
     *
     * @var string
     */
    public $cancellation;

    /**
     *
     * @var integer
     */
    public $saft;

    /**
     *
     * @var string
     */
    public $financial_summary;

    /**
     *
     * @var string
     */
    public $tag_metapixel;

    /**
     *
     * @var string
     */
    public $tag_googletag;

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
        $this->setSource("events");
        $this->hasMany('id', 'LogSendPush', 'id_event', ['alias' => 'LogSendPush']);
        $this->hasMany('id', 'Coupons', 'id_event', ['alias' => 'Coupons']);
        $this->hasMany('id', 'CouponsCodes', 'id_event', ['alias' => 'CouponsCodes']);
        $this->hasMany('id', 'CouponsProducts', 'id_event', ['alias' => 'CouponsProducts']);
        $this->hasMany('id', 'EventsDeliveries', 'id_event', ['alias' => 'EventsDeliveries']);
        $this->hasMany('id', 'EventsDeliveriesTerminal', 'id_event', ['alias' => 'EventsDeliveriesTerminal']);
        $this->hasMany('id', 'EventsExtraData', 'id_event', ['alias' => 'EventsExtraData']);
        $this->hasMany('id', 'EventsFinances', 'id_event', ['alias' => 'EventsFinances']);
        $this->hasMany('id', 'EventsGroups', 'id_event', ['alias' => 'EventsGroups']);
        $this->hasMany('id', 'EventsImages', 'id_event', ['alias' => 'EventsImages']);
        $this->hasMany('id', 'EventsPayments', 'id_event', ['alias' => 'EventsPayments']);
        $this->hasMany('id', 'EventsPerformes', 'id_event', ['alias' => 'EventsPerformes']);
        $this->hasMany('id', 'EventsTransfers', 'id_event', ['alias' => 'EventsTransfers']);
        $this->hasMany('id', 'HelpdeskOpening', 'id_event', ['alias' => 'HelpdeskOpening']);
        $this->hasMany('id', 'Identifier', 'id_event', ['alias' => 'Identifier']);
        $this->hasMany('id', 'Migrations', 'id_event_from', ['alias' => 'Migrations']);
        $this->hasMany('id', 'Migrations', 'id_event_to', ['alias' => 'Migrations']);
        $this->hasMany('id', 'Products', 'id_event', ['alias' => 'Products']);
        $this->hasMany('id', 'ProductsGroups', 'id_event', ['alias' => 'ProductsGroups']);
        $this->hasMany('id', 'ProductsGroupsTypes', 'id_event', ['alias' => 'ProductsGroupsTypes']);
        $this->hasMany('id', 'ProductsLots', 'id_event', ['alias' => 'ProductsLots']);
        $this->hasMany('id', 'ProductsSales', 'id_event', ['alias' => 'ProductsSales']);
        $this->hasMany('id', 'ProductsSalesLimit', 'id_event', ['alias' => 'ProductsSalesLimit']);
        $this->hasMany('id', 'ProductsSeats', 'id_event', ['alias' => 'ProductsSeats']);
        $this->hasMany('id', 'Sales', 'id_event', ['alias' => 'Sales']);
        $this->hasMany('id', 'SalesCancellation', 'id_event', ['alias' => 'SalesCancellation']);
        $this->hasMany('id', 'SalesItems', 'id_event', ['alias' => 'SalesItems']);
        $this->hasMany('id', 'TerminalWithdrawal', 'id_event', ['alias' => 'TerminalWithdrawal']);
        $this->hasMany('id', 'TicketExtraData', 'id_event', ['alias' => 'TicketExtraData']);
        $this->hasMany('id', 'TicketLog', 'id_event', ['alias' => 'TicketLog']);
        $this->hasMany('id', 'TicketStock', 'id_event', ['alias' => 'TicketStock']);
        $this->hasMany('id', 'TicketSwap', 'id_event', ['alias' => 'TicketSwap']);
        $this->hasMany('id', 'TicketValidation', 'id_event', ['alias' => 'TicketValidation']);
        $this->hasMany('id', 'UsersEvents', 'id_event', ['alias' => 'UsersEvents']);
        $this->hasMany('id', 'WaitingList', 'id_event', ['alias' => 'WaitingList']);
        $this->belongsTo('id_city', 'Cities', 'id', ['alias' => 'Cities']);
        $this->belongsTo('id_organizer', 'Organizers', 'id', ['alias' => 'Organizers']);
        $this->belongsTo('id_place', 'Places', 'id', ['alias' => 'Places']);
        $this->belongsTo('id_region', 'Regions', 'id', ['alias' => 'Regions']);
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'events';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return Events[]|Events|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return Events|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
