package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.MarketAsset;
	import uk.ac.sussex.model.MarketAssetsListProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class UpdateInStockMarketAssetsCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("UpdateInStockMarketAssetsCommand sez: We have received assets to update.");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var assetsList:Array = incomingData.getParamValue("AssetDetails") as Array;
			
			var assetsLP:MarketAssetsListProxy = facade.retrieveProxy(MarketAssetsListProxy.NAME) as MarketAssetsListProxy;
			
			for each (var asset:MarketAsset in assetsList){
				assetsLP.updateAsset(asset);
			}
		}
	}
}
