package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class GameAssetsList {
		private var allAssets:Array;
		private var foodAssets:Array;
		private var cropAssets:Array;
		public function GameAssetsList(){
			allAssets = new Array();
			foodAssets = new Array();
			cropAssets = new Array();
		}
		public function addAssets(newAssets:Array):void{
			for each (var asset:GameAsset in newAssets){
				//Should I check if the assets exist already or not? 
				trace("GameAssetsList sez: We are adding " + asset.getName() + " to the assets list");
				allAssets.push(asset);
			}
		}
		public function addFoodAssets(newAssets:Array):void {
			for each (var asset:GameAssetFood in newAssets){
				trace("GameAssetsList sez: We are adding " + asset.getName() + " to the food assets list");
				allAssets.push(asset);
				foodAssets.push(asset);
			}
		}
		public function addCropAssets(newAssets:Array):void {
			for each (var asset:GameAssetCrop in newAssets){
				trace("GameAssetsList sez: We are adding " + asset.getName() + " to the crop assets list");
				allAssets.push(asset);
				cropAssets.push(asset);
			}
		}
		public function getAssets():Array {
			return allAssets;
		}
		public function getFoodAssets():Array {
			return foodAssets;
		}
	}
}
