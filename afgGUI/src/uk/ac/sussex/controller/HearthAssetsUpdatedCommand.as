package uk.ac.sussex.controller {
	//import uk.ac.sussex.model.valueObjects.GameAsset;
	//import uk.ac.sussex.model.GameAssetListProxy;
	import uk.ac.sussex.model.HearthAssetListProxy;
	//import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.valueObjects.HearthAsset;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class HearthAssetsUpdatedCommand extends SimpleCommand {
		override public function execute( note:INotification ):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			if(incomingData!= null){
				var assetListProxy:HearthAssetListProxy = facade.retrieveProxy(HearthAsset.OWNER_HEARTH + HearthAssetListProxy.NAME) as HearthAssetListProxy;
				if(assetListProxy != null){
					
					var assetArray:Array = incomingData.getParamValue("HearthAssets") as Array;
				
					for each (var asset:HearthAsset in assetArray) {
						assetListProxy.addHearthAsset(asset);
					}
				}
				
			}
		}
	}
}