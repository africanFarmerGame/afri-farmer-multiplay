/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	//import uk.ac.sussex.general.ApplicationFacade;
	import flash.events.MouseEvent;
	import uk.ac.sussex.model.valueObjects.Diet;
	import flash.events.Event;
	import uk.ac.sussex.model.valueObjects.GameAssetFood;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class DietCreation extends MovieClip {
		//Links the table view to a two column list and so on. 
		private var listOfStuff:TitledTwoColumnScrollingList;
		private var dietDisplay:DietDisplay;
		private var foodStuffs:Array;
		private var diets:Array;
		private var currentDisplay:int;
		private var currentAssetNumber:int = -1;
		private var saveButton:SaveBtn1;
		private var cancelButton:CancelBtn1;
		private var confirmButton:ConfirmBtn;
		private var editing:Boolean;
		private var deleting:Boolean;
		
		private static const GAP_SIZE:Number = 10;
		private static const DISPLAYING_DIETS:uint = 0;
		private static const DISPLAYING_FOODS:uint = 1;
		
		public static const SAVE_DIET:String = "SaveTheDiet";
		public static const CANCEL_EDIT:String = "CancelTheEdintg";
		public static const DIET_SELECTED:String = "DietSelected";
		public static const DIET_SELECTION_CLEARED:String = "DietSelectionCleared";
		public static const CONFIRM_DIET_SELECTION:String = "ConfirmDietSelection";
		public static const START_DRAGGING:String = "Startdraggingsomestuff";
		public var currentDragItem:MovieClip;
		
		public function DietCreation() {
			setup();
			foodStuffs = new Array();
			diets = new Array();
			currentDisplay = -1;
		}
		public function clearDisplay():void {
			dietDisplay.clearDisplay();
		}
		public function addDiets(dietArray:Array):void {
			for each (var diet:Diet in dietArray){
				this.addDiet(diet);
			}
		}
		public function addDiet(newDiet:Diet):void {
			var listItem:DietListItem = new DietListItem();
			listItem.setDiet(newDiet);
			if(currentDisplay == DISPLAYING_DIETS){
				listOfStuff.addItem(listItem);
			}
			diets.push(listItem);
		}
		public function updateDiet(updatedDiet:Diet):void {
			var updatedDietId:String = updatedDiet.getId().toString();
			for each (var diet:DietListItem in diets){
				if (diet.getItemID() == updatedDietId){
					diet.setDiet(updatedDiet);
					break;
				}
			}
		}
		public function deleteDiet(dietId:int):void {
			var stringId:String = dietId.toString();
			var newDiets:Array = new Array();
			for each (var diet:DietListItem in diets){
				if(diet.getItemID()!= stringId){
					newDiets.push(diet);
				}
			}
			if(currentDisplay == DISPLAYING_DIETS){
				listOfStuff.removeItem(stringId);
			}
			diets = newDiets;
		}
		public function addFoods(foodArray:Array):void {
			var itemPos:int = 0;
			for each (var food:GameAssetFood in foodArray) {
				var listItem:InStockAssetListItem = new InStockAssetListItem();
				listItem.setAsset(food);
				foodStuffs[itemPos] = listItem;
				itemPos ++;
			}
			dietDisplay.setFoodStuffs(foodStuffs);
			if(currentDisplay == DISPLAYING_FOODS){
				this.showFoods();
			}
		}
		public function getSelectedDiet():int{
			var selectedDiet:DietListItem = listOfStuff.getSelectedListItem() as DietListItem;
			return int(selectedDiet.getItemID());
		}
		public function setEditable(editing:Boolean):void{
			this.editing = editing;
			if(editing){
				this.deleting = false;
			}
			if(editing && dietDisplay.displayingDiet){
				this.showFoods();
			} else {
				this.showDiets();
			}
			this.showHideSaveConfirmCancelButtons();
		}
		public function showDietSelection(show:Boolean):void {
			this.deleting = show;
			if(show){
				this.setEditable(false);
			}
			this.showHideSaveConfirmCancelButtons();
		}
		public function setDietName(newDietName:String):void {
			dietDisplay.setDietName(newDietName);
			if(editing && dietDisplay.displayingDiet){
				this.showFoods();
			} else {
				this.showDiets();
			}			
			this.showHideSaveConfirmCancelButtons();
		}
		public function getDietName():String {
			return dietDisplay.getDietName();
		}
		public function setDietTarget(newTarget:int):void {
			dietDisplay.setDietTarget(newTarget);
		}
		public function getDietTarget():String {
			return dietDisplay.getDietTarget();
		}
		public function setPlateContents(newDietItems:Array):void {
			dietDisplay.setPlateContents(newDietItems);
		}
		public function getPlateContents():Array {
			return dietDisplay.getPlateContents();
		}
		private function showDiets():void{
			if(currentDisplay != DISPLAYING_DIETS){
				currentDisplay = DISPLAYING_DIETS;
				listOfStuff.setTitleLabel("Diets");
				listOfStuff.clearList();
				listOfStuff.setListItemsSelectable(true);
				listOfStuff.addEventListener(ScrollingList.ITEM_SELECTED, dietItemSelected);
				listOfStuff.addEventListener(ScrollingList.SELECTION_CLEARED, dietItemSelectionCleared);
				for each (var diet:DietListItem in diets){
					listOfStuff.addItem(diet);
				}
				dietDisplay.enabled = false;
			}
		}
		private function showFoods():void {
			if(currentDisplay != DISPLAYING_FOODS){
				currentDisplay =  DISPLAYING_FOODS;
				listOfStuff.setTitleLabel("Food");
				listOfStuff.clearList();
				listOfStuff.setListItemsSelectable(false);
				listOfStuff.removeEventListener(ScrollingList.ITEM_SELECTED, dietItemSelected);
				listOfStuff.removeEventListener(ScrollingList.SELECTION_CLEARED, dietItemSelectionCleared);
				for each (var food:InStockAssetListItem in foodStuffs){
					food.addEventListener(MouseEvent.MOUSE_DOWN, startFoodDrag);
					//food.addEventListener(InStockAssetListItem.ASSET_MOUSE_DOWN, startFoodDrag);
					//food.allowDrag(true);
					listOfStuff.addItem(food);
				}
				dietDisplay.enabled = true;
			}
		}
		private function setup():void {
			var scale:Number = 0.25;
			
			dietDisplay = new DietDisplay();
			dietDisplay.x = 0;
			dietDisplay.y = 0;
			//dietDisplay.addEventListener(DietPlate.DRAGGING_FOOD, dragOffPlate);
			dietDisplay.addEventListener(InStockAssetListItem.ASSET_MOUSE_DOWN, dragOffPlate);
			this.addChild(dietDisplay);
		
			cancelButton = new CancelBtn1();
			cancelButton.scaleX = cancelButton.scaleY = scale;
			cancelButton.x = -cancelButton.width - GAP_SIZE;
			cancelButton.y = dietDisplay.y + dietDisplay.height - cancelButton.height;
			this.addChild(cancelButton);
			
			saveButton = new SaveBtn1();
			saveButton.scaleX = saveButton.scaleY = scale;
			saveButton.x = cancelButton.x;
			saveButton.y = cancelButton.y - GAP_SIZE - saveButton.height;
			this.addChild(saveButton);
			
			confirmButton = new ConfirmBtn();
			confirmButton.scaleX = confirmButton.scaleY = scale;
			confirmButton.x = saveButton.x;
			confirmButton.y = saveButton.y;
			this.addChild(confirmButton);

			listOfStuff = new TitledTwoColumnScrollingList();
			listOfStuff.x = dietDisplay.x + dietDisplay.width + GAP_SIZE;
			listOfStuff.y = 0;
			listOfStuff.setTitleLabel("Saved Diets");
			this.addChild(listOfStuff);
		}
		//private function startFoodDrag(e:MouseEvent):void {
		private function startFoodDrag(e:Event):void {
			var foodItem:InStockAssetListItem = e.currentTarget as InStockAssetListItem;
			if(foodItem!= null){
				currentAssetNumber = this.getAssetNumber(foodItem.getAsset().getId());
				var dragIcon:InStockAssetListItem = foodItem.getDragCopy();
				this.dragItem(dragIcon);
			}
		}
		//private function stopFoodDrag(e:MouseEvent):void {
		public function stopFoodDrag(dragIcon:InStockAssetListItem):void {
			if(dietDisplay.testPlateHit(dragIcon) && currentAssetNumber != -1){
				dietDisplay.addItemToPlate(dragIcon, currentAssetNumber);
			} 
			currentDragItem = null;
			currentAssetNumber = -1;
		}
		private function dragItem(dragItem:MovieClip):void{
			//dragItem.scaleX = 0.16;
			//dragItem.scaleY = 0.16;
			/**dragItem.x = this.mouseX - 0.5*dragItem.width;
			dragItem.y = this.mouseY - 0.5*dragItem.height;
			this.addChild(dragItem);
			dragItem.startDrag();
			dragItem.addEventListener(MouseEvent.MOUSE_UP, stopFoodDrag);**/
			this.currentDragItem = dragItem;
			dispatchEvent(new Event(START_DRAGGING));
		}
		
		private function saveDiet(e:MouseEvent):void{
			dispatchEvent(new Event(SAVE_DIET));
		}
		private function cancelEditing(e:MouseEvent):void {
			dispatchEvent(new Event(CANCEL_EDIT));
		}
		private function showHideSaveConfirmCancelButtons():void {
			saveButton.visible = false;
			cancelButton.visible = false;
			confirmButton.visible = false;
			
			var actuallyEditing:Boolean = editing && dietDisplay.displayingDiet;
			if(actuallyEditing){
				saveButton.visible = true;
				saveButton.addEventListener(MouseEvent.CLICK, saveDiet);
			} else {
				saveButton.visible = false;
				saveButton.removeEventListener(MouseEvent.CLICK, saveDiet);
			}
			if(actuallyEditing||deleting){
				cancelButton.addEventListener(MouseEvent.CLICK, cancelEditing);
				cancelButton.visible = true;
			} else {
				cancelButton.visible = false;
				cancelButton.removeEventListener(MouseEvent.CLICK, cancelEditing);
			}
			if(deleting){
				confirmButton.visible = true;
				confirmButton.addEventListener(MouseEvent.CLICK, confirmSelection);
			} else {
				confirmButton.visible = false;
				confirmButton.removeEventListener(MouseEvent.CLICK, confirmSelection);
			}
		}
		private function dragOffPlate(e:Event):void {
			//trace("DietCreation sez: I hear ya!");
			if(editing){
				var assetIcon:InStockAssetListItem = e.target as InStockAssetListItem;
				
				if(assetIcon != null){
					//assetIcon = assetIcon.getDragCopy();
					var assetNumber:int = this.getAssetNumber(assetIcon.getAsset().getId());
					currentAssetNumber = assetNumber;
					assetIcon.scaleX = assetIcon.scaleY = 0.16;
					this.dragItem(assetIcon);
				}
			}
		}
		private function getAssetNumber(assetId:int):int{
			for (var assetNumber:int = 0; assetNumber< foodStuffs.length; assetNumber ++){
				var foodStuff:InStockAssetListItem = foodStuffs[assetNumber] as InStockAssetListItem;
				if(foodStuff.getAsset().getId() == assetId){
					return  assetNumber;
				}
			}
		}
		private function dietItemSelected(e:Event):void {
			dispatchEvent(new Event(DIET_SELECTED));
		}
		private function dietItemSelectionCleared(e:Event):void {
			dispatchEvent(new Event(DIET_SELECTION_CLEARED));
		}
		private function confirmSelection(e:MouseEvent):void{
			if(deleting){
				this.dispatchEvent(new Event(CONFIRM_DIET_SELECTION));
			}
		}
	}
}
