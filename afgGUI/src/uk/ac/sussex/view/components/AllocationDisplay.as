/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.events.MouseEvent;
	import flash.events.Event;
	import uk.ac.sussex.model.valueObjects.Diet;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class AllocationDisplay extends MovieClip {
		private var nameField:GameTextField;
		private var displayRadios:MovieClip;
		private var tableTop:Tabletop1_mc;
		private var allDiets:MovieClip;
		private var detailedDiets:ScrollingContainer;
		private var mouseOverText:MouseoverTextField;
		
		private var displayOptions:Array;
		private var allocationDiets:Array;
		private var currentAllocation:Boolean = false;
		private var currentLevelOfDetailDisplay:int;
		private var foodStuffs:Array;
		
		//private var currentlyDragging:InStockAssetListItem;
		
		private static const GAP_SIZE:Number = 10;
		
		public static const START_DRAG:String = "StartingDrag";
		public static const ALLOCATION_NAME_CHANGED:String = "AllocationNameChanged";
		
		public function AllocationDisplay() {
			allocationDiets = new Array();
			this.setupDisplayOptions();
			this.setup();
			this.setCurrentLevelOfDetailDisplayType(AllocationDiet.DISPLAY_ALL);
		}
		public function setFoodStuffs(newFoodStuffs:Array):void {
			this.foodStuffs = newFoodStuffs;
		}
		public function setAllocationName(newName:String):void {
			nameField.text = newName;
			currentAllocation = (newName!="");
		}
		public function getAllocationName():String {
			return nameField.text;
		}
		public function get displayingAllocation():Boolean {
			return currentAllocation;
		}
		/**public function getCurrentDragObject():InStockAssetListItem{
			return currentlyDragging;
		}*/
		public function clearDisplay():void {
			this.setAllocationName("");
			this.clearTable();
			this.setAllocationDiets(new Array());
		}
		public function setAllocationDiets(newAllocationDiets:Array):void {
			this.clearTable();
			trace("AllocationCreation sez: The array is not null " + (allocationDiets != null));
			this.allocationDiets = new Array();
			
			for each (var diet:Diet in newAllocationDiets){
				diet.updateNutrientLevels();
				var aDiet:AllocationDiet = new AllocationDiet();
				aDiet.setFoodStuffs(foodStuffs);
				aDiet.setDiet(diet);
				aDiet.enabled = this.enabled;
				this.allocationDiets.push(aDiet);
			}
			//Can I now sort? Hopefully. 
			allocationDiets = allocationDiets.sort(sortDietOnId);
			setCurrentLevelOfDetailDisplayType(currentLevelOfDetailDisplay);
		}
		public function getAllocationDiets():Array {
			var allocationDiets:Array = new Array;
			for each (var aDiet:AllocationDiet in this.allocationDiets){
				var diet:Diet = aDiet.getDiet();
				allocationDiets.push(diet);
			}
			return allocationDiets;
		}
		public function testPlateHit(dragIcon:ListItem):int{
			var plateNumber:int = -1;
			for each (var aDiet:AllocationDiet in allocationDiets){
				if(aDiet.droppedOnPlate(dragIcon)){
					plateNumber = aDiet.getDietId();
					return plateNumber;
				}	
			}
			return plateNumber;
		}
		public function addItemToPlate(foodItem:InStockAssetListItem, plate:int):void{
			for each (var aDiet:AllocationDiet in allocationDiets){
				if(aDiet.getDietId() == plate){
					aDiet.addPlateItem(foodItem);
					break;
				}
			}
		}
		public function addDietToPlateContents(diet:Diet, plateNumber:int):void {
			for each (var aDiet:AllocationDiet in allocationDiets){
				if(aDiet.getDietId() == plateNumber){
					aDiet.addDietToPlateContents(diet);
					break;
				}
			}
		}
		override public function set enabled(enabled:Boolean):void {
			trace("AllocationDisplay sez: I am enabled " + enabled);
			nameField.enabled = enabled;
			for each (var aDiet:AllocationDiet in allocationDiets){
				aDiet.enabled = enabled;
			}
			super.enabled = enabled;
		}
		public function destroy():void {
			if(mouseOverText!=null){
				mouseOverText.removeFromScreen();
			}
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
			
			displayRadios.x = nameField.x + nameField.width + GAP_SIZE;
			displayRadios.y = nameLabel.y;
			this.addChild(displayRadios);
			
			tableTop = new Tabletop1_mc();
			tableTop.x = 0;
			tableTop.y = displayRadios.y + displayRadios.height + GAP_SIZE;
			//tableTop.y = nameField.y + nameField.height + GAP_SIZE;
			tableTop.width = 420;
			tableTop.height = 240;
			this.addChild(tableTop);
					
			allDiets = new MovieClip;
			allDiets.x = tableTop.x;
			allDiets.y = tableTop.y;

			detailedDiets = new ScrollingContainer(tableTop.width, tableTop.height, ScrollingContainer.HORIZONTAL, false);
			detailedDiets.hideBackground(true);
			detailedDiets.x = tableTop.x;
			detailedDiets.y = tableTop.y;
			
			
			mouseOverText = new MouseoverTextField();
		}
		private function setupDisplayOptions():void {
			displayOptions = new Array();
			displayRadios = new MovieClip();
			
			var radioGap:Number = 5;
			var radioWidth:Number = 70;
			
			var groupLabel:GenericFieldLabel = new GenericFieldLabel();
			groupLabel.width = 70;
			groupLabel.setText("Display");
			displayRadios.addChild(groupLabel);
			
			var allOption:GameRadioButton = new GameRadioButton();
			allOption.labelText = "All";
			allOption.x = groupLabel.x + groupLabel.width + radioGap;
			allOption.y = 0;
			allOption.width = radioWidth;
			allOption.value = AllocationDiet.DISPLAY_ALL.toString();
			allOption.addEventListener(GameRadioButton.VALUE_CHANGED, radioButtonChanged);
			displayRadios.addChild(allOption);
			displayOptions.push(allOption);
			
			var detailOption:GameRadioButton = new GameRadioButton();
			detailOption.labelText = "Detail";
			detailOption.x = allOption.x;
			detailOption.y = allOption.y + allOption.height + radioGap;
			detailOption.width = radioWidth;
			detailOption.value = AllocationDiet.DISPLAY_DETAIL.toString();
			detailOption.addEventListener(GameRadioButton.VALUE_CHANGED, radioButtonChanged);
			displayRadios.addChild(detailOption);
			displayOptions.push(detailOption);
			
		}
		private function clearTable():void {
			for each (var aDiet:AllocationDiet in allocationDiets){
				if(aDiet.parent != null){
					aDiet.parent.removeChild(aDiet);
				}
			}
		}
		private function setCurrentLevelOfDetailDisplayType(displayType:int):void {
			currentLevelOfDetailDisplay = displayType;
			var adiet:AllocationDiet;
			var counter:int = 0;
			
			if(displayType == AllocationDiet.DISPLAY_ALL){
				trace("AllocationCreation sez: We are displaying all.");
				
				if(detailedDiets.parent!= null){
					detailedDiets.parent.removeChild(detailedDiets);
				}
				var maxWidth:int = this.calcMaxObjectSize(allocationDiets.length, 1, tableTop.width, tableTop.height);
				var plateWidth:Number = 0.9 * maxWidth;
				var gapSize:Number = 0.1*maxWidth;
				var maxP:int = Math.floor(tableTop.width/maxWidth); // max plates per row
				for each (adiet in allocationDiets){
					this.addRollOverListeners(adiet);
					adiet.setDisplay(currentLevelOfDetailDisplay);
					var height:Number = plateWidth / (adiet.width/adiet.height);
					adiet.width = plateWidth;
					adiet.height = height;
					adiet.x = 0.5*gapSize + (counter % maxP)*maxWidth;
					adiet.y = 0.5*gapSize + int(counter/maxP)*maxWidth;
					allDiets.addChild(adiet);
					counter++;
				}
				this.addChild(allDiets);
			} else if (displayType == AllocationDiet.DISPLAY_DETAIL){
				trace("AllocationCreation sez: we are displaying detail");
				if(allDiets.parent != null){
					allDiets.parent.removeChild(allDiets);
				}
				for each (adiet in allocationDiets){
					this.removeRollOverListeners(adiet);
					adiet.setDisplay(currentLevelOfDetailDisplay);
					var width:Number = 214 * adiet.width/adiet.height;
					adiet.width = width;
					adiet.height = 214;
					adiet.y = 10;
					adiet.x = (counter * (width + 20)) + 20; 
					detailedDiets.addItemToContainer(adiet);
					counter++;
				}
				this.addChild(detailedDiets);
			}
			for each (var button:GameRadioButton in displayOptions){
				button.selected = (button.value == displayType.toString());
			}
		}
		private function calcMaxObjectSize (numberOfObjects:int, aspectRatio:Number, boundsWidth:int, boundsHeight:int):int {
		
			var maxSizeX:Number;
			
			if ((boundsWidth/aspectRatio) > boundsHeight) { // can fit more objects in the x-direction
				maxSizeX = boundsHeight*aspectRatio; // begin with only 1 object in y-direction
			} else {
				maxSizeX = boundsWidth; // begin with only 1 object in x-direction
			}
			var numberOfObjectsX:Number = Math.floor(boundsWidth/maxSizeX);
			var numberOfObjectsY:Number = Math.floor(boundsHeight*aspectRatio/maxSizeX);				
			var actualObjects:Number = numberOfObjectsX*numberOfObjectsY;
			while(actualObjects < numberOfObjects || numberOfObjectsX*maxSizeX > boundsWidth || numberOfObjectsY*maxSizeX/aspectRatio > boundsHeight){
				maxSizeX--;
				numberOfObjectsX = Math.floor(boundsWidth/maxSizeX);
				numberOfObjectsY = Math.floor(boundsHeight*aspectRatio/maxSizeX);
				actualObjects = numberOfObjectsX*numberOfObjectsY;
			}			
			return Math.floor(maxSizeX);
		}
		private function radioButtonChanged(e:Event):void{
			var radio:GameRadioButton = e.target as GameRadioButton;
			setCurrentLevelOfDetailDisplayType(int(radio.value));
		}
		private function nameModified(e:Event):void{
			this.dispatchEvent(new Event(ALLOCATION_NAME_CHANGED, true));
		}
		/**private function startDragging(e:Event):void {
			var aDiet:AllocationDiet = e.target as AllocationDiet;
			if(aDiet != null){
				currentlyDragging = aDiet.getCurrentDragItem();
				trace("AllocationDisplay sez: The asset I'm currently dragging is scaled " + currentlyDragging.scaleX);
				aDiet.clearCurrentDragItem();
			}
		}**/
		private function addRollOverListeners(object:AllocationDiet):void {
			object.addEventListener(MouseEvent.ROLL_OVER, displayMouseoverText);
			object.addEventListener(MouseEvent.ROLL_OUT, removeMouseoverText);
		}
		private function removeRollOverListeners(object:AllocationDiet):void {
			object.removeEventListener(MouseEvent.ROLL_OVER, displayMouseoverText);
			object.removeEventListener(MouseEvent.ROLL_OUT, removeMouseoverText);
		}
		private function displayMouseoverText(e:MouseEvent):void {
			var adiet:AllocationDiet = e.target as AllocationDiet;
			if(adiet != null){
				var diet:Diet = adiet.getDiet();
				var mouseoverText:String = diet.getName() + ",\n"+ Diet.translateDietTargetToText(diet.getTarget());
				mouseOverText.text = mouseoverText;
				mouseOverText.addToScreen(this, this.mouseX, this.mouseY);
			}
		}
		private function removeMouseoverText(e:MouseEvent):void {
			mouseOverText.removeFromScreen();
		}
		private function sortDietOnId(a:AllocationDiet, b:AllocationDiet):int {
			var aId:int = a.getDietId();
			var bId:int = b.getDietId();
			if(aId>bId){
				return 1;
			} else if (aId<bId){
				return -1;
			} else {
				return 0;
			}
		}
	}
}
