package uk.ac.sussex.controller {
	import org.puremvc.as3.multicore.interfaces.INotification;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import uk.ac.sussex.general.ApplicationFacade;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class DisplayServerErrorMessageCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var message:String = incomingData.getParamValue("message") as String;
			trace("DisplayServerErrorMessageCommand sez: I am displaying a server error: " + message);
			sendNotification(ApplicationFacade.DISPLAY_ERROR_MESSAGE, message);
		}
	}
}
