package uk.ac.sussex.controller {
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.interfaces.*;

	import uk.ac.sussex.general.ApplicationFacade;
	
	/**
	 * @author em97
	 */
	public class LostConnectionCommand extends SimpleCommand {
		override public function execute(note:INotification):void{
			sendNotification(ApplicationFacade.DISPLAY_MESSAGE, "Lost server connection, please log in again.");
			sendNotification(ApplicationFacade.LOGOUT_SUCCESSFUL);
		}
	}
}
