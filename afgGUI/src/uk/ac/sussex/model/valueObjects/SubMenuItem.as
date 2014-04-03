package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class SubMenuItem {
		private var buttonOrder:int;
		private var displayName:String;
		private var menuDefault:Boolean;
		private var displayStages:Array;
		
		public function SubMenuItem(buttonOrder:int, displayName:String, displayStages:Array = null){
			this.buttonOrder = buttonOrder;
			this.displayName = displayName;
			this.displayStages = displayStages;
			this.menuDefault = false;
		}
		public function getButtonOrder():int {
			return this.buttonOrder;
		}
		public function getDisplayName():String {
			return this.displayName;
		}
		public function displayThisButton(stageName:String):Boolean{
			stageName = stageName.toUpperCase();
			if(this.displayStages==null){
				return true;
			} else {
				for each (var displayStage:String in displayStages){
					if(stageName.search(displayStage)>=0){
						return true;
					}
				}
			}
			return false;
		}
		public function getMenuDefault():Boolean {
			 return this.menuDefault;
		}
		public function setMenuDefault(isDefault:Boolean):void {
			this.menuDefault = isDefault;
		}
	}
}
