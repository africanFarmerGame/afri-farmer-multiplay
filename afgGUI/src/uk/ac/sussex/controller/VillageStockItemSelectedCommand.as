/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.PlayerCharProxy;
	import uk.ac.sussex.model.valueObjects.Form;
	import uk.ac.sussex.model.HearthAssetListProxy;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.valueObjects.HearthAsset;
	import uk.ac.sussex.serverhandlers.VillageHandlers;
	import uk.ac.sussex.model.FormProxy;
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class VillageStockItemSelectedCommand extends SimpleCommand {
    	override public function execute(note:INotification):void{
    		trace("VillageStockItemSelectedCommand sez: I got fireded.");
	  		var asset:GameAsset = note.getBody() as GameAsset;
			var giveFormProxy:FormProxy = facade.retrieveProxy(VillageHandlers.GIVE_FORM) as FormProxy;
			if(giveFormProxy == null){
				throw new Error("Unable to retrieve the form proxy for the give form.");
			}
			if(asset==null){
				giveFormProxy.updateFieldValue(VillageHandlers.GIVE_ASSET, null);
				giveFormProxy.updateFieldValue(VillageHandlers.GIVE_ASSET_ID, null);
				sendNotification(ApplicationFacade.REVERT_TEMP_INFO_TEXT);
			} else {
				var hearthAssetLP:HearthAssetListProxy = fetchHearthAssetListProxy();
				var hearthAsset:HearthAsset = hearthAssetLP.fetchHearthAssetByAssetId(asset.getId());
				outputSellInfo(hearthAsset);
				giveFormProxy.updateFieldValue(VillageHandlers.GIVE_ASSET, asset.getName());
				giveFormProxy.updateFieldValue(VillageHandlers.GIVE_ASSET_ID, asset.getId().toString());
				var giveForm:Form = giveFormProxy.getForm();
				var giveOptions:Array = hearthAsset.getSellOptions();
				if(giveOptions!=null){
					trace("VillageStockItemSelectedCommand sez: I have give options to display.");
					giveForm.setFieldEnabled(VillageHandlers.GIVE_ASSET_AMOUNT, false);
					giveForm.updatePossibleFieldValues(VillageHandlers.GIVE_ASSET_OPTIONS, giveOptions);
					giveForm.setFieldValue(VillageHandlers.GIVE_ASSET_OPTIONS, "");
					giveForm.setFieldEnabled(VillageHandlers.GIVE_ASSET_OPTIONS, true);
					giveFormProxy.showHideFields([VillageHandlers.GIVE_ASSET_AMOUNT], [VillageHandlers.GIVE_ASSET_OPTIONS]);
				} else {
					giveForm.setFieldEnabled(VillageHandlers.GIVE_ASSET_AMOUNT, true);
					giveForm.updatePossibleFieldValues(VillageHandlers.GIVE_ASSET_OPTIONS, null);
					giveForm.setFieldValue(VillageHandlers.GIVE_ASSET_OPTIONS, null);
					giveForm.setFieldEnabled(VillageHandlers.GIVE_ASSET_OPTIONS, false);
					giveFormProxy.showHideFields([VillageHandlers.GIVE_ASSET_OPTIONS], [VillageHandlers.GIVE_ASSET_AMOUNT]);					
				}
				
			}
   		}
		private function outputSellInfo(hearthAsset:HearthAsset):void{
			var asset:GameAsset = hearthAsset.getAsset();
			var sellOutput:String = asset.getName();
			sellOutput = sellOutput + "\n You have: " + hearthAsset.getAmount() +" " + hearthAsset.getAsset().getMeasurement() + "(s)"; 
			sendNotification(ApplicationFacade.DISPLAY_TEMP_INFO_TEXT, sellOutput);
		}
		private function fetchHearthAssetListProxy():HearthAssetListProxy{
			var hearthAssetLP:HearthAssetListProxy = null;
			var myChar:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
			if(myChar.getPCHearthId()!=null&&myChar.getPCHearthId()>0){
				hearthAssetLP = facade.retrieveProxy(HearthAsset.OWNER_HEARTH + HearthAssetListProxy.NAME) as HearthAssetListProxy;
				if(hearthAssetLP==null){
					throw new Error("The hearth asset list proxy was null.");
				}
			} else {
				hearthAssetLP = facade.retrieveProxy(HearthAsset.OWNER_PC + HearthAssetListProxy.NAME) as HearthAssetListProxy;
				if(hearthAssetLP==null){
					throw new Error("The player's hearth asset list proxy was null.");
				}
			}
			return hearthAssetLP;
		}
  	}
}