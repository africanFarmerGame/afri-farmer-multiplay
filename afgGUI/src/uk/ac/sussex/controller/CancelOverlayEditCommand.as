package uk.ac.sussex.controller {
	import uk.ac.sussex.general.ApplicationFacade;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class CancelOverlayEditCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			sendNotification(ApplicationFacade.CLEAR_OVERLAY);
		}
	}
}
