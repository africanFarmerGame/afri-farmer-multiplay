package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.AnyChar;
	import uk.ac.sussex.serverhandlers.CommsHandlers;
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import uk.ac.sussex.model.PCListProxy;
	import uk.ac.sussex.model.valueObjects.PlayerChar;

	/**
	 * @author em97
	 */
	public class PCEnterRoomCommand extends SimpleCommand {
		override public function execute(note:INotification):void{
				//Add the playerchar to the talkList. 
				var pc:PlayerChar = note.getBody() as PlayerChar;
				pc.setOnlineStatus(true);
				if(pc.getRole() != AnyChar.BANKER){
					var talkList:PCListProxy = facade.retrieveProxy(CommsHandlers.DIR_TALK_LIST) as PCListProxy;
					if(talkList == null){
						talkList = new PCListProxy(CommsHandlers.DIR_TALK_LIST);
						facade.registerProxy(talkList);
					}
					talkList.addPC(pc);
				}
		}			
	}
}
