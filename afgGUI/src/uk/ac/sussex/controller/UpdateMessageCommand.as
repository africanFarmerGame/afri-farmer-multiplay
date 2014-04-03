package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.Message;
	import uk.ac.sussex.serverhandlers.CommsHandlers;
	import uk.ac.sussex.model.RequestProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class UpdateMessageCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var tm:Message = note.getBody() as Message;
			var updateTm:RequestProxy = facade.retrieveProxy(CommsHandlers.UPDATE_MESSAGE + RequestProxy.NAME) as RequestProxy;
			updateTm.setParamValue("Message", tm);
			updateTm.sendRequest();
		}
	}
}
