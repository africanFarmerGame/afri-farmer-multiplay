package uk.ac.sussex.controller {
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.interfaces.*;
	
	//import uk.ac.sussex.states.GameRoomState;
	import uk.ac.sussex.model.RequestProxy;
	
	/**
	 * @author em97
	 */
	public class CommsSendMessageTalk extends SimpleCommand {
		override public function execute( note:INotification ):void {
			trace("CommsSendMessageTalk sez: Trying to send a talk message");
			var playerMessage:String = note.getBody() as String;
			//Don't do anything if the length is too short. 
			if(playerMessage.length > 0){
				//Retrieve the right mediator, but if we can't then do nothing. 
				var sendTalkMessage:RequestProxy = facade.retrieveProxy("comms.talk" + RequestProxy.NAME) as RequestProxy;
				if(sendTalkMessage != null){
					sendTalkMessage.setParamValue("playermessage", playerMessage);
					sendTalkMessage.sendRequest();
				}
			}
		}
	}
}
