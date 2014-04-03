package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import uk.ac.sussex.model.valueObjects.TalkMessage;
	import uk.ac.sussex.model.CallInProgressProxy;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class PhoneCallEndedCommand extends SimpleCommand {
		private var endCallTimer:Timer;
		private const END_CALL_TIME:uint = 3000;
		
		override public function execute(note:INotification):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var message:String = incomingData.getParamValue("message") as String;
			
			trace("PhoneCallEndedCommand sez: I received this message - " + message);
			
			var callProxy:CallInProgressProxy = facade.retrieveProxy(CallInProgressProxy.NAME) as CallInProgressProxy;
			var callEndedMessage:TalkMessage = new TalkMessage();
			callEndedMessage.setAuthorId(-1);
			callEndedMessage.setAuthorName("System");
			callEndedMessage.setMessage(message);
			callProxy.addCallMessage(callEndedMessage);
			
			
			endCallTimer = new Timer(END_CALL_TIME);
			endCallTimer.repeatCount = 1;
			endCallTimer.addEventListener(TimerEvent.TIMER, clearCallEvent);
			endCallTimer.start();
		}
		private function clearCallEvent(e:TimerEvent):void {
			endCallTimer.stop();
			facade.removeProxy(CallInProgressProxy.NAME);
		}
	}
}
