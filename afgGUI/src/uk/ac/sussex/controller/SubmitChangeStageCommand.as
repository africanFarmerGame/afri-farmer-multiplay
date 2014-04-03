package uk.ac.sussex.controller {
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.view.SubMenuMediator;
	import uk.ac.sussex.serverhandlers.SeasonsHandlers;
	import uk.ac.sussex.model.RequestProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SubmitChangeStageCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			//Retrieve the right requestProxy. 
			var changeRequest:RequestProxy = facade.retrieveProxy(SeasonsHandlers.SUBMIT_STAGE_CHANGE_REQUEST + RequestProxy.NAME) as RequestProxy;
			changeRequest.sendRequest();
			
			var submenu:SubMenuMediator = facade.retrieveMediator(SubMenuMediator.NAME) as SubMenuMediator;
			submenu.setCurrentSelection(HomeHandlers.GM_SUB_MENU_GAMEOVERVIEW);
		}
	}
}
