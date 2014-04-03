/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.Form;
	import uk.ac.sussex.serverhandlers.VillageHandlers;
	import uk.ac.sussex.model.FormProxy;
	import uk.ac.sussex.model.valueObjects.FormFieldOption;
	import uk.ac.sussex.model.valueObjects.Hearth;
	import uk.ac.sussex.model.valueObjects.AnyChar;
	import uk.ac.sussex.model.HearthMembersListProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import uk.ac.sussex.model.HearthListProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class GMDeadReceivedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("GMDeadReceivedCommand sez: I see dead people...");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var deadPeople:Array = incomingData.getParamValue("Dead") as Array; 
			//I think this lot should go into a big old HearthMembersListProxy. 
			var hearthListProxy:HearthListProxy = facade.retrieveProxy(HearthListProxy.NAME) as HearthListProxy;
			var hearthMemberLP:HearthMembersListProxy = facade.retrieveProxy(HearthMembersListProxy.NAME) as HearthMembersListProxy;
			if(hearthMemberLP!=null){
				trace("GMDeadReceivedCommand sez: We have a list of hearth members to add to.");
				hearthMemberLP.addDeadHearthMembers(deadPeople);
				if(hearthListProxy!=null){
					var sortedDead:Array = deadPeople.sort(sortOnHearthId);
					var currentHearthId:int = -1;
					var hearthOptions:Array = new Array();
					for each(var dead:AnyChar in sortedDead){
						if(dead.getHearthId()!=currentHearthId){
							var hearthId:int = dead.getHearthId();
							var hearth:Hearth = hearthListProxy.getHearthById(hearthId);
							var hearthOption:FormFieldOption = new FormFieldOption(hearth.getHearthName(), hearthId.toString());
							hearthOptions.push(hearthOption);
							currentHearthId = hearthId;
						}
					}
					if(hearthOptions.length>0){
						var formProxy:FormProxy = facade.retrieveProxy(VillageHandlers.RES_FORM) as FormProxy;
						var form:Form = formProxy.getForm();
						form.updatePossibleFieldValues(VillageHandlers.RES_FORM_HEARTH, hearthOptions);
					}
				}
			}
		}
		
		private function sortOnHearthId(a:AnyChar, b:AnyChar):int {
			var aId:int = a.getHearthId();
			var bId:int = b.getHearthId();
			if(aId>bId){
				return 1;
			} else if (aId<bId) {
				return -1;
			} else {
				return 0;
			}
		}
	}
}
