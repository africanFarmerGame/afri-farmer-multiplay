/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view {
	import uk.ac.sussex.model.valueObjects.AnyChar;
	import uk.ac.sussex.serverhandlers.GameHandlers;
	import uk.ac.sussex.states.HomeGameState;
	import flash.events.Event;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.view.components.HearthIcon;
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	/**
	 * @author em97
	 */
	public class HearthMediator extends Mediator implements IMediator {
		public static const NAME:String = "HearthMediator";
		public static const HEARTH_SELECTED:String = "HearthSelected";
		public static const HEARTH_DESELECTED:String = "HearthDeselected";
		
		public function HearthMediator(hearthId : int) {
			super(NAME + hearthId, new HearthIcon());
			hearth.setHearthId(hearthId);
		}
		override public function listNotificationInterests():Array {
			return [HEARTH_SELECTED, HEARTH_DESELECTED];
		}
		override public function handleNotification (note:INotification):void {
			switch (note.getName()){
				case HEARTH_SELECTED:
					var selectedId:int = note.getBody() as int;
					hearth.setSelected((selectedId==hearth.getHearthId()));
					break;
				case HEARTH_DESELECTED:
					hearth.setSelected(false);
					break;
			}
		}
		public function setPosition(x:Number, y:Number): void {
			hearth.x = x;
			hearth.y = y;
		}

		public function displayHearthName(hearthName:String):void {
			hearth.setHearthName(hearthName);
		}
		public function showDoor():void {
			hearth.showDoors();
		}
		/**
		 * @param relation - should be one of the PlayerChar constants. 
		 */
		public function displayOccupantsRelationship(relation:int):void {
			switch (relation) {
				case AnyChar.IMMEDIATE_FAMILY:
				case AnyChar.RELATIVE:
					hearth.setHearthNameBgColour(0xFFCC00);
					break;
				case AnyChar.ME:
					hearth.setHearthNameBgColour(0x4dc6f3);
					break;
				case AnyChar.NO_RELATION:
				default:
					hearth.setHearthNameBgColour(0xffffff);
					break;
			}
		}
		public function displayHearth(displayHearth:Boolean):void {
		  if(displayHearth){
		    sendNotification(ViewAreaMediator.ADD_VIEW_COMPONENT, hearth);
		  } else {
		    sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, hearth);
		  }
		}
		//Event handlers
		private function doorClicked(e:Event):void {
			trace("HearthMediator sez: The hearth door done got clicked.");
			var dataArray:Array = new Array();
			dataArray["location"] = HomeGameState.LOCATION_NAME;
			dataArray["locId"] = hearth.getHearthId();
			
			sendNotification(GameHandlers.REQUEST_LOCATION_MOVE, dataArray);
		}
		private function houseClicked(e:Event):void {
			if(hearth.getSelected()){
				//We need to deselect it.
				sendNotification(HEARTH_DESELECTED, hearth.getHearthId()); 
			}
			else {
				sendNotification(HEARTH_SELECTED, hearth.getHearthId());	
			}
		}
		//Cast the viewComponent to the correct type.
		protected function get hearth():HearthIcon {
			return viewComponent as HearthIcon;
		}
		override public function onRegister():void
		{	
			hearth.addEventListener(HearthIcon.DOOR_CLICKED, doorClicked);
			hearth.addEventListener(HearthIcon.HOUSE_CLICKED, houseClicked);
			//For now, we're going to let this button set its own position - for consistency.
			sendNotification(ViewAreaMediator.ADD_VIEW_COMPONENT, hearth);
		}
		override public function onRemove():void
		{
			hearth.removeEventListener(HearthIcon.DOOR_CLICKED, doorClicked);
			hearth.removeEventListener(HearthIcon.HOUSE_CLICKED, houseClicked);
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, hearth);
			hearth.destroy();
		}
	}
}
