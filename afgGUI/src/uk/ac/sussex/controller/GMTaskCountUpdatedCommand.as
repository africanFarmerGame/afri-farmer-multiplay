package uk.ac.sussex.controller {
	import uk.ac.sussex.model.GMHouseholdDataProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class GMTaskCountUpdatedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("GMTaskCountUpdatedCommand sez: Operation update underway");
			
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var householdId:int = incomingData.getParamValue("HearthId") as int;
			var pendingTaskCount:int = incomingData.getParamValue("PendingTaskCount") as int;
			trace("GMTaskCountUpdated sez: I'm updating hearth " + householdId + " to task count " + pendingTaskCount);
			var householdDataProxy:GMHouseholdDataProxy = facade.retrieveProxy(GMHouseholdDataProxy.NAME) as GMHouseholdDataProxy;
			if(householdDataProxy!=null){
				trace("GMTaskCountUpdated sez: The task data proxy is ok.");
				householdDataProxy.updateHouseholdTaskData(householdId, pendingTaskCount);
			}
		}
	}
}
