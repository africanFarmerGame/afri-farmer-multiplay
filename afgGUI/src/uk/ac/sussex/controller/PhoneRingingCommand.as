package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.TalkMessage;
	import uk.ac.sussex.model.CallInProgressProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class PhoneRingingCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var callId:int = incomingData.getParamValue("CallId") as int;
			var callInProgressProxy:CallInProgressProxy = facade.retrieveProxy(CallInProgressProxy.NAME) as CallInProgressProxy;
			if(callInProgressProxy != null){
				callInProgressProxy.setCallId(callId);
				var ringingMessage:TalkMessage = new TalkMessage();
				ringingMessage.setAuthorId(-1);
				ringingMessage.setAuthorName("System");
				ringingMessage.setMessage(incomingData.getParamValue("message") as String);
				callInProgressProxy.addCallMessage(ringingMessage);
			}
			
			
		}
	}
}
