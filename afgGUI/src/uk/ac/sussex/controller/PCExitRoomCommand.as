package uk.ac.sussex.controller {
	import uk.ac.sussex.serverhandlers.CommsHandlers;
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import uk.ac.sussex.model.PCListProxy;
	import uk.ac.sussex.model.valueObjects.PlayerChar;
	import uk.ac.sussex.model.PlayerCharProxy;
	import uk.ac.sussex.general.ApplicationFacade;

	/**
	 * @author em97
	 */
	public class PCExitRoomCommand extends SimpleCommand {
		override public function execute(note:INotification):void{
			trace ("PCExitRoomCommand sez: A PC has left the room, prepare to update the list.");
			var pc:PlayerChar = note.getBody() as PlayerChar; 
			var mypc:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
			//If this is a notification that my pc left the room, we'll already be dealing with the talk list elsewhere.
			if(pc.getId()!= mypc.getPlayerId()){
				var talkList:PCListProxy = facade.retrieveProxy(CommsHandlers.DIR_TALK_LIST) as PCListProxy;
				if(talkList == null){
					talkList = new PCListProxy(CommsHandlers.DIR_TALK_LIST);
					facade.registerProxy(talkList);
				}
				talkList.removePC(pc);
			}
		}
	}
}
