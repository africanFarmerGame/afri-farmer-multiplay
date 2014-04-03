package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class PlayerChar extends AnyChar{
		
		private var onlineStatus:Boolean = false;
		private var currentLocation:String;
		private var fieldCount:int;
		
		public function getOnlineStatus():Boolean {
			return this.onlineStatus;
		}
		public function setOnlineStatus(online:Boolean):void {
			this.onlineStatus = online;
		}
		public function getCurrentLocation():String {
			return this.currentLocation;
		}
		public function setCurrentLocation(loc:String):void {
			this.currentLocation = loc;
		}
		public function getFieldCount():int{
			return fieldCount;
		}
		public function setFieldCount(newFieldCount:int):void {
			this.fieldCount = newFieldCount;
		}
	}
}
