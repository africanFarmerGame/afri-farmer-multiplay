/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class DietPlate extends MovieClip {
		private var plate:Plate2_mc;
		private var numTypes:int = 3;
		private var position_contents:Array;
		private var foodStuffs:Array;
		
		public static const DRAGGING_FOOD:String = "DraggingFood";
		public static const PLATE_CONTENTS_CHANGED:String = "PlateContentsChanged";
		
		public function DietPlate() {
			plate = new Plate2_mc();
			plate.scaleX = 0.33;
			plate.scaleY = 0.33;
			this.clearPlate();
			this.addChild(plate);
		}
		public function addAsset(asset:InStockAssetListItem, assetPosition:int):void {
			trace("DietPlate sez: We should be adding something.");
			var offsetX:int = 28*Math.random();
			var offsetY:int = 28*Math.random();
			
			asset.scaleX = asset.scaleY = 0.4;
			
			var plateWidth:Number = plate.width/plate.scaleX; 
			var plateHeight:Number = plate.height/plate.scaleY;
			asset.x =  0.5*plateWidth - (0.5*asset.width) + (plateWidth/5)*Math.sin(assetPosition*2* Math.PI / numTypes) + offsetX ;
			asset.y =  0.5*plateHeight - (0.5*asset.height) + (plateHeight/5)*Math.cos(assetPosition*2* Math.PI / numTypes) + offsetY;		
			
			asset.addEventListener(InStockAssetListItem.ASSET_MOUSE_DOWN, startDragging);
			plate.addChild(asset);
			
			position_contents[assetPosition] ++;
			dispatchEvent(new Event(PLATE_CONTENTS_CHANGED, true));
		}
		//public function removeAsset(asset:MovieClip, assetPosition:int):void {
		public function clearPlate():void {
			
			var plateChildren:int = plate.numChildren;
			for (var childNum:int = plateChildren-1; childNum >= 1; childNum--){
				plate.removeChildAt(childNum);
			}
			position_contents = new Array();
			for(var type:int =0; type<numTypes; type++){
				position_contents[type] = 0;
			}
		}
		public function getPlateContents():Array {
			return position_contents;
		}
		public function setFoodStuffs(foodStuffs:Array):void{
			this.foodStuffs = foodStuffs;
		}
		override public function hitTestObject(testObject:DisplayObject):Boolean{
			return (this.mouseX<0.9*plate.width&&this.mouseX>0.1*plate.width&&this.mouseY>0.1*plate.height&&this.mouseY<0.9*plate.height);
		}
		private function startDragging(e:Event):void{
			if(this.enabled){
				var asset:InStockAssetListItem = e.currentTarget as InStockAssetListItem;
				asset.removeEventListener(InStockAssetListItem.ASSET_MOUSE_DOWN, startDragging);
				//I need to remove this from the plate. That's all. Simples.
				this.removeAsset(asset, getAssetNumber(asset.getAsset().getId()));
			}
		}
		private function removeAsset(asset:InStockAssetListItem, assetPosition:int):void {
			//The problem is knowing what asset position?!
			if(asset.parent == plate){
				plate.removeChild(asset);
			}
			position_contents[assetPosition] --;
			dispatchEvent(new Event(PLATE_CONTENTS_CHANGED, true));
		}
		private function getAssetNumber(assetId:int):int{
			for (var assetNumber:int = 0; assetNumber< foodStuffs.length; assetNumber ++){
				var foodStuff:InStockAssetListItem = foodStuffs[assetNumber] as InStockAssetListItem;
				if(foodStuff.getAsset().getId() == assetId){
					return  assetNumber;
				}
			}
		}
	}
}
