package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class SeasonStage {
		private var name:String;
		private var displayOrder:int;
		private var current:Boolean = false;
		
		public function getName():String {
			return this.name;
		}
		public function setName(newName:String):void {
			this.name = newName;
		}
		public function getDisplayOrder():int {
			return this.displayOrder;
		}
		public function setDisplayOrder(newDisplayOrder:int):void {
			this.displayOrder = newDisplayOrder;
		}
		public function setCurrent(isCurrent:Boolean):void {
			this.current = isCurrent;
		}
		public function getCurrent():Boolean {
			return this.current;
		} 
	}
}
