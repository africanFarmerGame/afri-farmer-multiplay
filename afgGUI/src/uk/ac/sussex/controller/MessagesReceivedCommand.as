package uk.ac.sussex.controller {
	import uk.ac.sussex.model.MessageListProxy;
	import uk.ac.sussex.serverhandlers.CommsHandlers;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class MessagesReceivedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("MessagesReceivedCommand sez: I have been triggered");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var messages:Array = incomingData.getParamValue(CommsHandlers.MESSAGES) as Array;
			var messagesLP:MessageListProxy = facade.retrieveProxy(MessageListProxy.NAME) as MessageListProxy;
			if(messages!=null && messagesLP!=null){
				messagesLP.addMessages(messages);
			} else {
				trace("MessagesReceivedCommand sez: either messages or messagesLP was null. Issue?");
			}
			
		}
	}
}
