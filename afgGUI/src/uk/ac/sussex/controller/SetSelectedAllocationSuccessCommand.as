package uk.ac.sussex.controller {
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import uk.ac.sussex.model.AllocationListProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SetSelectedAllocationSuccessCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var selectedAllocation:int = incomingData.getParamValue("AllocationId") as int;
			var message:String = incomingData.getParamValue("message") as String;
			var allocationLP:AllocationListProxy = facade.retrieveProxy(AllocationListProxy.NAME) as AllocationListProxy;
			allocationLP.setSelectedAllocation(selectedAllocation);
			sendNotification(ApplicationFacade.DISPLAY_MESSAGE, message);
		}
	}
}
