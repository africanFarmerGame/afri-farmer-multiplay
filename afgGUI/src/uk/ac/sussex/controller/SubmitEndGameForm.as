package uk.ac.sussex.controller {
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.view.SubMenuMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SubmitEndGameForm extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("SubmitEndGameForm sez: Firing note " + note.getName());
			
			var submitProxy:RequestProxy = facade.retrieveProxy(HomeHandlers.SUBMIT_END_GAME + RequestProxy.NAME) as RequestProxy;
			if(submitProxy!=null){
				submitProxy.sendRequest();
			}
			
			var subMenuMediator:SubMenuMediator = facade.retrieveMediator(SubMenuMediator.NAME) as SubMenuMediator;
			subMenuMediator.setCurrentSelection(HomeHandlers.GM_SUB_MENU_GAMEOVERVIEW);
		}
	}
}
