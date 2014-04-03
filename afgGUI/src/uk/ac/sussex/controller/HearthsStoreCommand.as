/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.HearthListProxy;
	import uk.ac.sussex.model.FormProxy;
	import uk.ac.sussex.model.valueObjects.Hearth;
	import uk.ac.sussex.model.valueObjects.FormFieldOption;
	import uk.ac.sussex.model.valueObjects.Form;
	import uk.ac.sussex.serverhandlers.VillageHandlers;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.interfaces.*;

	import uk.ac.sussex.model.valueObjects.IncomingData;
	/**
	 * @author em97
	 */
	public class HearthsStoreCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var hearthList:Array = incomingData.getParamValue("HearthDetails") as Array;
			if(hearthList==null){
				throw new Error("Unable to retrieve hearth details");
			}
			trace("HearthsStoreCommand sez: I'm about to stack a load of hearths in the list.");
			var hearthListProxy:HearthListProxy = facade.retrieveProxy(HearthListProxy.NAME) as HearthListProxy;
			if(hearthListProxy!=null){
				trace("HearthsStoreCommand sez: The hearthListProxy is apparently not null. " + (hearthListProxy != null));
				var hearthOptionArray:Array = new Array();
				trace("HearthStoreCommand sez: Is hearthList null? " + (hearthList==null));
				trace("HearthsStoreCommand sez: I have " + hearthList.length + " hearths to stack");
				for each (var hearth:Hearth in hearthList ){
					hearthListProxy.addHearth(hearth);
					var newOption:FormFieldOption = new FormFieldOption(hearth.getHearthName(), hearth.getId().toString());
					hearthOptionArray.push(newOption);
				}
				var giveFormProxy:FormProxy = facade.retrieveProxy(VillageHandlers.GIVE_FORM) as FormProxy;
				if(giveFormProxy!=null){
					var giveForm:Form = giveFormProxy.getForm();
					giveForm.updatePossibleFieldValues(VillageHandlers.GIVE_HEARTH, hearthOptionArray);
				}	
			}
		}
	}
}
