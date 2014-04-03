package uk.ac.sussex.controller {
	import uk.ac.sussex.model.PlayerCharProxy;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.model.valueObjects.Diet;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SaveDietCommand extends SimpleCommand {
		override public function execute (note:INotification):void {
			trace("SaveDietCommand sez: I haz been fired.");
			var diet:Diet = note.getBody() as Diet;
			var myChar:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
			var saveDietRequest:RequestProxy = facade.retrieveProxy(HomeHandlers.SAVE_DIET + RequestProxy.NAME) as RequestProxy;
			saveDietRequest.setParamValue("Diet", diet);
			saveDietRequest.setParamValue("hearthId", myChar.getPCHearthId());
			saveDietRequest.sendRequest();
			sendNotification(ApplicationFacade.SWITCH_SUBMENU_ITEM, HomeHandlers.DIET_SUB_MENU_OVERVIEW);
		}
	}
}
