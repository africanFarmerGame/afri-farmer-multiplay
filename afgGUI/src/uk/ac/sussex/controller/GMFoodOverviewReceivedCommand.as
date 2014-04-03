package uk.ac.sussex.controller {
	import uk.ac.sussex.model.GMHouseholdDataProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class GMFoodOverviewReceivedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("GMFoodOverviewReceivedCommand sez: Operation underway");
			
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var dataArray:Array = incomingData.getParamValue("gm_food_overview") as Array;
			var householdDataProxy:GMHouseholdDataProxy = facade.retrieveProxy(GMHouseholdDataProxy.NAME) as GMHouseholdDataProxy;
			if(householdDataProxy!=null){
				householdDataProxy.addHouseholdFoodData(dataArray);
			}
		}
	}
}
