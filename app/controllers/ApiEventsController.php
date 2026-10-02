<?php

use Phalcon\Http\Response;

class ApiEventsController extends ApiControllerBase
{
    private $CartLib;

    public function initialize() {
        $this->CartLib = new CartLib();
    }

    public function indexAction()
    {
        $id_pos = isset($this->requestBody->id_pos) ? $this->requestBody->id_pos : 0;
        $id_pdv = isset($this->requestBody->id_pdv) ? $this->requestBody->id_pdv : 0;

        if(empty($id_pdv)) {
            $this->response->setStatusCode(404, "Not Found");
            $this->response->setContent(json_encode("Missing parameters"));
            $this->response->send();
            return;
        }

        $events = $this->CartLib->getEvents($id_pdv);
        $this->sendEventsData($events);
    }

    public function singleAction()
    {
        $id = isset($this->requestBody->id) ? $this->requestBody->id : 0;
        $id_organizer = isset($this->requestBody->id_organizer) ? $this->requestBody->id_organizer : 0;

        if(empty($id) || empty($id_organizer)) {
            $this->response->setStatusCode(404, "Not Found");
            $this->response->setContent(json_encode("Missing parameters"));
            $this->response->send();
            return;
        }

        $events = Events::find([
            "id = $id",
            "id_organizer = $id_organizer"
        ]);
        $this->sendEventsData($events);
    }

    private function sendEventsData($events) {
        $result = [];
        $arrayIds = array();
        foreach ($events as $event) {
            if(!in_array($event->id, $arrayIds)){
                array_push($arrayIds, $event->id);
                $event->id_place = $event->Places;
                $event->id_city = $event->Cities;
                $event->id_region = $event->Regions;
                $event->id_organizer = $event->Organizers;
    
                if(empty($event->negotiation)){
                    $event->card_fee_debit = $event->card_fee_debit_og;
                    $event->card_fee_1x = $event->card_fee_1x_og;
                    $event->card_fee_2x = $event->card_fee_2x_og;
                    $event->card_fee_3x = $event->card_fee_3x_og;
                    $event->negotiation = $event->negotiation_og;
                }
    
                $eventArray = $event->toArray();
                foreach($event->EventsImages as $image) {
                    $eventArray['images'][] = "img/shows/{$image->name}";
                }
    
                if(!isset($eventArray['images'])) {
                    $eventArray['images'][] = "img/shows/alexandre_pires1.jpg";
                }
    
                
                $negotiation = json_decode($eventArray['negotiation']);
                
                if(!empty($eventArray['card_fee_debit']) && $eventArray['card_fee_debit'] != "0"){
                    
                    if($negotiation != null){
                        $negotiation->duty_debit = $event->duty_debit;
                        $negotiation->tax_type_debit = $event->tax_type_debit;
                    }
                }else{
                    if($negotiation != null){
                        $negotiation->duty_debit = "0";
                        $negotiation->tax_type_debit = "0";
                    }
                }
    
                if(!empty($eventArray['card_fee_1x']) && $eventArray['card_fee_1x'] != "0"){
                    if($negotiation != null){
                        $negotiation->duty_card_fee_1x = $event->duty_card_fee_1x;
                        $negotiation->tax_type_card_fee_1x = $event->tax_type_card_fee_1x;
                    }
                }else{
                    if($negotiation != null){
                        $negotiation->duty_card_fee_1x = "0";
                        $negotiation->tax_type_card_fee_1x = "0";
                    }
                }
    
                if(!empty($eventArray['card_fee_2x']) && $eventArray['card_fee_2x'] != "0"){
                    if($negotiation != null){
                        $negotiation->duty_card_fee_2x = $event->duty_card_fee_2x;
                        $negotiation->tax_type_card_fee_2x = $event->tax_type_card_fee_2x;
                    }
                }else{
                    if($negotiation != null){
                        $negotiation->duty_card_fee_2x = "0";
                        $negotiation->tax_type_card_fee_2x = "0";
                    }
                }
    
                if(!empty($eventArray['card_fee_3x']) && $eventArray['card_fee_3x'] != "0"){
                    if($negotiation != null){
                        $negotiation->duty_card_fee_3x = $event->duty_card_fee_3x;
                        $negotiation->tax_type_card_fee_3x = $event->tax_type_card_fee_3x;
                    }
                }else{
                    if($negotiation != null){
                        $negotiation->duty_card_fee_3x = "0";
                        $negotiation->tax_type_card_fee_3x = "0";
                    }
                }
    
                $eventArray['negotiation'] = $negotiation;
                $result[] = $eventArray;
            }
        }
        
        $this->response->setContent(json_encode($result));
        $this->response->send();
    }

    public function reportAction() {
        $id_pos = isset($this->requestBody->id_pos) ? $this->requestBody->id_pos : 0;
        $id_pdv = isset($this->requestBody->id_pdv) ? $this->requestBody->id_pdv : 0;
        $id_event = isset($this->requestBody->id_event) ? $this->requestBody->id_event : 0;
        $periodoDe = !empty($this->requestBody->periodoDe) ? " AND si.created_at >= '".$this->requestBody->periodoDe."'" : "";
        $periodoAte = !empty($this->requestBody->periodoAte) ? " AND si.created_at <= '". $this->requestBody->periodoAte."'" : "";

        $events = $this->CartLib->getEventReport($id_pos, $id_pdv, $id_event, $periodoDe, $periodoAte);

        $cash = 0;
        $credit = 0;
        $debit = 0;
        $pix = 0;
        $external = 0;
        $name = "";
        foreach($events as $event){
            if($event['payment_type'] == 1){
                $cash = $event['value'] + $event['value_fee'];
                
            }else if($event['payment_type'] == 15){
                $credit = $event['value'];
                
            }else if($event['payment_type'] == 16){
                $debit =  $event['value'];
                
            }else if($event['payment_type'] == 25){
                $pix =  $event['value'];
                
            }else if($event['payment_type'] == 8){
                $external =  $event['value'];
                
            }

            $name = $event['name'];
        }
        $result = array("cash" => $cash, "credit" => $credit, "debit" => $debit, "pix" => $pix, "external" => $external, "name" => $name);
        
        $this->response->setContent(json_encode($result));
        $this->response->send();
    }
    
    public function paymentTypeAction() {
        $id_pdv = isset($this->requestBody->id_pdv) ? $this->requestBody->id_pdv : 0;

        $sql = "SELECT * FROM sales_points_payment_type WHERE id_sale_point = " . $id_pdv;
        $result = $this->db->prepare($sql);
        $result->execute();
        $result = $result->fetchaLL(PDO::FETCH_ASSOC);
        $arrayResult = [];
        foreach($result as $r){
            $arrayResult[] = $r;
        }
        
        $this->response->setContent(json_encode($arrayResult));
        $this->response->send();
    }
}