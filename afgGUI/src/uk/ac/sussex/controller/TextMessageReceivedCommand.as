package uk.ac.sussex.controller {
	import uk.ac.sussex.model.TextMessageListProxy;
	import uk.ac.sussex.model.valueObjects.TextMessage;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class TextMessageReceivedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("TextMessageReceivedCommand sez: I have received a text message");
			var incoming:IncomingData = note.getBody() as IncomingData;
			var textMessage:TextMessage = incoming.getParamValue("textMessage") as TextMessage;
			var tmlp:TextMessageListProxy = facade.retrieveProxy(TextMessageListProxy.NAME) as TextMessageListProxy;
			tmlp.addText(textMessage);
		}
	}
}
