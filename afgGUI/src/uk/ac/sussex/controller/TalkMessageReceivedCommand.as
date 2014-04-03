package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.TalkMessage;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import uk.ac.sussex.model.TalkMessageListProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class TalkMessageReceivedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("TalkMessageReceivedCommand sez: Eeee oop, I've been fired.");
			var talkMessageProxy:TalkMessageListProxy = facade.retrieveProxy(TalkMessageListProxy.NAME) as TalkMessageListProxy;
			var data:IncomingData = note.getBody() as IncomingData;
			var authorId:int = data.getParamValue("authorid") as int;
			var author:String = data.getParamValue("author") as String;
			var playerMessage:String = data.getParamValue("playermessage") as String;
			var talkMessage:TalkMessage = new TalkMessage();
			talkMessage.setAuthorId(authorId);
			talkMessage.setAuthorName(author);
			talkMessage.setMessage(playerMessage);
			talkMessageProxy.addMessage(talkMessage);
		}
	}
}
