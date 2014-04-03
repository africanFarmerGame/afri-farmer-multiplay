package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class ViewStatus {
		private var viewName:String;
		private var status:int;
		public function getViewName():String{
			return viewName;
		}
		public function setViewName(newName:String):void {
			this.viewName = newName;
		}
		public function getStatus():int {
			return status;
		}
		public function setStatus(newStatus:int):void {
			this.status = newStatus;
		}
	}
}
