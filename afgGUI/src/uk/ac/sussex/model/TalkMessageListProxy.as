package uk.ac.sussex.model {
	import uk.ac.sussex.model.valueObjects.TalkMessage;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.interfaces.IProxy;

	/**
	 * @author em97
	 */
	public class TalkMessageListProxy extends Proxy implements IProxy {
		public static const NAME:String = "TalkMessageListProxy";
		public static const MESSAGE_ADDED:String = "TalkMessageAdded";
		public function TalkMessageListProxy() {
			super(NAME, data);
		}
		public function addMessage(newMessage:TalkMessage):void {
			talkMessages.push(newMessage);
			sendNotification(MESSAGE_ADDED, newMessage);
		}
		public function getMessages():Array {
			return talkMessages;
		}
		override public function onRegister():void{
			 data = new Array();
		}
		protected function get talkMessages():Array {
			return data as Array;
		}
	}
}
