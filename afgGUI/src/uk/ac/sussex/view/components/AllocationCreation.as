package uk.ac.sussex.view.components {
	import uk.ac.sussex.model.valueObjects.Allocation;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import uk.ac.sussex.model.valueObjects.Diet;
	import uk.ac.sussex.model.valueObjects.GameAssetFood;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class AllocationCreation extends MovieClip {
		//Screen elements
		private var listOfStuff:TitledTwoColumnScrollingList;
		private var allocationDisplay:AllocationDisplay;
		private var cancelButton:CancelBtn1;
		private var saveButton:SaveBtn1;
		private var confirmButton:ConfirmBtn;
		//Data structures
		private var foodStuffs:Array;
		private var diets:Array;
		private var allocations:Array;
		public var currentDragItem:ListItem;
		//Flags
		private var currentListOfStuffDisplay:int;
		private var currentAssetNumber:int = -1;
		private var editing:Boolean;
		private var deleting:Boolean;
		
		public static const ALLOCATION_NAME_CHANGED:String = "AllocationNameChanged";
		public static const ALLOCATION_SELECTED:String = "AllocationSelected";
		public static const ALLOCATION_SELECTION_CLEARED:String = "AllocationSelectionCleared";
		public static const SAVE_ALLOCATION:String = "SaveAllocation";
		public static const CONFIRM_ALLOCATION_SELECTION:String = "ConfirmSelection";
		public static const CANCEL_EDIT:String = "CancelEdit";
		public static const ALLOCATION_CONTENTS_CHANGED:String = "AllocationContentsChanged";
		public static const START_DRAGGING:String = "AllocationCreationStartDragging";
		
		private static const GAP_SIZE:Number = 10;
		private static const DISPLAYING_ALLOCS:uint = 1;
		private static const DISPLAYING_FOODS:uint = 2;
		
		public function AllocationCreation() {
			this.setup();
			foodStuffs = new Array();
			diets = new Array();
			allocations = new Array();
			this.showHideSaveConfirmCancelButtons();
			this.showAllocations();
		}
		public function addDiets(dietArray:Array):void {
			for each (var diet:Diet in dietArray){
				var listItem:DietListItem = new DietListItem();
				listItem.setDiet(diet);
				//Probably need to change this. Later. 
				if(currentListOfStuffDisplay == DISPLAYING_FOODS){
					listOfStuff.addItem(listItem);
					listItem.addEventListener(MouseEvent.MOUSE_DOWN, startFoodDrag);
				}
				diets.push(listItem);
			}
		}
		public function addFoods(foodArray:Array):void {
			var itemPos:int = 0;
			for each (var food:GameAssetFood in foodArray) {
				var listItem:InStockAssetListItem = new InStockAssetListItem();
				listItem.setAsset(food);
				foodStuffs[itemPos] = listItem;
				itemPos ++;
				if(currentListOfStuffDisplay == DISPLAYING_FOODS){
					listOfStuff.addItem(listItem);
					listItem.addEventListener(MouseEvent.MOUSE_DOWN, startFoodDrag);
				}
			}
			allocationDisplay.setFoodStuffs(foodStuffs);
		}
		public function addAllocations(allocationsArray:Array):void {
			for each (var allocation:Allocation in allocationsArray){
				var listItem:AllocationListItem = new AllocationListItem();
				listItem.setAllocation(allocation);
				if(currentListOfStuffDisplay == DISPLAYING_ALLOCS){
					listOfStuff.addItem(listItem);
				}
				allocations.push(listItem);
			}
		}
		public function addAllocation(allocation:Allocation):void {
			var listItem:AllocationListItem = new AllocationListItem();
			listItem.setAllocation(allocation);
			if(currentListOfStuffDisplay == DISPLAYING_ALLOCS){
				listOfStuff.addItem(listItem);
			}
			allocations.push(listItem);
		}
		public function updateAllocation(allocation:Allocation):void {
			var updatedId:String = allocation.getId().toString();
			for each (var alloc:AllocationListItem in allocations){
				if(alloc.getItemID() == updatedId){
					alloc.setAllocation(allocation);
					break;
				}
			}
			//We also need to update the display potentially, providing we are not editing.
			if(!editing){
				if(getSelectedAllocation()==allocation.getId()){
					setAllocationName(allocation.getName());
					setAllocationDiets(allocation.getAllocationDiets());
				}
			}
		}
		public function deleteAllocation(allocationId:int):void {
			var stringId:String = allocationId.toString();
			var newAllocations:Array = new Array();
			for each (var alloc:AllocationListItem in allocations){
				if(alloc.getItemID()!= stringId){
					newAllocations.push(alloc);
				}
			}
			if(currentListOfStuffDisplay == DISPLAYING_ALLOCS){
				listOfStuff.removeItem(stringId);
			}
			allocations = newAllocations;
		}
		public function setAllocationName(newName:String):void {
			allocationDisplay.setAllocationName(newName);
			if(editing){
				this.showFoodsAndDiets();
			} else {
				this.showAllocations();
			}
			this.showHideSaveConfirmCancelButtons();
		}
		public function setEditable(editing:Boolean):void{
			this.editing = editing;
			if(editing){
				this.deleting = false;
			}
			if(editing && allocationDisplay.displayingAllocation){
				this.showFoodsAndDiets();
			} else {
				this.showAllocations();
			}
			this.showHideSaveConfirmCancelButtons();
		}
		public function showAllocationSelection(show:Boolean):void {
			this.deleting = show;
			if(show){
				this.setEditable(false);
			}
			this.showHideSaveConfirmCancelButtons();
		}
		public function clearDisplay():void {
			allocationDisplay.clearDisplay();
		}
		public function setAllocationDiets(allocationDiets:Array):void {
			allocationDisplay.setAllocationDiets(allocationDiets);
		}
		/**
		 * This returns a cut-down version of the diet, and should be treated with care at the far end!
		 */
		public function getAllocationDiets():Array {
			return allocationDisplay.getAllocationDiets();
		}
		public function getSelectedAllocation():int{
			var selectedAllocation:AllocationListItem = listOfStuff.getSelectedListItem() as AllocationListItem;
			return int(selectedAllocation.getItemID());
		}
		public function getAllocationName():String {
			return allocationDisplay.getAllocationName();
		}
		public function destroy():void {
			listOfStuff.destroy();
		}
		private function setup():void {
			var scale:Number = 0.25;
			allocationDisplay = new AllocationDisplay();
			allocationDisplay.x = 0;
			allocationDisplay.y = 0;
			//allocationDisplay.addEventListener(AllocationDiet.DRAG_PLATE_ITEM, startDragOffPlate);
			allocationDisplay.addEventListener(InStockAssetListItem.ASSET_MOUSE_DOWN, startDragOffPlate);
			this.addChild(allocationDisplay);
					
			cancelButton = new CancelBtn1();
			cancelButton.scaleX = cancelButton.scaleY = scale;
			cancelButton.x = -cancelButton.width - GAP_SIZE;
			cancelButton.y = allocationDisplay.y + allocationDisplay.height - cancelButton.height;
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
			listOfStuff.x = allocationDisplay.x + allocationDisplay.width + GAP_SIZE;
			listOfStuff.y = 0;
			listOfStuff.setTitleLabel("Saved Diets");
			this.addChild(listOfStuff);
		}
		private function showFoodsAndDiets():void {
			if(currentListOfStuffDisplay != DISPLAYING_FOODS){
				currentListOfStuffDisplay = DISPLAYING_FOODS;
				listOfStuff.setTitleLabel("Foods and Diets");
				listOfStuff.clearList();
				listOfStuff.setListItemsSelectable(false);
				listOfStuff.removeEventListener(ScrollingList.ITEM_SELECTED, allocationItemSelected);
				listOfStuff.removeEventListener(ScrollingList.SELECTION_CLEARED, allocationItemSelectionCleared);
				for each(var food:InStockAssetListItem in foodStuffs){
					listOfStuff.addItem(food);
					food.addEventListener(MouseEvent.MOUSE_DOWN, startFoodDrag);
				}
				for each (var diet:DietListItem in diets){
					listOfStuff.addItem(diet);
					diet.addEventListener(MouseEvent.MOUSE_DOWN, startFoodDrag);
				}
				allocationDisplay.enabled = true;
			}
		}
		private function showAllocations():void {
			if(currentListOfStuffDisplay != DISPLAYING_ALLOCS){
				currentListOfStuffDisplay = DISPLAYING_ALLOCS;
				listOfStuff.setTitleLabel("Allocations");
				listOfStuff.clearList();
				listOfStuff.setListItemsSelectable(true);
				listOfStuff.addEventListener(ScrollingList.ITEM_SELECTED, allocationItemSelected);
				listOfStuff.addEventListener(ScrollingList.SELECTION_CLEARED, allocationItemSelectionCleared);
				for each (var allocation:AllocationListItem in allocations){
					listOfStuff.addItem(allocation);
				}
				allocationDisplay.enabled = false;
			}
		}
		private function showHideSaveConfirmCancelButtons():void {
			saveButton.visible = false;
			cancelButton.visible = false;
			confirmButton.visible = false;
			
			var actuallyEditing:Boolean = editing && allocationDisplay.displayingAllocation;
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
		private function allocationItemSelected(e:Event):void {
			dispatchEvent(new Event(ALLOCATION_SELECTED));
		}
		private function allocationItemSelectionCleared(e:Event):void {
			dispatchEvent(new Event(ALLOCATION_SELECTION_CLEARED));
		}
		private function saveDiet(e:MouseEvent):void{
			dispatchEvent(new Event(SAVE_ALLOCATION));
		}
		private function cancelEditing(e:MouseEvent):void {
			dispatchEvent(new Event(CANCEL_EDIT));
		}
		
		private function startFoodDrag(e:MouseEvent):void {
			var foodItem:InStockAssetListItem = e.currentTarget as InStockAssetListItem;
			if(foodItem!= null){
				currentAssetNumber = this.getAssetNumber(foodItem.getAsset().getId());
				var dragIcon:InStockAssetListItem = foodItem.getDragCopy();
				this.dragItem(dragIcon);
			} else {
				var dietItem:DietListItem = e.currentTarget as DietListItem;
				var dragDiet:DietListItem = dietItem.getDragCopy();
				this.dragItem(dragDiet);
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
		private function dragItem(dragItem:ListItem):void{
			currentDragItem = dragItem;
			dispatchEvent(new Event(START_DRAGGING));
		}
		public function stopFoodDrag(dragIcon:InStockAssetListItem):void {
			var plateNumber:int = allocationDisplay.testPlateHit(dragIcon);			
			if(plateNumber > -1 && currentAssetNumber != -1){
				allocationDisplay.addItemToPlate(dragIcon, plateNumber);
			} else if (plateNumber==-1){
				
			}
			currentAssetNumber = -1;
		}
		public function stopDietDrag(dragDiet:DietListItem):void {
			if(dragDiet != null){
				var plateNumber:int = allocationDisplay.testPlateHit(dragDiet);
				if(plateNumber > -1){
					var diet:Diet = dragDiet.getDiet();
					
					allocationDisplay.addDietToPlateContents(diet, plateNumber);
				}
				//We need to remove the diet icon whether we hit the plate or not. 
				dragDiet.parent.removeChild(dragDiet);
			}
		}
		private function startDragOffPlate(e:Event):void {
			if(editing){
				var assetIcon:InStockAssetListItem = e.target as InStockAssetListItem;
				if(assetIcon != null){
					var assetNumber:int = this.getAssetNumber(assetIcon.getAsset().getId());
					currentAssetNumber = assetNumber;
					assetIcon.scaleX = assetIcon.scaleY = 0.16;
					this.dragItem(assetIcon);
				}
			}
		}
		private function confirmSelection(e:MouseEvent):void{
			if(deleting){
				this.dispatchEvent(new Event(CONFIRM_ALLOCATION_SELECTION));
			}
		}
	}
}
