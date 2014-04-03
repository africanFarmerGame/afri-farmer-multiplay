package uk.ac.sussex.controller {
	import uk.ac.sussex.model.IncomingDataProxy;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.serverhandlers.SeasonsHandlers;
	import uk.ac.sussex.model.SeasonsListProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SeasonsListReceived extends SimpleCommand {
		override public function execute( note:INotification ):void {
			trace("SeasonsListReceived sez: We done received some seasons.");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var seasons:Array = incomingData.getParamValue("AllSeasons") as Array;
			
			var seasonsListProxy:SeasonsListProxy = facade.retrieveProxy(SeasonsListProxy.NAME) as SeasonsListProxy;
			if(seasonsListProxy == null){
				seasonsListProxy = new SeasonsListProxy();
				facade.registerProxy(seasonsListProxy);
			}
			seasonsListProxy.addManySeasons(seasons);
			
			facade.removeProxy(SeasonsHandlers.GET_SEASONS + RequestProxy.NAME);
			facade.removeProxy(SeasonsHandlers.SEASONS_LIST + IncomingDataProxy.NAME);
			facade.removeCommand(SeasonsHandlers.SEASONS_LIST);
		}
	}
}
