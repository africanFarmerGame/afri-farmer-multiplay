package uk.ac.sussex.view.components {
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class FoodAllocationSelection extends MovieClip {
		private var tableTop:TableTopDisplay;
		private var dietAllocationList:DietAllocationList;
		
		private static const TABLE_SCREEN_X:Number = 0;
		private static const TABLE_SCREEN_Y:Number = 43;
		
		public function FoodAllocationSelection() {
			setup();
		}
		private function setup():void {
			tableTop = new TableTopDisplay();
			tableTop.x =  TABLE_SCREEN_X;
			tableTop.y = TABLE_SCREEN_Y;
			
			dietAllocationList = new DietAllocationList();
			dietAllocationList.setTitle("Diets & Allocations");
			dietAllocationList.x = tableTop.x + tableTop.width + 40;
			
			this.addChild(tableTop);
			this.addChild(dietAllocationList);
		}
	}
}
