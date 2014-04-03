package uk.ac.sussex.controller {
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.PlayerCharProxy;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.model.RequestProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SaveSelectedAllocationCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var allocationId:int = note.getBody() as int;
			
			var myChar:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
			
			var request:RequestProxy = facade.retrieveProxy(HomeHandlers.SET_SELECTED_ALLOCATION + RequestProxy.NAME) as RequestProxy;
			request.setParamValue("AllocationId", allocationId);
			request.setParamValue(HomeHandlers.HEARTH_ID, myChar.getPCHearthId());
			request.sendRequest();
		}
	}
}
