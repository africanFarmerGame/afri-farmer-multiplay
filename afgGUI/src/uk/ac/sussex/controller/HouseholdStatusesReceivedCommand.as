package uk.ac.sussex.controller {
	import uk.ac.sussex.model.HearthsViewStatusProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class HouseholdStatusesReceivedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("HouseholdStatusesReceivedCommand sez: I have been triggered");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var statuses:Array = incomingData.getParamValue("AllViewDetails") as Array;
			if(statuses!=null){
				var statusesProxy:HearthsViewStatusProxy = facade.retrieveProxy(HearthsViewStatusProxy.NAME) as HearthsViewStatusProxy;
				if(statusesProxy == null){
					statusesProxy = new HearthsViewStatusProxy();
					facade.registerProxy(statusesProxy);
				}
				statusesProxy.addHouseholdStatuses(statuses);
			}
		}
	}
}
