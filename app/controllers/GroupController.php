<?php
class GroupController extends ControllerBase
{
	public function indexAction($group_slug = null)
	{

        if ( isset($_REQUEST['group_slug']) )
        {
            $group_slug = $_REQUEST['group_slug'];
        }
        $group_slug = trim($group_slug);


        $group = Groups::findFirst("slug = '$group_slug' ");

        if ( $group )
        {
	        if ( isset($group->Cities) AND isset($group->Regions->name) ) {
				$title =  $group->name . ' - ' . $group->Cities->name . ', '  . $group->Regions->name . ' | ' . $this->config->company->name;
			} else {
				$title =  $group->name . ' - | ' . $this->config->company->name;
			}

			$this->view->metaTitle = $title;
			$this->view->metaDescription = $title;


	        $this->view->group = $group;

			$now = date('Y-m-d H:i:s');  // 2018-09-01 21:00:00

			// Traz apenas os eventos do grupo
			$events = Events::find(array(' id IN (SELECT eg.id_event FROM EventsGroups eg WHERE eg.id_group = "' . $group->id . '"  )   AND date_sales_end > "' . $now . '" ', 'order' => 'featured_premium ASC'));
			$this->view->events = $events;

        } else {
        	return $this->response->redirect('');
        }




	}





}