package uk.ac.sussex.controller {
	import uk.ac.sussex.serverhandlers.CommsHandlers;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.model.valueObjects.TextMessage;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class UpdateTextMessageCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var tm:TextMessage = note.getBody() as TextMessage;
			var updateTm:RequestProxy = facade.retrieveProxy(CommsHandlers.UPDATE_TEXT_MESSAGE + RequestProxy.NAME) as RequestProxy;
			updateTm.setParamValue("textMessage", tm);
			updateTm.sendRequest();
		}
	}
}
