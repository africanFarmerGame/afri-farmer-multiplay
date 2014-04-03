/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.serverhandlers.VillageHandlers;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.model.valueObjects.Form;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SubmitGiveFormCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("SubmitGiveFormCommand sez: The form is submitted");
			var formData:Form = note.getBody() as Form;
			if(formData==null){
				throw new Error("No form data attached.");
			}
			var request:RequestProxy = facade.retrieveProxy(VillageHandlers.GIVE_REQUEST + RequestProxy.NAME) as RequestProxy;
			if (request==null ){
				throw new Error("No request proxy for " + VillageHandlers.GIVE_REQUEST + " could be found.");
			}	
			var assetId:int =  int(formData.getFieldValue(VillageHandlers.GIVE_ASSET_ID));
			if(assetId==0){
				sendNotification(ApplicationFacade.DISPLAY_ERROR_MESSAGE, "Please select a valid asset from the list.");
				return;
			}
			var hearthId:int = int(formData.getFieldValue(VillageHandlers.GIVE_HEARTH));
			if(hearthId==0){
				sendNotification(ApplicationFacade.DISPLAY_ERROR_MESSAGE, "Please select a family to give this asset to.");
				return;
			}
			
			request.setParamValue(VillageHandlers.GIVE_ASSET_ID, assetId);
			request.setParamValue(VillageHandlers.GIVE_HEARTH, hearthId);
			request.setParamValue(VillageHandlers.GIVE_ASSET_AMOUNT, formData.getFieldValue(VillageHandlers.GIVE_ASSET_AMOUNT));
			request.setParamValue(VillageHandlers.GIVE_ASSET_OPTIONS, formData.getFieldValue(VillageHandlers.GIVE_ASSET_OPTIONS));
			request.sendRequest();
			formData.resetForm();
			sendNotification(ApplicationFacade.SWITCH_SUBMENU_ITEM, VillageHandlers.SUB_MENU_OVERVIEW);
		}
	}
}
