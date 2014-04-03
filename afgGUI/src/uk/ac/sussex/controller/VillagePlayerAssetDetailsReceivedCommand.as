package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import uk.ac.sussex.model.valueObjects.HearthAsset;
	import uk.ac.sussex.model.GameAssetListProxy;
	import uk.ac.sussex.model.HearthAssetListProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class VillagePlayerAssetDetailsReceivedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("VillagePlayerAssetDetailsReceivedCommand sez: I am executed");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var playerAssets:Array = incomingData.getParamValue("PCAssetDetails") as Array;
			var hearthAssets:Array = incomingData.getParamValue("hearthAssetDetails") as Array;
			var gameAssetsLP:GameAssetListProxy = facade.retrieveProxy(GameAssetListProxy.NAME) as GameAssetListProxy;
			if(gameAssetsLP==null){
				throw new Error("The game assets list proxy is null.");
			}
			if(playerAssets!= null && playerAssets.length>0){
				var playerAssetsLP:HearthAssetListProxy = facade.retrieveProxy(HearthAsset.OWNER_PC + HearthAssetListProxy.NAME) as HearthAssetListProxy;
				if(playerAssetsLP == null) {
					playerAssetsLP = new HearthAssetListProxy(HearthAsset.OWNER_PC);
					facade.registerProxy(playerAssetsLP);
				}
				for each (var pcAsset:HearthAsset in playerAssets){
					var pcGA:GameAsset = gameAssetsLP.getGameAsset(pcAsset.getAsset().getId());
					pcAsset.setAsset(pcGA);
					playerAssetsLP.addHearthAsset(pcAsset);
				}
			}
			if(hearthAssets!=null && hearthAssets.length > 0) {
				var hearthAssetsLP:HearthAssetListProxy = facade.retrieveProxy(HearthAsset.OWNER_HEARTH + HearthAssetListProxy.NAME) as HearthAssetListProxy;
				if(hearthAssetsLP == null) {
					hearthAssetsLP = new HearthAssetListProxy(HearthAsset.OWNER_HEARTH);
					facade.registerProxy(hearthAssetsLP);
				}
				for each (var hAsset:HearthAsset in hearthAssets){
					var assetId:int = hAsset.getAsset().getId();
					var hearthGA:GameAsset = gameAssetsLP.getGameAsset(assetId);
					hAsset.setAsset(hearthGA);
					hearthAssetsLP.addHearthAsset(hAsset);
				}
			}
		}
	}
}
