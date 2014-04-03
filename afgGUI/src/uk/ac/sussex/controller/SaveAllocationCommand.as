package uk.ac.sussex.controller {
	import uk.ac.sussex.model.PlayerCharProxy;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.model.valueObjects.Allocation;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SaveAllocationCommand extends SimpleCommand {
		override public function execute (note:INotification):void {
			trace("SaveAllocationCommand sez: I haz been fired.");
			var allocation:Allocation = note.getBody() as Allocation;
			var myChar:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
			var saveAllocationRequest:RequestProxy = facade.retrieveProxy(HomeHandlers.SAVE_ALLOCATION + RequestProxy.NAME) as RequestProxy;
			saveAllocationRequest.setParamValue("Allocation", allocation);
			saveAllocationRequest.setParamValue("hearthId", myChar.getPCHearthId());
			saveAllocationRequest.sendRequest();
			sendNotification(ApplicationFacade.SWITCH_SUBMENU_ITEM, HomeHandlers.DIET_SUB_MENU_OVERVIEW);
		}
	}
}
