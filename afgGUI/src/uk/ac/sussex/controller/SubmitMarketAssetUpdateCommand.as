/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.MarketAssetsListProxy;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArrayMarketAsset;
	import uk.ac.sussex.model.valueObjects.MarketAsset;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.serverhandlers.MarketHandlers;
	import uk.ac.sussex.model.valueObjects.FormField;
	import uk.ac.sussex.model.valueObjects.Form;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SubmitMarketAssetUpdateCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var assetForm:Form = note.getBody() as Form;
			var assetFields:Array = assetForm.getFormFields();
			var updateRequestProxy:RequestProxy = facade.retrieveProxy(MarketHandlers.UPDATE_MARKET_ASSET + RequestProxy.NAME) as RequestProxy;
			for each(var assetField:FormField in assetFields){
				updateRequestProxy.setParamValue(assetField.getFieldName(), assetField.getFieldValue());
			}
			updateRequestProxy.sendRequest();
			
			var marketAsset:MarketAsset = new MarketAsset();
			marketAsset.setAmount(Number(assetForm.getFieldValue(DataParamArrayMarketAsset.FIELD_AMOUNT)));
			marketAsset.setId(int(assetForm.getFieldValue(DataParamArrayMarketAsset.FIELD_ID)));
			marketAsset.setBuyPrice(Number(assetForm.getFieldValue(DataParamArrayMarketAsset.FIELD_BUYPRICE)));
			marketAsset.setSellPrice(Number(assetForm.getFieldValue(DataParamArrayMarketAsset.FIELD_SELLPRICE)));
			
			var maListProxy:MarketAssetsListProxy = facade.retrieveProxy(MarketAssetsListProxy.NAME) as MarketAssetsListProxy;
			maListProxy.updateAsset(marketAsset);
			
			//Remove the editing box. 
			sendNotification(ApplicationFacade.SWITCH_SUBMENU_ITEM, MarketHandlers.GM_SUB_MENU_LIST);
		}
	}
}
