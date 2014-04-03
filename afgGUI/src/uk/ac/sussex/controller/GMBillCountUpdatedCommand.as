package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import uk.ac.sussex.model.HearthsFinancialStatusProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class GMBillCountUpdatedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("GMBillCountUpdatedCommand sez: my my. I am activated.");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			if(incomingData == null){
				throw new Error("There was a problem with the incoming data.");
			}
			var fsProxy:HearthsFinancialStatusProxy = facade.retrieveProxy(HearthsFinancialStatusProxy.NAME) as HearthsFinancialStatusProxy;
			if(fsProxy!=null){
				var hearthId:int = incomingData.getParamValue("HearthId") as int;
				var billCount:int = incomingData.getParamValue("PendingFines") as int;
				var cashValue:Number = incomingData.getParamValue("HearthCash") as Number; 
				fsProxy.updateHouseholdBillCount(hearthId, billCount, cashValue);
			}
		}
	}
}
