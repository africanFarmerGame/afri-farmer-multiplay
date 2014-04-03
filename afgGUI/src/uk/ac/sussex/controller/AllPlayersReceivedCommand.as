package uk.ac.sussex.controller {
	import uk.ac.sussex.model.IncomingDataProxy;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import uk.ac.sussex.serverhandlers.CommsHandlers;
	import uk.ac.sussex.model.PCListProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class AllPlayersReceivedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("AllPlayersReceivedCommand sez: I have been executed - " + note.getName());
			var allPlayersProxy:PCListProxy = facade.retrieveProxy(CommsHandlers.DIR_ALL_PCS) as PCListProxy;
			if(allPlayersProxy == null){
				allPlayersProxy = new PCListProxy(CommsHandlers.DIR_ALL_PCS);
				facade.registerProxy(allPlayersProxy);
			}
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var players:Array = incomingData.getParamValue("players") as Array;
			allPlayersProxy.addManyPCs(players);
			
			//Unregister the request and incoming data proxies. 
			facade.removeProxy(CommsHandlers.FETCH_ALL_PLAYERS + RequestProxy.NAME);
			facade.removeProxy(CommsHandlers.ALL_PLAYERS_RECEIVED + IncomingDataProxy.NAME);
		}
	}
}
