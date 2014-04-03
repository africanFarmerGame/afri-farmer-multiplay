package uk.ac.sussex.controller {
	import uk.ac.sussex.model.GMHouseholdDataProxy;
	import uk.ac.sussex.model.valueObjects.GMHouseholdData;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class GMFoodUpdatedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var householdDetail:GMHouseholdData = incomingData.getParamValue("gm_food_update") as GMHouseholdData;
			var householdProxy:GMHouseholdDataProxy = facade.retrieveProxy(GMHouseholdDataProxy.NAME) as GMHouseholdDataProxy;
			if(householdProxy!=null && householdDetail!=null){
				var newData:Array = new Array(householdDetail);
				householdProxy.addHouseholdFoodData(newData);
			}
		}
	}
}
