/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model {
	import uk.ac.sussex.model.valueObjects.GameAssetFood;
	import uk.ac.sussex.model.valueObjects.GameAssetsList;
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	/**
	 * @author em97
	 */
	public class GameAssetListProxy extends Proxy implements IProxy {
		public static const NAME:String = "GameAssetListProxy";
		public static const FOOD_ASSETS_ADDED:String = "GameAssetsFoodAdded";
		
		public function GameAssetListProxy() {
			super(NAME, new GameAssetsList());
			
		}
		public function addGameAssets(newAssets:Array):void {
			gameAssetList.addAssets(newAssets);
		}
		public function addFoodAssets(newAssets:Array):void {
			gameAssetList.addFoodAssets(newAssets);
			sendNotification(FOOD_ASSETS_ADDED);
		}
		public function addCropAssets(newAssets:Array):void {
			gameAssetList.addCropAssets(newAssets);
		}
		public function getGameAsset(assetId:int):GameAsset {
			var gameAssets:Array = gameAssetList.getAssets();
			for each (var asset:GameAsset in gameAssets){
				if (asset.getId()==assetId){
					return asset;
				}
			}
		}
		public function getFoodAssets():Array {
			return gameAssetList.getFoodAssets();
		}
		public function getFoodAsset(assetId:int):GameAssetFood {
			var foodAssetArray:Array = gameAssetList.getFoodAssets();
			for each (var asset:GameAssetFood in foodAssetArray){
				if (asset.getId()==assetId){
					return asset;
				}
			}
		}
		public function getAllGameAssets():Array {
			return gameAssetList.getAssets().sort(sortOnAssetName);
		}
		protected function get gameAssetList():GameAssetsList {
			return data as GameAssetsList;
		}
		private function sortOnAssetName(a:GameAsset, b:GameAsset):int {
			
			var aName:String = a.getName();
			var bName:String = b.getName();
			if(aName>bName){
				return 1;
			} else if (aName<bName) {
				return -1;
			} else {
				return 0;
			}
		}
	}
}
