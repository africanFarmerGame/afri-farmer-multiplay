package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class DietaryRequirement {
		private var type:int;
		private var level:String;
		private var protein:int;
		private var carbs:int;
		private var nutrients:int;
		
		public function getType():int {
			return type;
		}
		public function setType(newType:int):void {
			this.type = newType;
		}
		public function getLevel():String {
			return level;
		}
		public function setLevel(newLevel:String):void {
			this.level = newLevel;
		}
		public function getProtein():int {
			return protein;
		}
		public function setProtein(newProtein:int):void {
			this.protein = newProtein;
		}
		public function getCarbs():int {
			return carbs;
		}
		public function setCarbs(newCarbs:int):void {
			this.carbs = newCarbs;
		}
		public function getNutrients():int {
			return this.nutrients;
		}
		public function setNutrients(newNutrients:int):void {
			this.nutrients = newNutrients;
		}
	}
}
