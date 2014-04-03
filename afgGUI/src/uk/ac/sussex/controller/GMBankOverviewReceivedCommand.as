package uk.ac.sussex.controller {
	import uk.ac.sussex.serverhandlers.BankHandlers;
	import uk.ac.sussex.model.HearthsFinancialStatusProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class GMBankOverviewReceivedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("GMBankOverviewReceivedCommand sez: Awakened... to store financial details");
			
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var fsProxy:HearthsFinancialStatusProxy = facade.retrieveProxy(HearthsFinancialStatusProxy.NAME) as HearthsFinancialStatusProxy;
			if(fsProxy == null){
				throw new Error("The HearthsFinancialStatusProxy is null.");
			}
			var fsArray:Array = incomingData.getParamValue(BankHandlers.GM_OVERVIEW_HEARTH_DETAILS) as Array;
			if(fsArray==null){
				throw new Error("The incoming data array was null.");
			}
			fsProxy.addHouseholdStatuses(fsArray);
		}
	}
}
