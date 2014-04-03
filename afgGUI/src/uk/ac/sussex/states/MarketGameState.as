/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.states {
	import uk.ac.sussex.model.MarketAssetsListProxy;
	import uk.ac.sussex.model.SubMenuListProxy;
	import uk.ac.sussex.model.IncomingDataErrorProxy;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.valueObjects.requestParams.*;
	import flash.display.Sprite;
	import uk.ac.sussex.view.FormMediator;
	import uk.ac.sussex.model.FormProxy;
	import uk.ac.sussex.view.InStockAssetListMediator;
	import uk.ac.sussex.controller.*;
	import uk.ac.sussex.model.IncomingDataProxy;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.serverhandlers.MarketHandlers;
	import uk.ac.sussex.view.SubMenuMediator;
	import org.puremvc.as3.multicore.interfaces.IFacade;

	/**
	 * @author em97
	 */
	public class MarketGameState extends PlayerRoomState implements IGameState {
		public static const NAME:String = "MarketGameState";
		public static const LOCATION_NAME:String = "MARKET";
		
		public function MarketGameState(facade : IFacade) {
			super(facade, NAME);
		}
		override public function displayState():void{
			super.displayState();
			trace("MarketGameState sez: You've reached the Market Game State");
			//add proxies
			this.registerProxies();
			//add commands
			facade.registerCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED, SubMenuMarketCommand);
			facade.registerCommand(MarketHandlers.INSTOCK_MARKET_ASSET_DETAILS, DisplayPlayerMarketAssetsCommand);
			facade.registerCommand(InStockAssetListMediator.STOCK_ITEM_SELECTED, MarketStockItemClickCommand);
			facade.registerCommand(FormProxy.FORM_FIELD_VALUE_CHANGED, MarketHandleFormChangeCommand);
			facade.registerCommand(MarketHandlers.BUY_SELL_CANCEL, CancelBuySellFormCommand);
			facade.registerCommand(MarketHandlers.BUY_SELL_BUY, SubmitBuyFormCommand);
			facade.registerCommand(MarketHandlers.BUY_SELL_SELL, SubmitSellFormCommand);
			facade.registerCommand(MarketHandlers.PLAYER_CURRENT_ASSET_DETAILS, MarketPlayerAssetDetailsReceived);
			facade.registerCommand(MarketHandlers.INSTOCK_MARKET_ASSETS_UPDATED, UpdateInStockMarketAssetsCommand);

				//add mediators
			var submenuMediator:SubMenuMediator = new SubMenuMediator();
			facade.registerMediator(submenuMediator);

			facade.registerMediator(new InStockAssetListMediator());
			
			var buyFormMediator:FormMediator = new FormMediator(MarketHandlers.BUY_FORM, new Sprite());
			this.facade.registerMediator(buyFormMediator);
			buyFormMediator.setLabelWidth(70);
			
			var sellFormMediator:FormMediator = new FormMediator(MarketHandlers.SELL_FORM, new Sprite());
			this.facade.registerMediator(sellFormMediator);
			sellFormMediator.setLabelWidth(70);
		 
			submenuMediator.moveToDefaultButton();
		}
		override public function cleanUpState():void{
			//remove proxies
			this.removeProxies();
			
			//remove mediators
			facade.removeMediator(SubMenuMediator.NAME);
			facade.removeMediator(InStockAssetListMediator.NAME);
			facade.removeMediator(MarketHandlers.BUY_FORM);
			facade.removeMediator(MarketHandlers.SELL_FORM);
			//remove commands
			facade.removeCommand(SubMenuMediator.SUB_MENU_ITEM_SELECTED);
			facade.removeCommand(MarketHandlers.INSTOCK_MARKET_ASSET_DETAILS);
			facade.removeCommand(InStockAssetListMediator.STOCK_ITEM_SELECTED);
			facade.removeCommand(FormProxy.FORM_FIELD_VALUE_CHANGED);
			facade.removeCommand(MarketHandlers.BUY_SELL_CANCEL);
			facade.removeCommand(MarketHandlers.BUY_SELL_BUY);
			facade.removeCommand(MarketHandlers.PLAYER_CURRENT_ASSET_DETAILS);
			facade.removeCommand(MarketHandlers.INSTOCK_MARKET_ASSETS_UPDATED);
			
			super.cleanUpState();
		}
		
		private function registerProxies():void {
			facade.registerProxy(new MarketAssetsListProxy());
			facade.registerProxy(new IncomingDataErrorProxy(MarketHandlers.MARKET_ERROR));
						
			var marketAssetsRequestProxy:RequestProxy = new RequestProxy(MarketHandlers.INSTOCK_MARKET_ASSETS);
			facade.registerProxy(marketAssetsRequestProxy);
			marketAssetsRequestProxy.sendRequest();
			var maIncomingDataProxy:IncomingDataProxy = new IncomingDataProxy(MarketHandlers.INSTOCK_MARKET_ASSET_DETAILS, MarketHandlers.INSTOCK_MARKET_ASSET_DETAILS);
			maIncomingDataProxy.addDataParam(new DataParamArrayMarketAsset("AssetDetails"));
			this.facade.registerProxy(maIncomingDataProxy);
			facade.registerProxy(new IncomingDataErrorProxy(MarketHandlers.INSTOCK_MARKET_ASSET_ERROR));
			
			var playerAssetsRequestProxy:RequestProxy = new RequestProxy(MarketHandlers.PLAYER_CURRENT_ASSETS);
			facade.registerProxy(playerAssetsRequestProxy);
			playerAssetsRequestProxy.sendRequest();
			
			var paIncomingDataProxy:IncomingDataProxy = new IncomingDataProxy(MarketHandlers.PLAYER_CURRENT_ASSET_DETAILS, MarketHandlers.PLAYER_CURRENT_ASSET_DETAILS);
			paIncomingDataProxy.addDataParam(new DataParamArrayHearthAsset(MarketHandlers.PC_ASSET_DETAILS));
			paIncomingDataProxy.addDataParam(new DataParamArrayHearthAsset(MarketHandlers.HEARTH_ASSET_DETAILS));
			this.facade.registerProxy(paIncomingDataProxy);
			facade.registerProxy(new IncomingDataErrorProxy(MarketHandlers.PLAYER_CURRENT_ASSETS_ERROR));
			
			var buyRequest:RequestProxy = new RequestProxy(MarketHandlers.SUBMIT_BUY_REQUEST);
			buyRequest.addRequestParam(new DataParamInt("AssetId"));
			buyRequest.addRequestParam(new DataParamNumber("Quantity"));
			buyRequest.addRequestParam(new DataParamString("Owner"));
			this.facade.registerProxy(buyRequest);
			
			facade.registerProxy(new IncomingDataErrorProxy(MarketHandlers.BUY_REQUEST_ERROR));
			
			var buyRequestSuccess:IncomingDataProxy = new IncomingDataProxy(MarketHandlers.BUY_REQUEST_SUCCESS, ApplicationFacade.INCOMING_MESSAGE);
			buyRequestSuccess.addDataParam(new DataParamString("message"));
			facade.registerProxy(buyRequestSuccess);
			
			var sellRequest:RequestProxy = new RequestProxy(MarketHandlers.SUBMIT_SELL_REQUEST);
			sellRequest.addRequestParam(new DataParamInt("AssetId"));
			sellRequest.addRequestParam(new DataParamNumber("Quantity"));
			sellRequest.addRequestParam(new DataParamInt("Option"));
			sellRequest.addRequestParam(new DataParamString("Owner"));
			this.facade.registerProxy(sellRequest);
			facade.registerProxy(new IncomingDataErrorProxy(MarketHandlers.SELL_REQUEST_ERROR));
			
			var sellRequestSuccess:IncomingDataProxy = new IncomingDataProxy(MarketHandlers.SELL_REQUEST_SUCCESS, ApplicationFacade.INCOMING_MESSAGE);
			sellRequestSuccess.addDataParam(new DataParamString("message"));
			facade.registerProxy(sellRequestSuccess);
			
			var buyFormProxy:FormProxy = new FormProxy(MarketHandlers.BUY_FORM);
			//var formValues:Array = [new FormFieldOption("Personal", "P"), new FormFieldOption("Household", "H")];
			//buyFormProxy.addRadioButton(MarketHandlers.BUY_SELL_HOUSEHOLD_PERSONAL, "Trade", formValues);
			buyFormProxy.addBackendData(MarketHandlers.BUY_SELL_HOUSEHOLD_PERSONAL);
			buyFormProxy.addDisplayText(MarketHandlers.BUY_SELL_GOODS, "Goods");
			buyFormProxy.addDisplayText(MarketHandlers.BUY_SELL_PRICE, "Price");
			buyFormProxy.addTextField(MarketHandlers.BUY_SELL_QTY, "Quantity");
			buyFormProxy.addDisplayText(MarketHandlers.BUY_SELL_TOTAL, "Total");
			buyFormProxy.addBackendData(MarketHandlers.BUY_SELL_ASSETID);
			buyFormProxy.addButton("Buy", MarketHandlers.BUY_SELL_BUY);
			buyFormProxy.addButton("Cancel", MarketHandlers.BUY_SELL_CANCEL);
			facade.registerProxy(buyFormProxy);
			buyFormProxy.updateFieldValue(MarketHandlers.BUY_SELL_HOUSEHOLD_PERSONAL, "H");
			
			var sellFormProxy:FormProxy = new FormProxy(MarketHandlers.SELL_FORM);
			//sellFormProxy.addRadioButton(MarketHandlers.BUY_SELL_HOUSEHOLD_PERSONAL, "Trade", formValues);
			sellFormProxy.addBackendData(MarketHandlers.BUY_SELL_HOUSEHOLD_PERSONAL);
			sellFormProxy.addDisplayText(MarketHandlers.BUY_SELL_GOODS, "Goods");
			sellFormProxy.addDisplayText(MarketHandlers.BUY_SELL_PRICE, "Price");
			sellFormProxy.addTextField(MarketHandlers.BUY_SELL_QTY, "Quantity");
			sellFormProxy.addDropDown(MarketHandlers.BUY_SELL_OPTIONS, "Options");
			sellFormProxy.addDisplayText(MarketHandlers.BUY_SELL_TOTAL, "Total");
			sellFormProxy.addBackendData(MarketHandlers.BUY_SELL_ASSETID);
			sellFormProxy.addButton("Sell", MarketHandlers.BUY_SELL_SELL);
			sellFormProxy.addButton("Cancel", MarketHandlers.BUY_SELL_CANCEL);
			facade.registerProxy(sellFormProxy);
			sellFormProxy.updateFieldValue(MarketHandlers.BUY_SELL_HOUSEHOLD_PERSONAL, "H");
			sellFormProxy.showHideFields([MarketHandlers.BUY_SELL_OPTIONS], []);
			
			var marketAssetUpdate:IncomingDataProxy = new IncomingDataProxy(MarketHandlers.INSTOCK_MARKET_ASSETS_UPDATED, MarketHandlers.INSTOCK_MARKET_ASSETS_UPDATED);
			marketAssetUpdate.addDataParam(new DataParamArrayMarketAsset("AssetDetails"));
			facade.registerProxy(marketAssetUpdate);
			
			var subMenuProxy:SubMenuListProxy = new SubMenuListProxy();
			facade.registerProxy(subMenuProxy);
			subMenuProxy.addSubMenuItem(MarketHandlers.SUB_MENU_STOCKS);
			subMenuProxy.addSubMenuItem(MarketHandlers.SUB_MENU_BUY);
			subMenuProxy.addSubMenuItem(MarketHandlers.SUB_MENU_SELL);
			subMenuProxy.addSubMenuItem(MarketHandlers.SUB_MENU_ASSETS);
			subMenuProxy.setDefaultMenuItem(MarketHandlers.SUB_MENU_STOCKS);
		}
		private function removeProxies():void {
			facade.removeProxy(MarketHandlers.INSTOCK_MARKET_ASSETS + RequestProxy.NAME);
			facade.removeProxy(MarketHandlers.INSTOCK_MARKET_ASSET_DETAILS + IncomingDataProxy.NAME);
			facade.removeProxy(MarketHandlers.INSTOCK_MARKET_ASSET_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(MarketHandlers.PLAYER_CURRENT_ASSETS + RequestProxy.NAME);
			facade.removeProxy(MarketHandlers.PLAYER_CURRENT_ASSET_DETAILS + IncomingDataProxy.NAME);
			facade.removeProxy(MarketHandlers.PLAYER_CURRENT_ASSETS_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(MarketHandlers.BUY_FORM);
			facade.removeProxy(MarketHandlers.SELL_FORM);
			facade.removeProxy(MarketHandlers.SUBMIT_BUY_REQUEST + RequestProxy.NAME);
			facade.removeProxy(MarketHandlers.BUY_REQUEST_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(MarketHandlers.BUY_REQUEST_SUCCESS + IncomingDataProxy.NAME);
			facade.removeProxy(MarketHandlers.SUBMIT_SELL_REQUEST + RequestProxy.NAME);
			facade.removeProxy(MarketHandlers.MARKET_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(MarketHandlers.INSTOCK_MARKET_ASSETS_UPDATED + IncomingDataProxy.NAME);
			facade.removeProxy(SubMenuListProxy.NAME);
			facade.removeProxy(MarketAssetsListProxy.NAME);
		}
		override public function getName():String{
			return NAME;
		}
	}
}
