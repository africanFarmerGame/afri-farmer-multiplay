package uk.ac.sussex.controller {
	import uk.ac.sussex.model.FormProxy;
	import uk.ac.sussex.serverhandlers.VillageHandlers;
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class VillageManagerStockItemSelectCommand extends SimpleCommand {
		override public function execute(note:INotification):void{
    		trace("VillageManagerStockItemSelectCommand sez: I got fired.");
	  		var asset:GameAsset = note.getBody() as GameAsset;
			var giveFormProxy:FormProxy = facade.retrieveProxy(VillageHandlers.GIVE_FORM) as FormProxy;
			if(giveFormProxy == null){
				throw new Error("Unable to retrieve the form proxy for the give form.");
			}
			if(asset==null){
				giveFormProxy.updateFieldValue(VillageHandlers.GIVE_ASSET, null);
				giveFormProxy.updateFieldValue(VillageHandlers.GIVE_ASSET_ID, null);
			} else {
				giveFormProxy.updateFieldValue(VillageHandlers.GIVE_ASSET, asset.getName());
				giveFormProxy.updateFieldValue(VillageHandlers.GIVE_ASSET_ID, asset.getId().toString());
			}
   		}
	}
}
