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
	import uk.ac.sussex.model.HearthListProxy;
	import uk.ac.sussex.model.HearthMembersListProxy;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class GMResurrectionCompleteCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			if(incomingData==null){
				throw new Error("No incoming data - please check for notification clashes. " + note.getName());
			}
			var message:String = incomingData.getParamValue("Message") as String;
			var charId:int = incomingData.getParamValue("CharId") as int;
			var hmlp:HearthMembersListProxy = facade.retrieveProxy(HearthMembersListProxy.NAME) as HearthMembersListProxy;
			if(hmlp!=null && charId!=null){
				hmlp.resurrectMember(charId);
				var hearthListProxy:HearthListProxy = facade.retrieveProxy(HearthListProxy.NAME) as HearthListProxy;
				if(hearthListProxy!=null){
					var hearths:Array = hearthListProxy.getHearths();
					var hearthOptions:Array = new Array();
					for each (var hearth:Hearth in hearths){
						var hearthDead:Array = hmlp.getDeadMembers(hearth.getId());
						if(hearthDead.length>0){
							var hearthOption:FormFieldOption = new FormFieldOption(hearth.getHearthName(), hearth.getId().toString());
							hearthOptions.push(hearthOption);
						}
					}
					var formProxy:FormProxy = facade.retrieveProxy(VillageHandlers.RES_FORM) as FormProxy;
					var form:Form = formProxy.getForm();
					formProxy.updateFieldValue(VillageHandlers.RES_FORM_DEAD, null);
					form.updatePossibleFieldValues(VillageHandlers.RES_FORM_HEARTH, hearthOptions);
				}
			} else {
				if(hmlp==null){
					throw new Error("Character " + charId + " could not be resurrected due to a null HearthMembersListProxy.");
				} else if(charId==null) {
					throw new Error("Character could not be resurrected due to a null charId.");
				}
			}
			
			sendNotification(ApplicationFacade.DISPLAY_MESSAGE, message);
		}
	}
}
