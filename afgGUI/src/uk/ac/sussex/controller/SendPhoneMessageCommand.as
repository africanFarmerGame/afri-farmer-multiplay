package uk.ac.sussex.controller {
	import uk.ac.sussex.serverhandlers.CommsHandlers;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.model.CallInProgressProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SendPhoneMessageCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var message:String = note.getBody() as String;
			trace("SendPhoneMessageCommand sez: I am trying to send message " + message);
			var callProxy:CallInProgressProxy = facade.retrieveProxy(CallInProgressProxy.NAME) as CallInProgressProxy;
			var requestProxy:RequestProxy = facade.retrieveProxy(CommsHandlers.TALK_PHONE_MESSAGE + RequestProxy.NAME) as RequestProxy;
			requestProxy.setParamValue("message", message);
			requestProxy.setParamValue("CallId", callProxy.getCallId());
			requestProxy.sendRequest();
		}
	}
}
