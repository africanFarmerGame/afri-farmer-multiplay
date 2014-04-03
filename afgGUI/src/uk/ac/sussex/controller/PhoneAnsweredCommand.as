package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.TalkMessage;
	import uk.ac.sussex.model.CallInProgressProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class PhoneAnsweredCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var answered:Number = incomingData.getParamValue("Answered") as Number;
			
			var callInProgressProxy:CallInProgressProxy = facade.retrieveProxy(CallInProgressProxy.NAME) as CallInProgressProxy;
			if(callInProgressProxy!=null){
				callInProgressProxy.answerCall(answered);
				
				var callAnsweredMessage:TalkMessage = new TalkMessage();
				callAnsweredMessage.setAuthorId(-1);
				callAnsweredMessage.setAuthorName("System");
				callAnsweredMessage.setMessage("The call has been answered.");
				callInProgressProxy.addCallMessage(callAnsweredMessage);
			} else {
				//It really shouldn't be at this point...
				throw new Error("The callInProgressproxy was null!");
			}
			
			
		}
	}
}
