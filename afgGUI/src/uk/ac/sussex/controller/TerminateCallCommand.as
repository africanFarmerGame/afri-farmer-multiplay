package uk.ac.sussex.controller {
	import uk.ac.sussex.model.CallInProgressProxy;
	import uk.ac.sussex.serverhandlers.CommsHandlers;
	import uk.ac.sussex.model.RequestProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class TerminateCallCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var callProxy:CallInProgressProxy = facade.retrieveProxy(CallInProgressProxy.NAME) as CallInProgressProxy;
			
			var terminateCall:RequestProxy = facade.retrieveProxy(CommsHandlers.END_CALL + RequestProxy.NAME) as RequestProxy;
			terminateCall.setParamValue("CallId", callProxy.getCallId());
			terminateCall.sendRequest();
		}
	}
}
