/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.AnyChar;
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import uk.ac.sussex.model.valueObjects.HearthAsset;
	import uk.ac.sussex.model.HearthAssetListProxy;
	import uk.ac.sussex.model.valueObjects.HearthMember;
	import uk.ac.sussex.model.valueObjects.PlayerChar;
	import uk.ac.sussex.model.HearthMembersListProxy;
	import uk.ac.sussex.states.TaskGameState;
	import uk.ac.sussex.states.FoodGameState;
	import uk.ac.sussex.model.ServerRoomProxy;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SubMenuHomeCommand extends SimpleCommand {
		override public function execute( note:INotification ):void {
			var roomProxy:ServerRoomProxy = facade.retrieveProxy(ServerRoomProxy.NAME) as ServerRoomProxy;
			var hearthId:String = roomProxy.getRoomId();
			var subMenuItem:String = note.getBody() as String;
			trace("SubMenuHomeCommand sez: Trying to fire off " + subMenuItem);
			switch(subMenuItem){
				case HomeHandlers.SUB_MENU_ASSETS:
					//sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, "Assets");
					displayAssetsText();
					break;
				case HomeHandlers.SUB_MENU_DIET:
					sendNotification(ApplicationFacade.CHANGE_STATE, FoodGameState.NAME);
					break;
				case HomeHandlers.SUB_MENU_OVERVIEW:
					displayOverviewText(int(hearthId));
					break;
				case HomeHandlers.SUB_MENU_WORK:
					sendNotification(ApplicationFacade.CHANGE_STATE, TaskGameState.NAME);
					break;
				default:
					trace("SubMenuHomeCommand sez: I didn't recognise the name of that - " + subMenuItem);
			}
		}
		private function displayOverviewText(hearthId:int):void {
			var displayText:String = "Household Overview \n";
			var hearthMembersLP:HearthMembersListProxy = facade.retrieveProxy(HearthMembersListProxy.NAME) as HearthMembersListProxy;
			if(hearthMembersLP!= null){
				var pcMembers:Array = hearthMembersLP.getPCMembers(hearthId);
				displayText += "\nHeads of household:";
				for each (var pc:PlayerChar in pcMembers){
					displayText += "\n  " + pc.getFirstName() + " " + pc.getFamilyName();
				}
				var npcMembers:Array = hearthMembersLP.getNPCMembers(hearthId);
				displayText += "\n\nOther household members:";
				for each(var npc:HearthMember in npcMembers){
					displayText += "\n  " + npc.getFirstName() + " " + npc.getFamilyName() + " (" + npc.getAge() + ")";
				}
				var deadMembers:Array = hearthMembersLP.getDeadMembers(hearthId);
				if(deadMembers!=null && deadMembers.length>0){
				  displayText+= "\n\nDead household members:";
				  for each (var dead:AnyChar in deadMembers){
					if(dead is HearthMember){
						var deadHM:HearthMember = dead as HearthMember;
					    displayText += "\n " + dead.getFirstName() + " " + dead.getFamilyName() + " (" + deadHM.getAge() + ")";
					} else {
						displayText += "\n " + dead.getFirstName() + " " + dead.getFamilyName() ;
					}
				  }
				}
			}
			sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, displayText);
			
		}
		private function displayAssetsText():void{
			var outputString:String = "Family Assets" + "\n\n";
			
			var hearthAssetsLP:HearthAssetListProxy = facade.retrieveProxy(HearthAsset.OWNER_HEARTH + HearthAssetListProxy.NAME) as HearthAssetListProxy;
			if(hearthAssetsLP!=null){
				var hearthAssets:Array = hearthAssetsLP.fetchHearthAssets();
				for each (var asset:HearthAsset in hearthAssets){
					var gameAsset:GameAsset = asset.getAsset();
					outputString += asset.getAmount() + " " + gameAsset.getMeasurement() + "(s) " + gameAsset.getName() + "\n";
				}
			}
			sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, outputString);
		}
	}
}
