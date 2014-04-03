package uk.ac.sussex.model {
	import uk.ac.sussex.model.valueObjects.HouseholdStatus;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.interfaces.IProxy;

	/**
	 * @author em97
	 */
	public class HearthsViewStatusProxy extends Proxy implements IProxy {
		public static const NAME:String = "HearthsViewStatusProxy";
		public static const STATUSES_ADDED:String = "HearthsViewStatusesAdded";
		public function HearthsViewStatusProxy() {
			super(NAME, new Array());
		}
		public function addHouseholdStatuses(statuses:Array):void {
			for each (var status:HouseholdStatus in statuses){
				householdList.push(status);
				trace("HearthsViewStatusProxy sez: I has a status added. "  + status.getHouseholdId());
			}
			sendNotification(STATUSES_ADDED);
		}
		public function getHouseholdStatuses():Array{
			return householdList.sort(orderById);
		}
		private function get householdList():Array {
			return data as Array;
		}
		private function orderById(a:HouseholdStatus, b:HouseholdStatus):int {
			var aId:int = a.getHouseholdId();
			var bId:int = b.getHouseholdId();
			
			if(aId>bId){
				return 1;
			} else if (aId<bId){
				return -1;
			} else {
				return 0;
			}
		}
	}
}
