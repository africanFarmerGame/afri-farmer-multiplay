package uk.ac.sussex.controller {
	import uk.ac.sussex.model.CallInProgressProxy;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.serverhandlers.CommsHandlers;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class AnswerPhoneCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var request:RequestProxy = facade.retrieveProxy(CommsHandlers.ANSWER_CALL + RequestProxy.NAME) as RequestProxy;
			var call:CallInProgressProxy = facade.retrieveProxy(CallInProgressProxy.NAME) as CallInProgressProxy;
			request.setParamValue("CallId", call.getCallId());
			request.sendRequest();
		}
	}
}
