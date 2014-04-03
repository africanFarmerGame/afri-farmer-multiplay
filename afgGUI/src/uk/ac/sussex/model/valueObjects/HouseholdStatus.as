package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class HouseholdStatus {
		private var householdId:int;
		private var householdName:String;
		private var housenumber:int;
		private var viewStatuses:Array;
		
		public function getHouseholdId():int {
			return householdId;
		}
		public function setHouseholdId(newId:int):void {
			this.householdId = newId;
		}
		public function getViewStatuses():Array {
			return this.viewStatuses;
		}
		public function setViewStatuses(newStatuses:Array):void {
			this.viewStatuses = newStatuses;
		}
		public function getViewStatus(viewName:String):ViewStatus {
			for each (var viewStatus:ViewStatus in viewStatuses){
				if(viewStatus.getViewName()==viewName){
					return viewStatus;
				}
			}
			return null;
		}
		public function getHouseholdName():String {
			return householdName;
		}
		public function setHouseholdName(newName:String):void {
			householdName = newName;
		}
		public function getHousenumber():int {
			return housenumber;
		}
		public function setHousenumber(newNumber:int):void {
			this.housenumber = newNumber;
		}
	}
}
