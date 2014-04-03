package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import uk.ac.sussex.general.ApplicationFacade;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class DisplayServerMessageCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var message:String = incomingData.getParamValue("message") as String;
			sendNotification(ApplicationFacade.DISPLAY_MESSAGE, message);
		}
	}
}
