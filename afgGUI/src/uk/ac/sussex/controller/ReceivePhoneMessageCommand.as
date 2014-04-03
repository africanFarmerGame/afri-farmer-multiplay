package uk.ac.sussex.controller {
	import uk.ac.sussex.model.CallInProgressProxy;
	import uk.ac.sussex.model.valueObjects.TalkMessage;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class ReceivePhoneMessageCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var message:String = incomingData.getParamValue("message") as String;
			var authorId:int = incomingData.getParamValue("authorid") as int;
			var authorname:String = incomingData.getParamValue("author") as String;
			
			var talkMessage:TalkMessage = new TalkMessage();
			talkMessage.setAuthorId(authorId);
			talkMessage.setAuthorName(authorname);
			talkMessage.setMessage(message);
			
			var callProxy:CallInProgressProxy = facade.retrieveProxy(CallInProgressProxy.NAME) as CallInProgressProxy;
			callProxy.addCallMessage(talkMessage);
			
		}
	}
}
