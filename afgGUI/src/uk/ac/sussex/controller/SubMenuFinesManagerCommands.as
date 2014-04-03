package uk.ac.sussex.controller {
	import uk.ac.sussex.view.FinesGMOverviewListMediator;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.states.BankManagerGameState;
	import uk.ac.sussex.serverhandlers.BankHandlers;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SubMenuFinesManagerCommands extends SimpleCommand {
		override public function execute(note:INotification):void {
			
			var menuItem:String = note.getBody() as String;
			
			var finesOverview:FinesGMOverviewListMediator = facade.retrieveMediator(FinesGMOverviewListMediator.NAME) as FinesGMOverviewListMediator;
			if(finesOverview!=null){
				finesOverview.showList(false);
			}
			
			switch(menuItem){
				case BankHandlers.GM_FINES_SUB_MENU_LIST:
					finesOverview.showList(true);
					break;
				case BankHandlers.GM_FINES_SUB_MENU_EXIT:
					sendNotification(ApplicationFacade.CHANGE_STATE, BankManagerGameState.NAME);
					break;
			}
		}
	}
}
