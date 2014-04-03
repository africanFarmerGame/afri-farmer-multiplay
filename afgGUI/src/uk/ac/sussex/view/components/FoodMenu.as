package uk.ac.sussex.view.components {
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class FoodMenu extends MovieClip {
		private var submenu:SubMenu;
		private var dietsList:InStockAssetList;
		
		private static const MAX_WIDTH:Number = 800;
		private static const BORDER:Number = 10;
		
		public function FoodMenu() {
			setupSubMenu();
			setupDietsList();
		}
		private function setupSubMenu():void{
			submenu = new SubMenu();
			submenu.addButton("Diet");
			submenu.addButton("Allocation");
			submenu.addButton("Select");
			submenu.addButton("Exit");
			submenu.x = BORDER;
			submenu.y = BORDER;
			this.addChild(submenu);
		}
		private function setupDietsList():void {
			dietsList = new InStockAssetList();
			dietsList.setTitleLabel("Diets & Allocations");
			dietsList.x = MAX_WIDTH - dietsList.width - BORDER;
			dietsList.y = BORDER;
			this.addChild(dietsList);
		}
	}
}
