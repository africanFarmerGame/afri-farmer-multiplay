package uk.ac.sussex.controller {
	import uk.ac.sussex.serverhandlers.VillageHandlers;
	import uk.ac.sussex.model.RequestProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	/**
	 * @author em97
	 */
	public class HearthIconSelectedCommand extends SimpleCommand {
		override public function execute( note:INotification ):void {
			var selectedHearthId:int = note.getBody() as int;
			var hearthAssetRequest:RequestProxy = facade.retrieveProxy(VillageHandlers.GET_HEARTH_ASSETS + RequestProxy.NAME) as RequestProxy;
			if(hearthAssetRequest == null){
				trace("HearthIconSelectedCommand sez: we has a problem, I can't find the request proxy.");
			} else {
				hearthAssetRequest.setParamValue("hearthId", selectedHearthId);
				hearthAssetRequest.sendRequest();
			}
		}
	}
}
