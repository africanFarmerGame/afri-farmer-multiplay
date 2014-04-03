/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.PlayerCharProxy;
	import uk.ac.sussex.model.valueObjects.Form;
	import uk.ac.sussex.model.valueObjects.FormFieldOption;
	import uk.ac.sussex.model.FormProxy;
	import uk.ac.sussex.model.VillageMembersListProxy;
	import uk.ac.sussex.model.valueObjects.Hearth;
	import uk.ac.sussex.model.HearthListProxy;
	import uk.ac.sussex.serverhandlers.VillageHandlers;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class VillageMembersReceivedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("VillageMembersReceivedCommand sez: I have been executed.");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			
			var myChar:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
			var myHearthId:int = myChar.getPCHearthId();
			trace("VillageMembersReceivedCommand sez: myHearthId is " + myHearthId);
			
			var hearths:Array = incomingData.getParamValue(VillageHandlers.VILLAGE_MEMBERS_HEARTHS) as Array;
			var pcs:Array = incomingData.getParamValue(VillageHandlers.VILLAGE_MEMBERS_PCS) as Array;
			var npcs:Array = incomingData.getParamValue(VillageHandlers.VILLAGE_MEMBERS_NPCS) as Array;
			
			var hearthListProxy:HearthListProxy = facade.retrieveProxy(HearthListProxy.NAME) as HearthListProxy;
			var formProxy:FormProxy = facade.retrieveProxy(VillageHandlers.PROPOSAL_FORM) as FormProxy;
			var hearthOptions:Array = new Array();
			var noHearthOption:FormFieldOption = new FormFieldOption("No household", "0");
			hearthOptions.push(noHearthOption);
			if(hearthListProxy == null){
				throw new Error("The Hearth List Proxy was null. Panic!");
			}
			
			for each (var hearth:Hearth in hearths){
				hearthListProxy.addHearth(hearth);
				var hearthOption:FormFieldOption; 
				if(myHearthId > 0){
					if(hearth.getId()==myHearthId){
						hearthOption = new FormFieldOption("Your household", hearth.getId().toString());
					} else {
						hearthOption = new FormFieldOption(hearth.getHearthName(), hearth.getId().toString());
					}
					hearthOptions.push(hearthOption);
				}
			}
			var propForm:Form = formProxy.getForm();
			propForm.updatePossibleFieldValues(VillageHandlers.PROPOSAL_FORM_CURRENT_HEARTH, hearthOptions);			
			
			var vmlp:VillageMembersListProxy = facade.retrieveProxy(VillageMembersListProxy.NAME) as VillageMembersListProxy;
			if(vmlp==null){
				throw new Error("The village people weren't there!");
			}
			vmlp.addNPCHearthMembers(npcs);
			vmlp.addPCHearthMembers(pcs);
		
		}
	}
}
