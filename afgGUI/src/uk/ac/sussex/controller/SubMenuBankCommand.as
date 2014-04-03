package uk.ac.sussex.controller {
	import uk.ac.sussex.states.FinesGameState;
	import uk.ac.sussex.serverhandlers.BankHandlers;
	import uk.ac.sussex.general.ApplicationFacade;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SubMenuBankCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("SubMenuBankCommand sez: I have been fired");
			var subMenuItem:String = note.getBody() as String;
			switch(subMenuItem){
				case BankHandlers.BANK_SUB_MENU_OVERVIEW:
					sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, "Overview:");
					break;
				case BankHandlers.BANK_SUB_MENU_FINES:
					sendNotification(ApplicationFacade.CHANGE_STATE, FinesGameState.NAME);
					break;
			}
		}
	}
}
