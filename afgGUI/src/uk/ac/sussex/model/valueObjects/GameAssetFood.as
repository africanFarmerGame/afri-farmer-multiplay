package uk.ac.sussex.model.valueObjects {

	/**
	 * @author em97
	 */
	public class GameAssetFood extends GameAssetCrop {
		private var protein:int;
		private var nutrients:int;
		private var carbs:int;
		
		public function GameAssetFood() {
			super();
		}
		public function getProtein():int {
			return protein;
		}
		public function setProtein(newProtein:int):void {
			this.protein = newProtein;
		}
		public function getNutrients():int {
			return nutrients;
		}
		public function setNutrients(newNutrients:int):void {
			this.nutrients = newNutrients;
		}
		public function getCarbs():int{
			return carbs;
		}
		public function setCarbs(newCarbs:int):void {
			this.carbs = newCarbs;
		}
		
	}
}
