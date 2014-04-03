/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import uk.ac.sussex.model.valueObjects.AssetAmount;
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class InStockAssetList extends MovieClip {
		private var listObject:TitledTwoColumnScrollingList;
		
		public function InStockAssetList() {
			listObject = new TitledTwoColumnScrollingList();
			this.addChild(listObject);
		}
		public function setTitleLabel(newLabel:String):void {
			listObject.setTitleLabel(newLabel);
		}
		public function addAssets(myAssets:Array):void {
			listObject.setSelectedItem(null);
			listObject.clearList();
			for each (var marketAsset:AssetAmount in myAssets){
				addAsset(marketAsset);
			}
		}
		public function addAsset(newAsset:AssetAmount):void {
			var assetItem:InStockAssetListItem = new InStockAssetListItem();
			assetItem.setAsset(newAsset.getAsset());
			var erroritem:Boolean = newAsset.getAmount()<=0;
			assetItem.itemError(erroritem);
			var mouseovertext:String = newAsset.getAsset().getName();
			if(erroritem){
				mouseovertext += " NO STOCK";
			}
			assetItem.setMouseoverText(mouseovertext);
			
			listObject.addItem(assetItem);
		}
		public function getSelectedAsset():GameAsset {
			var currentItem:InStockAssetListItem = listObject.getSelectedListItem() as InStockAssetListItem;
			if(currentItem!=null){
				return currentItem.getAsset() as GameAsset;
			} 
		}
		public function destroy():void {
			listObject.destroy();
		}
	}
}
