package uk.ac.sussex.controller {
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.model.IncomingDataProxy;
	import uk.ac.sussex.serverhandlers.CommsHandlers;
	import uk.ac.sussex.model.TextMessageListProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class TextMessagesReceivedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var incoming:IncomingData = note.getBody() as IncomingData;
			var textMessages:Array = incoming.getParamValue("textMessages") as Array;
			var textMessageLP:TextMessageListProxy = facade.retrieveProxy(TextMessageListProxy.NAME) as TextMessageListProxy;
			if(textMessageLP ==  null) {
				textMessageLP = new TextMessageListProxy();
				facade.registerProxy(textMessageLP);
			}
			textMessageLP.addTexts(textMessages);
			
			//Remove the related proxies and commands.
			facade.removeProxy(CommsHandlers.TEXT_MESSAGES_RECEIVED + IncomingDataProxy.NAME);
			facade.removeProxy(CommsHandlers.TEXT_MESSAGES_ERROR + IncomingDataProxy.NAME);
			facade.removeProxy(CommsHandlers.FETCH_TEXT_MESSAGES + RequestProxy.NAME);
			facade.removeCommand(CommsHandlers.TEXT_MESSAGES_RECEIVED);
		}
	}
}
