package uk.ac.sussex.controller {
	import uk.ac.sussex.model.ServerRoomProxy;
	import uk.ac.sussex.general.ApplicationFacade;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class DisplayGameInfoCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var infoTitle:String = "African Farmer";
			var infoMessage:String = "Written by Eleanor Martin, James Jackson and Judith Good (University of Sussex) for the Future Agricultures Consortium";
			//This bit is not necessarily available at this point. I can check and put it in if it is available, but probably ought to be at the end.
			var roomProxy:ServerRoomProxy = facade.retrieveProxy(ServerRoomProxy.NAME) as ServerRoomProxy;
			var gameType:String = "";
			if(roomProxy!=null){
				gameType = "\n\nYou are playing the " + roomProxy.getGameType() + " game version.";
			}
			var versionMessage:String = "Current release version: " + ApplicationFacade.CURRENT_VERSION;
			
			var totalMessage:String = infoTitle + "\n\n" + infoMessage + "\n\n" + versionMessage + gameType ;
			
			sendNotification(ApplicationFacade.DISPLAY_MESSAGE, totalMessage);
		}
	}
}
