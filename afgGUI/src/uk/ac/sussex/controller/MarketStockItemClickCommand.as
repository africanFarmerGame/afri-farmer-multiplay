/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.GameAssetCrop;
	import uk.ac.sussex.model.valueObjects.Form;
	import uk.ac.sussex.model.valueObjects.HearthAsset;
	import uk.ac.sussex.model.HearthAssetListProxy;
	import uk.ac.sussex.model.MarketAssetsListProxy;
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import uk.ac.sussex.model.FormProxy;
	import uk.ac.sussex.serverhandlers.MarketHandlers;
	import uk.ac.sussex.view.SubMenuMediator;
	import uk.ac.sussex.model.valueObjects.MarketAsset;
	import uk.ac.sussex.general.ApplicationFacade;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class MarketStockItemClickCommand extends SimpleCommand {
		override public function execute(note:INotification):void{
			//I need to check which submenu area I'm in. Different things need to happen depending. 
			var submenuMediator:SubMenuMediator = facade.retrieveMediator(SubMenuMediator.NAME) as SubMenuMediator;
			var currentSubmenuItem:String = submenuMediator.getCurrentSelection();
			var asset:GameAsset = note.getBody() as GameAsset;
			if(asset==null){ 
				throw new Error("The asset was null.");
			}
			
			if(asset==null){
				sendNotification(ApplicationFacade.REVERT_TEMP_INFO_TEXT);
			} else {
				var marketAssetLP:MarketAssetsListProxy = facade.retrieveProxy(MarketAssetsListProxy.NAME) as MarketAssetsListProxy;
				var marketAsset:MarketAsset = marketAssetLP.getMarketAssetByAssetId(asset.getId());
				if(marketAsset==null){
					throw new Error("The market asset for asset " + asset.getName() + " was null.");
				}
				
				switch (currentSubmenuItem){
					
					case MarketHandlers.SUB_MENU_STOCKS:
						outputGeneralStockInfo(marketAsset);
						break;
					case MarketHandlers.SUB_MENU_BUY:
						outputBuyInfo(marketAsset);
						break;
					case MarketHandlers.SUB_MENU_SELL:
						var hearthAssetLP: HearthAssetListProxy = facade.retrieveProxy(HearthAsset.OWNER_HEARTH + HearthAssetListProxy.NAME) as HearthAssetListProxy;
						var hearthAsset:HearthAsset = hearthAssetLP.fetchHearthAssetByAssetId(asset.getId());
						outputSellInfo(marketAsset, hearthAsset);
						break;
				}
			}
		}
		private function outputGeneralStockInfo(marketAsset:MarketAsset):void {
			var asset:GameAsset = marketAsset.getAsset();
			var marketOutput:String = asset.getName();
			marketOutput = marketOutput + "\n\n" + asset.getNotes();
			if(asset is GameAssetCrop){
				var cropAsset:GameAssetCrop = asset as GameAssetCrop;
				marketOutput += "\n\n Possible yields:";
				marketOutput += "\n Early yield: " + cropAsset.getEPYield();
				marketOutput += "\n Late yield: " + cropAsset.getLPYield();
			}
			marketOutput = marketOutput + "\n\n Market Sell Price: " + marketAsset.getSellPrice().toString();
			marketOutput = marketOutput + "\n Market Buy Price: " + marketAsset.getBuyPrice().toString();
			marketOutput = marketOutput + "\n Stock levels: " + marketAsset.getAmount() + " " + asset.getMeasurement(); 
			
			
			
			sendNotification(ApplicationFacade.DISPLAY_TEMP_INFO_TEXT, marketOutput);
		}
		private function outputBuyInfo(marketAsset:MarketAsset):void {
			var asset:GameAsset = marketAsset.getAsset();
			var buyOutput:String = asset.getName();
			buyOutput = buyOutput + "\n\n" + asset.getNotes();
			buyOutput = buyOutput + "\n\n Market buys for: " + marketAsset.getBuyPrice().toString();
			buyOutput = buyOutput + "\n Market sells for: " + marketAsset.getSellPrice().toString();
			buyOutput = buyOutput + "\n Stock levels: " + marketAsset.getAmount() + " " + asset.getMeasurement();
			
			sendNotification(ApplicationFacade.DISPLAY_TEMP_INFO_TEXT, buyOutput);
			
			var buyForm:FormProxy = facade.retrieveProxy(MarketHandlers.BUY_FORM) as FormProxy;
			buyForm.updateFieldValue(MarketHandlers.BUY_SELL_GOODS, asset.getName());
			buyForm.updateFieldValue(MarketHandlers.BUY_SELL_PRICE, marketAsset.getSellPrice().toString());
			buyForm.updateFieldValue(MarketHandlers.BUY_SELL_ASSETID, asset.getId().toString());
		}
		private function outputSellInfo(marketAsset:MarketAsset, hearthAsset:HearthAsset):void{
			var asset:GameAsset = marketAsset.getAsset();
			var sellOutput:String = asset.getName();
			sellOutput = sellOutput + "\n\n" + asset.getNotes();
			sellOutput = sellOutput + "\n\n Market buys for: " + marketAsset.getBuyPrice().toString();
			sellOutput = sellOutput + "\n\n Market sells for: " + marketAsset.getSellPrice().toString();
			sellOutput = sellOutput + "\n You have: " + hearthAsset.getAmount() +" " + hearthAsset.getAsset().getMeasurement() + "(s)"; 
			sendNotification(ApplicationFacade.DISPLAY_TEMP_INFO_TEXT, sellOutput);
			
			var sellFormProxy:FormProxy = facade.retrieveProxy(MarketHandlers.SELL_FORM) as FormProxy;
			if(sellFormProxy==null){
				throw new Error("The sellFormProxy was null.");
			}
			sellFormProxy.updateFieldValue(MarketHandlers.BUY_SELL_GOODS, asset.getName());
			sellFormProxy.updateFieldValue(MarketHandlers.BUY_SELL_PRICE, marketAsset.getBuyPrice().toString());
			sellFormProxy.updateFieldValue(MarketHandlers.BUY_SELL_ASSETID, asset.getId().toString());
			var sellForm:Form = sellFormProxy.getForm();
			var sellOptions:Array = hearthAsset.getSellOptions();
			if(sellOptions!=null){
				sellForm.setFieldEnabled(MarketHandlers.BUY_SELL_QTY, false);
				sellForm.updatePossibleFieldValues(MarketHandlers.BUY_SELL_OPTIONS, sellOptions);
				sellForm.setFieldValue(MarketHandlers.BUY_SELL_OPTIONS, "");
				sellForm.setFieldEnabled(MarketHandlers.BUY_SELL_OPTIONS, true);
				sellFormProxy.showHideFields([MarketHandlers.BUY_SELL_QTY], [MarketHandlers.BUY_SELL_OPTIONS]);
				
			} else {
				sellForm.setFieldEnabled(MarketHandlers.BUY_SELL_QTY, true);
				sellForm.updatePossibleFieldValues(MarketHandlers.BUY_SELL_OPTIONS, null);
				sellForm.setFieldValue(MarketHandlers.BUY_SELL_OPTIONS, null);
				sellForm.setFieldEnabled(MarketHandlers.BUY_SELL_OPTIONS, false);
				sellFormProxy.showHideFields([MarketHandlers.BUY_SELL_OPTIONS], [MarketHandlers.BUY_SELL_QTY]);
			}
		}
	}
}
