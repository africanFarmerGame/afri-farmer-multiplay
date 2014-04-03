package uk.ac.sussex.controller {
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.serverhandlers.FarmHandlers;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class DeleteHouseholdTaskCommand extends SimpleCommand {
		
		override public function execute(note:INotification):void {
			trace("DeleteHouseholdTaskCommand sez: I has been fired.");
			var selectedId:String = note.getBody() as String;
			trace("DeleteHouseholdTaskCommand sez: The id selected is " + selectedId);
			var deleteProxy:RequestProxy = facade.retrieveProxy(FarmHandlers.DELETE_HOUSEHOLD_TASK + RequestProxy.NAME) as RequestProxy;
			if(deleteProxy != null && selectedId != null){
				var selectedintId:int = int(selectedId);
				deleteProxy.setParamValue(FarmHandlers.TASK_ID, selectedintId);
				deleteProxy.sendRequest();
			}
		}
	}
}
