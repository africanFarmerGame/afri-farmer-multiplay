package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import uk.ac.sussex.model.GameAssetListProxy;
	import uk.ac.sussex.model.HearthAssetListProxy;
	import uk.ac.sussex.model.valueObjects.HearthAsset;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class HomeHearthAssetsReceivedCommand extends SimpleCommand {
		override public function execute( note:INotification ):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			if(incomingData!= null){
				var assetListProxy:HearthAssetListProxy = facade.retrieveProxy(HearthAsset.OWNER_HEARTH + HearthAssetListProxy.NAME) as HearthAssetListProxy;
				if(assetListProxy == null){
					assetListProxy = new HearthAssetListProxy(HearthAsset.OWNER_HEARTH);
					facade.registerProxy(assetListProxy); 
				}
				var gameAssetListProxy:GameAssetListProxy = facade.retrieveProxy(GameAssetListProxy.NAME) as GameAssetListProxy;
				if(gameAssetListProxy != null){
					var assetArray:Array = incomingData.getParamValue("HearthAssets") as Array;
				
					for each (var asset:HearthAsset in assetArray) {
						var gameAsset:GameAsset = gameAssetListProxy.getGameAsset(asset.getAsset().getId());
						asset.setAsset(gameAsset);
						assetListProxy.addHearthAsset(asset);
					}
				} else {
					throw new Error("The game asset list proxy was null.");
				}
				
			}
			
		}
	}
}
