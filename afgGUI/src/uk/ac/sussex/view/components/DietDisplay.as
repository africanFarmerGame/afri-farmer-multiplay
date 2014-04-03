/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	//import flash.events.MouseEvent;
	import uk.ac.sussex.model.valueObjects.Diet;
	import flash.events.Event;
	import uk.ac.sussex.model.valueObjects.GameAssetFood;
	import uk.ac.sussex.model.valueObjects.DietItem;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class DietDisplay extends MovieClip {
		//Screen items
		private var nameField:GameTextField;
		private var targetOptions:Array;
		private var targetRadios:MovieClip;
		private var plate:DietPlate;
		//Data structures
		private var foodStuffs:Array;
		private var currentDiet:Boolean;
		private var currentTarget:String;
		private var currentlyDragging:InStockAssetListItem;
		
		public static const DIET_NAME_CHANGED:String = "DietNameChanged";
		public static const DIET_TARGET_CHANGED:String = "DietTargetChanged";
		public static const DRAGGING_FOOD:String = "DraggingFood";
		
		private static const GAP_SIZE:Number = 10;
		
		public function DietDisplay() {
			this.setupTargetOptions();
			this.setup();
		}
		public function setDietName(newName:String):void {
			nameField.text = newName;
			currentDiet = (newName!="");
		}
		public function getDietName():String {
			return nameField.text;
		}
		public function setFoodStuffs(foodStuffs:Array):void{
			this.foodStuffs = foodStuffs;
			plate.setFoodStuffs(foodStuffs);
		}
		public function clearDisplay():void {
			plate.clearPlate();
			this.setDietName("");
			currentTarget = null;
		}
		public function get displayingDiet():Boolean {
			return currentDiet;
		}
		public function getPlateContents():Array {
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
		public function setPlateContents(plateContents:Array):void {
			plate.clearPlate();
			for each(var dietItem:DietItem in plateContents){
				var currentPosition:int = this.getAssetNumber(dietItem.getAssetId());
				var currentFoodItem:InStockAssetListItem = foodStuffs[currentPosition] as InStockAssetListItem;
				for(var counter:int = 0; counter < dietItem.getAmount(); counter ++){
					this.addItemToPlate(currentFoodItem.getDragCopy(), currentPosition);
				}
			}
		}
		public function setDietTarget(newTarget:int):void {
			currentTarget = newTarget.toString();
			for each (var button:GameRadioButton in targetOptions){
				button.selected = (button.value == newTarget.toString());
			}
		}
		public function getDietTarget():String {
			return currentTarget;
		}
		public function getCurrentDragObject():InStockAssetListItem{
			return currentlyDragging;
		}
		public function testPlateHit(draggedItem:MovieClip):Boolean{
			return plate.hitTestObject(draggedItem);
		}
		public function addItemToPlate(plateItem:InStockAssetListItem, position:int):void{
			plate.addAsset(plateItem, position);
			if(this.enabled){
				trace("DietDisplay sez: we are enabled" + enabled);
				//plateItem.addEventListener(MouseEvent.MOUSE_DOWN, startFoodDrag);
			}
		}
		override public function set enabled(enabled:Boolean):void {
			nameField.enabled = enabled;
			for each (var radioButton:GameRadioButton in targetOptions){
				radioButton.enabled = enabled;
			}
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
			}*/
			super.enabled = enabled;
		}
		
		private function setup():void {
			
			var nameLabel:GenericFieldLabel = new GenericFieldLabel();
			nameLabel.setText("Name");
			nameLabel.x = 0;
			nameLabel.y = 0;
			nameLabel.width = 60;
			this.addChild(nameLabel);
			
			nameField = new GameTextField();
			nameField.x = nameLabel.x + nameLabel.width + GAP_SIZE;
			nameField.y = 0;
			nameField.width = 130;
			nameField.addEventListener(Event.CHANGE, nameModified);
			this.addChild(nameField);
			
			targetRadios.x = nameField.x + nameField.width + GAP_SIZE;
			targetRadios.y = nameLabel.y;
			this.addChild(targetRadios);
			
			var tableTop:Tabletop1_mc = new Tabletop1_mc();
			tableTop.x = 0;
			tableTop.y = targetRadios.y + targetRadios.height + GAP_SIZE;
			tableTop.width = 420;
			tableTop.height = 240;
			this.addChild(tableTop);
			
			plate = new DietPlate();
			plate.x = tableTop.x + 200;
			plate.y = tableTop.y + 15;
			this.addChild(plate);
		}
		private function setupTargetOptions():void {
			targetOptions = new Array();
			targetRadios = new MovieClip();
			
			var radioGap:Number = 5;
			var radioWidth:Number = 70;
			
			var groupLabel:GenericFieldLabel = new GenericFieldLabel();
			groupLabel.width = 50;
			groupLabel.setText("Type");
			targetRadios.addChild(groupLabel);
			
			var manOption:GameRadioButton = new GameRadioButton();
			manOption.labelText = "Man";
			manOption.x = groupLabel.x + groupLabel.width + radioGap;
			manOption.y = 0;
			manOption.width = radioWidth;
			manOption.value = Diet.DIET_TARGET_MALE.toString();
			manOption.addEventListener(GameRadioButton.VALUE_CHANGED, radioButtonChanged);
			targetRadios.addChild(manOption);
			targetOptions.push(manOption);
			
			var womanOption:GameRadioButton = new GameRadioButton();
			womanOption.labelText = "Woman";
			womanOption.x = manOption.x;
			womanOption.y = manOption.y + manOption.height + radioGap;
			womanOption.width = radioWidth;
			womanOption.value = Diet.DIET_TARGET_FEMALE.toString();
			womanOption.addEventListener(GameRadioButton.VALUE_CHANGED, radioButtonChanged);
			targetRadios.addChild(womanOption);
			targetOptions.push(womanOption);
			
			var childOption:GameRadioButton = new GameRadioButton();
			childOption.labelText = "Child";
			childOption.x = manOption.x + manOption.width + radioGap;
			childOption.y = manOption.y;
			childOption.width = radioWidth;
			childOption.value = Diet.DIET_TARGET_CHILD.toString();
			childOption.addEventListener(GameRadioButton.VALUE_CHANGED, radioButtonChanged);
			targetRadios.addChild(childOption);
			targetOptions.push(childOption);
			
			var babyOption:GameRadioButton = new GameRadioButton();
			babyOption.labelText = "Baby";
			babyOption.x = childOption.x;
			babyOption.y = womanOption.y;
			babyOption.width = radioWidth;
			babyOption.value = Diet.DIET_TARGET_BABY.toString();
			babyOption.addEventListener(GameRadioButton.VALUE_CHANGED, radioButtonChanged);
			targetRadios.addChild(babyOption);
			targetOptions.push(babyOption);
		}
		private function radioButtonChanged(e:Event):void{
			var radio:GameRadioButton = e.target as GameRadioButton;
			currentTarget = radio.value;
			for each (var button:GameRadioButton in targetOptions){
				if(button!=radio){
					button.selected = false;
				}
			}
			dispatchEvent(new Event(DIET_TARGET_CHANGED, true));
		}
		private function nameModified(e:Event):void{
			this.dispatchEvent(new Event(DIET_NAME_CHANGED, true));
		}
		/**private function startFoodDrag(e:MouseEvent):void {
			var assetIcon:InStockAssetListItem = e.currentTarget as InStockAssetListItem;
			if(assetIcon != null){
				var assetNumber:int = this.getAssetNumber(assetIcon.getAsset().getId());
				plate.removeAsset(assetIcon, assetNumber);
				currentlyDragging = assetIcon;
				this.dispatchEvent(new Event(DRAGGING_FOOD));
			}
		}*/
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
