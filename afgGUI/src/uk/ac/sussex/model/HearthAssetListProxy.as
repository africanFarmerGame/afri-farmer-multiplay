/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model {
	import uk.ac.sussex.model.valueObjects.HearthAsset;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	/**
	 * @author em97
	 */
	public class HearthAssetListProxy extends Proxy implements IProxy {
		public static const NAME:String= "HearthAssetListProxy";
		public function HearthAssetListProxy(assetOwner:String) {
			super(assetOwner+NAME, new Array());
		}
		public function addHearthAsset(newHearthAsset:HearthAsset):void {
			//Check if this is here already, and if so update instead.
			var newAssetId:int = newHearthAsset.getAsset().getId();
			var found:Boolean = false;
			for each (var asset:HearthAsset in hearthAssets ){
				if(asset.getAsset().getId()==newAssetId){
					asset.setAmount(newHearthAsset.getAmount());
					found = true;
					break;
				}
			}
			if(!found){
				hearthAssets.push(newHearthAsset);
			}
		}
		public function fetchHearthAssets():Array {
			return hearthAssets.sort(sortOnAssetName);
		}
		public function fetchSalableHearthAssets():Array {
			var salableAssets:Array = new Array();
			for each(var asset:HearthAsset in hearthAssets){
				if(asset.getAmount()>0){
					if(asset.getAsset().getName().toUpperCase()!="CASH"){
						salableAssets.push(asset);
					}
				}
			}
			return salableAssets.sort(sortOnAssetName);
		}
		public function fetchNonZeroHearthAssets():Array {
			var nonZeroAssets:Array = new Array();
			for each(var asset:HearthAsset in hearthAssets){
				if(asset.getAmount()>0){
					nonZeroAssets.push(asset);
				}
			}
			return nonZeroAssets.sort(sortOnAssetName);
		}
		public function fetchHearthAssetByAssetId(assetId:int):HearthAsset{
			for each (var asset:HearthAsset in hearthAssets ){
				if(asset.getAsset().getId()==assetId){
					return asset;
				}
			}
		}
		protected function get hearthAssets():Array {
			return data as Array;
		}
		private function sortOnAssetName(a:HearthAsset, b:HearthAsset):int{
			var aAssetName:String = a.getAsset().getName();
			var bAssetName:String = b.getAsset().getName();
			if(aAssetName>bAssetName){
				return 1;
			} else if (aAssetName<bAssetName){
				return -1;
			} else {
				return 0;
			}
			
		}
	}
}
