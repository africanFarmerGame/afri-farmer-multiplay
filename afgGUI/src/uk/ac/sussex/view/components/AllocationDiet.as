/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.events.Event;
	//import flash.events.MouseEvent;
	import uk.ac.sussex.model.valueObjects.Diet;
	import uk.ac.sussex.model.valueObjects.GameAssetFood;
	import uk.ac.sussex.model.valueObjects.DietItem;
	import flash.text.*;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class AllocationDiet extends MovieClip {
		private var plate:DietPlate;
		private var trafficLights:DietTrafficLights;
		private var diet:Diet;
		private var dietType:DietType_mc;
		private var dietLevel:DietLevel_mc;
		private var dietName:TextField;
		private var dietId:int;
		private var display:int = -1;
		private var foodStuffs:Array;
		//private var currentlyDragging:InStockAssetListItem;
		
		public static var DISPLAY_DETAIL:int = 0;
		public static var DISPLAY_ALL:int = 1;
		
		public static const DRAG_PLATE_ITEM:String = "DragPlateItem";
		
		public function AllocationDiet() {
			this.setup();
			this.setDisplay(DISPLAY_ALL);
		}
		public function setDisplay(displayType:int):void {
			display = displayType;
			if(displayType == DISPLAY_DETAIL){
				this.displayDetail();
			} else if (displayType == DISPLAY_ALL){
				this.displayAll();
			}
		}
		public function setDiet(newDiet:Diet):void {
			this.diet = newDiet;
			dietId = diet.getId();
			diet.updateNutrientLevels();
			dietName.text = diet.getName();
			this.dietLevel.setDietLevel(diet.getDietLevel());
			this.dietType.setDietType(diet.getTarget());
			this.trafficLights.updateDietLevelIcons(diet.getCarbLevel(), diet.getProteinLevel(), diet.getNutrientLevel());
			this.addDietToPlateContents(diet);
		}
		public function getDiet():Diet {
			return diet;
		}
		public function getDietId():int{
			return dietId;
		}
		public function setFoodStuffs(newArray:Array):void {
			foodStuffs = new Array();
			for each(var food:InStockAssetListItem in newArray){
				foodStuffs.push(food);
			}
			plate.setFoodStuffs(foodStuffs);
		}
		/**public function getCurrentDragItem():InStockAssetListItem {
			return currentlyDragging;
		}
		public function clearCurrentDragItem():void {
			currentlyDragging = null;
		}*/
		public function addDietToPlateContents(newDiet:Diet):void {
			var dietItems:Array = newDiet.getDietItems();
			for each(var dietItem:DietItem in dietItems){
				var currentPosition:int = this.getAssetNumber(dietItem.getAssetId());
				var currentFoodItem:InStockAssetListItem = foodStuffs[currentPosition] as InStockAssetListItem;
				for(var counter:int = 0; counter < dietItem.getAmount(); counter ++){
					plate.addAsset(currentFoodItem.getDragCopy(), currentPosition);
				}
			}
		}
		public function addPlateItem(plateItem:InStockAssetListItem):void{
			var currentPosition:int = this.getAssetNumber(int(plateItem.getItemID()));
			plate.addAsset(plateItem, currentPosition);
		}
		public function droppedOnPlate(draggedItem:MovieClip):Boolean{
			return plate.hitTestObject(draggedItem);
		}
		/**public function removeAsset(assetIcon:InStockAssetListItem, assetPosition:int):void {
			plate.removeAsset(assetIcon, assetPosition);
			this.updateDietContents();
		}*/
		public function getDietItems():Array {
			var plate_contents:Array = plate.getPlateContents();
			var dietContents:Array = new Array();
			for (var itemPos:int = 0; itemPos < foodStuffs.length; itemPos++){
				var dietItem:DietItem = new DietItem();
				var listItem:InStockAssetListItem = foodStuffs[itemPos] as InStockAssetListItem;
				var foodItem:GameAssetFood = listItem.getAsset() as GameAssetFood;
				dietItem.setAsset(foodItem);
				dietItem.setAmount(plate_contents[itemPos]);
				dietContents.push(dietItem);
			}
			return dietContents;	
		}
		override public function set enabled(enabled:Boolean):void {
			trace("AllocationDiet sez: I am enabled " + enabled);
			//var plateItems:Array = plate.getPlateChildren();
			plate.enabled = enabled;
/**			var plateItems:Array = new Array();
			if(enabled){
				for each (var plateItem1:MovieClip in plateItems){
					plateItem1.addEventListener(MouseEvent.MOUSE_DOWN, startFoodDrag);
				}
			} else {
				for each (var plateItem2:MovieClip in plateItems){
					plateItem2.removeEventListener(MouseEvent.MOUSE_DOWN, startFoodDrag);
				}
			}**/
			super.enabled = enabled;
		}
		private function updateDietContents(e:Event):void {
			var plate_contents:Array = plate.getPlateContents();
			var dietContents:Array = new Array();
			for (var itemPos:int = 0; itemPos < foodStuffs.length; itemPos++){
				var dietItem:DietItem = new DietItem();
				var listItem:InStockAssetListItem = foodStuffs[itemPos] as InStockAssetListItem;
				var foodItem:GameAssetFood = listItem.getAsset() as GameAssetFood;
				dietItem.setAsset(foodItem);
				dietItem.setAmount(plate_contents[itemPos]);
				dietContents.push(dietItem);
				trace("AllocationDiet sez: " + foodItem.getName() + " " + plate_contents[itemPos]);
			}
			this.diet.setDietItems(dietContents);
			this.dietLevel.setDietLevel(diet.getDietLevel());
			this.trafficLights.updateDietLevelIcons(diet.getCarbLevel(), diet.getProteinLevel(), diet.getNutrientLevel());
		}
		private function setup():void {
			plate = new DietPlate();
			plate.addEventListener(DietPlate.PLATE_CONTENTS_CHANGED, updateDietContents);
			this.addChild(plate);
			trafficLights = new DietTrafficLights();
			dietType = new DietType_mc();
			dietLevel = new DietLevel_mc();
			this.addChild(dietLevel);
			
			dietName = new TextField();
			var tFormat:TextFormat = new TextFormat();
			tFormat.color = 0x000000;
			tFormat.size = 12;
			tFormat.font = "Arial";
			tFormat.bold = false;
			tFormat.leftMargin = 2;
			tFormat.align = TextFormatAlign.CENTER;
			dietName.defaultTextFormat = tFormat;								
			dietName.border = true;
			dietName.background = true;
			dietName.wordWrap = true;
			dietName.selectable = false;
			dietName.width = 72.15;
			dietName.height = 43;
		}
		
		private function displayDetail():void {
			plate.height = 170;
			plate.width = 170;
			
			dietType.x = 0;
			dietType.y = plate.height + 10;
			dietType.width = 40 * dietType.width / dietType.height;
			dietType.height = 43;
			
			dietName.x = dietType.x + dietType.width;
			dietName.y = dietType.y;
			dietName.height = 42;
			
			trafficLights.x = dietName.x + dietName.width;
			trafficLights.y = dietType.y;
			trafficLights.height = 43;
			
			var aspectRatio:Number = dietLevel.width/dietLevel.height;
			dietLevel.width = 40 * aspectRatio;
			dietLevel.height = 43;
			dietLevel.x = trafficLights.x + trafficLights.width;
			dietLevel.y = dietType.y;
			
			this.addChild(trafficLights);
			this.addChild(dietType);
			this.addChild(dietName);
			plate.x = (dietLevel.x + dietLevel.width - plate.width)/2;
		}
		private function displayAll():void {
			if(trafficLights.parent != null){
				trafficLights.parent.removeChild(trafficLights);
				dietType.parent.removeChild(dietType);
				dietName.parent.removeChild(dietName);
			}
			
			plate.x = 0;
			plate.y = 0;
			
			var aspectRatio:Number = dietLevel.width/dietLevel.height;
			dietLevel.width = 30 * aspectRatio;
			dietLevel.height = 30;
			dietLevel.x = 0;
			dietLevel.y = plate.y + plate.height - dietLevel.height;
		}
		private function getAssetNumber(assetId:int):int{
			for (var assetNumber:int = 0; assetNumber< foodStuffs.length; assetNumber ++){
				var foodStuff:InStockAssetListItem = foodStuffs[assetNumber] as InStockAssetListItem;
				if(foodStuff.getAsset().getId() == assetId){
					return  assetNumber;
				}
			}
		}
		/**private function addItemToPlate(plateItem:InStockAssetListItem, position:int):void{
			plate.addAsset(plateItem, position);
		}*/
	}
}
