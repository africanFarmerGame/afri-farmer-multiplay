package uk.ac.sussex.controller {
	import flash.display.Sprite;
	import uk.ac.sussex.model.valueObjects.MarketAsset;
	import uk.ac.sussex.model.valueObjects.HearthAsset;
	import uk.ac.sussex.model.HearthAssetListProxy;
	import uk.ac.sussex.model.MarketAssetsListProxy;
	import uk.ac.sussex.view.InStockAssetListMediator;
	import uk.ac.sussex.view.FormMediator;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.serverhandlers.MarketHandlers;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SubMenuMarketCommand extends SimpleCommand {
		override public function execute( note:INotification ):void {
			
			var subMenuItem:String = note.getBody() as String;
			var sellFormMediator:FormMediator = facade.retrieveMediator(MarketHandlers.SELL_FORM) as FormMediator;
			var buyFormMediator:FormMediator = facade.retrieveMediator(MarketHandlers.BUY_FORM) as FormMediator;
			var itemListMediator:InStockAssetListMediator = facade.retrieveMediator(InStockAssetListMediator.NAME) as InStockAssetListMediator;
			var marketAssetLP:MarketAssetsListProxy = facade.retrieveProxy(MarketAssetsListProxy.NAME) as MarketAssetsListProxy;
			var hearthAssetLP:HearthAssetListProxy = facade.retrieveProxy(HearthAsset.OWNER_HEARTH + HearthAssetListProxy.NAME) as HearthAssetListProxy;
			if(buyFormMediator!=null){
				facade.removeMediator(MarketHandlers.BUY_FORM);
			}
			if(sellFormMediator!=null){
				facade.removeMediator(MarketHandlers.SELL_FORM);
			}
			trace("SubMenuMarketCommand sez: Trying to fire off " + subMenuItem);
			switch(subMenuItem){
				case MarketHandlers.SUB_MENU_ASSETS:
					var hearthAssetsArray:Array = hearthAssetLP.fetchHearthAssets();
					itemListMediator.setListTitle("Hearth Assets");
					itemListMediator.setContents(hearthAssetsArray);
					var assetsSide:String = "Assets \n";
					for each (var homeAsset:HearthAsset in hearthAssetsArray){
						assetsSide += homeAsset.getAsset().getName() + ": " + homeAsset.getAmount() + " " + homeAsset.getAsset().getMeasurement() + "(s) \n";
					}
					sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, assetsSide);		
					break;
				case MarketHandlers.SUB_MENU_BUY:
					sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, "Buy");
					itemListMediator.setListTitle("Market Assets");
					itemListMediator.setContents(marketAssetLP.fetchAssets());
					buyFormMediator = new FormMediator(MarketHandlers.BUY_FORM, new Sprite());
					facade.registerMediator(buyFormMediator);
					buyFormMediator.setLabelWidth(70);
					buyFormMediator.addToViewArea();
					break;
				case MarketHandlers.SUB_MENU_PENDING:
					sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, "Pending");
					break;
				case MarketHandlers.SUB_MENU_SELL:
					sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, "Sell");
					itemListMediator.setListTitle("Hearth Assets");
					itemListMediator.setContents(hearthAssetLP.fetchSalableHearthAssets());
					sellFormMediator = new FormMediator(MarketHandlers.SELL_FORM, new Sprite());
					facade.registerMediator(sellFormMediator);		
					sellFormMediator.setLabelWidth(70);			
					sellFormMediator.addToViewArea();
					break;
				case MarketHandlers.SUB_MENU_STOCKS:
					itemListMediator.setListTitle("Market Assets");
					var assetsArray:Array = marketAssetLP.fetchAssets();
					if(marketAssetLP != null){
						itemListMediator.setContents(assetsArray);
					}
					var stocksSide:String = "Stocks \n";
					for each (var asset:MarketAsset in assetsArray){
						stocksSide += asset.getAsset().getName() + ": " + asset.getAmount() + " " + asset.getAsset().getMeasurement() + "(s) \n";
					}
					sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, stocksSide);
					break;
			}
		}
	}
}
