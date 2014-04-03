package uk.ac.sussex.controller {
	import org.puremvc.as3.multicore.interfaces.INotification;
	import uk.ac.sussex.general.ApplicationFacade;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * This is a really simple command right now, but is hopefully going to be registered for a range of events throughout the app.
	 * @author em97
	 */
	public class ResetInfoTextCommand extends SimpleCommand {
		override public function execute( note:INotification ):void {
			sendNotification(ApplicationFacade.REVERT_TEMP_INFO_TEXT);
		}
	}
}
