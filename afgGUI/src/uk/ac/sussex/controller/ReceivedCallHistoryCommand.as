package uk.ac.sussex.controller {
	import uk.ac.sussex.model.CallHistoryProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class ReceivedCallHistoryCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var incomingCalls:Array = incomingData.getParamValue("Incoming") as Array;
			var outgoingCalls:Array = incomingData.getParamValue("Outgoing") as Array;
			
			var callHistoryProxy:CallHistoryProxy = facade.retrieveProxy(CallHistoryProxy.NAME) as CallHistoryProxy;
			callHistoryProxy.addIncomingCalls(incomingCalls);
			callHistoryProxy.addOutgoingCalls(outgoingCalls);
			
			
		}
	}
}
