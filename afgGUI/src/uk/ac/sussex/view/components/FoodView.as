package uk.ac.sussex.view.components {
	import flash.events.MouseEvent;
	import flash.events.Event;
	import uk.ac.sussex.model.valueObjects.*;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class FoodView extends MovieClip {
		private var allocationDisplay:AllocationDisplay;
		private var dietDisplay:DietDisplay;
		private var listOfStuff:TitledTwoColumnScrollingList;
		private var cancelButton:CancelBtn1;
		private var saveButton:SaveBtn1;
		private var table:Tabletop1_mc;
		//Data structures
		private var allocations:Array;
		private var diets:Array;
		//flags
		private var displayDiets:Boolean = true;
		
		private static const GAP_SIZE:Number = 10;
		
		public static const SAVE_SELECTION:String = "SaveAllocationSelection";
		public static const CANCEL_SELECTION:String = "CancelAllocationSelection";
		public static const ALLOCATION_DISPLAYED:String = "AllocationDisplayed";
		public static const DIET_DISPLAYED:String = "DietDisplayed";
		public static const DISPLAY_CLEARED:String = "DisplayCleared";
		
		public function FoodView() {
			this.setup();
			allocations = new Array();
			diets = new Array();
			showHideSaveCancelButtons(false);
		}
		public function addAllocations(allocationsArray:Array):void {
			for each (var allocation:Allocation in allocationsArray){
				var listItem:AllocationListItem = new AllocationListItem();
				listItem.setAllocation(allocation);
	
				allocations.push(listItem);
			}
			fillListOfStuff();
		}
		public function addDiets(dietsArray:Array):void {
			for each (var diet:Diet in dietsArray){
				var listItem:DietListItem = new DietListItem();
				listItem.setDiet(diet);
				
				diets.push(listItem);
			}
			fillListOfStuff();
		}
		public function showAllocationSelectionScreen(show:Boolean):void {
			displayDiets = !show;
			if(show){
				var currentItem:AllocationListItem = listOfStuff.getSelectedListItem() as AllocationListItem;
			}
			fillListOfStuff();
			listOfStuff.setSelectedItem(currentItem);
			showHideSaveCancelButtons(show);
		}
		public function addFoods(foodArray:Array):void {
			var itemPos:int = 0;
			var foodStuffs:Array= new Array();
			for each (var food:GameAssetFood in foodArray) {
				var listItem:InStockAssetListItem = new InStockAssetListItem();
				listItem.setAsset(food);
				foodStuffs[itemPos] = listItem;
				itemPos ++;
			}
			allocationDisplay.setFoodStuffs(foodStuffs);
			dietDisplay.setFoodStuffs(foodStuffs);
		}
		public function getSelectedDiet():Diet {
			var dietListItem:DietListItem = listOfStuff.getSelectedListItem() as DietListItem;
			if(dietListItem != null){
				return dietListItem.getDiet();
			}
			return null;
		}
		public function getSelectedAllocation():Allocation {
			var allocationListItem:AllocationListItem = listOfStuff.getSelectedListItem() as AllocationListItem;
			if(allocationListItem != null){
				return allocationListItem.getAllocation();
			}
			return null;
		}
		public function updateAllocationSelection():void {
			for each (var ali:AllocationListItem in allocations){
				ali.setAllocationSelected();
			}
		}
		public function updateAllocation(newAlloc:Allocation):void {
			var updatedId:String = newAlloc.getId().toString();
			for each (var alloc:AllocationListItem in allocations){
				if(alloc.getItemID() == updatedId){
					alloc.setAllocation(newAlloc);
					break;
				}
			}
			//We also need to update the display potentially, providing we are not editing.
			var currentAlloc:Allocation = getSelectedAllocation();
			if(currentAlloc!=null){
				if(currentAlloc.getId()==newAlloc.getId()){
					this.displayAllocation(newAlloc);
				}
			}
			
		}
		public function deleteAllocation():void {
			
		}
		private function fillListOfStuff():void {
			listOfStuff.clearList();
			var listOfStuffTitle:String = "Allocations";
			if(displayDiets){
				listOfStuffTitle = "Diets & " + listOfStuffTitle;
				for each (var diet:DietListItem in diets){
					listOfStuff.addItem(diet);
				}
			}
			listOfStuff.setTitleLabel(listOfStuffTitle);
			for each (var alloc:AllocationListItem in allocations){
				listOfStuff.addItem(alloc);
			}
		}
		private function setup():void {
			
			allocationDisplay = new AllocationDisplay();
			allocationDisplay.x = 0;
			allocationDisplay.y = 0;
			allocationDisplay.enabled = false;
			
			dietDisplay = new DietDisplay();
			dietDisplay.x = 0;
			dietDisplay.y = 0;
			dietDisplay.enabled = false;
			
			table = new Tabletop1_mc();
			table.width = 420;
			table.height = 240;
			table.x = allocationDisplay.x;
			table.y = allocationDisplay.height - table.height;
			this.addChild(table);
			
			var scale:Number = 0.25;
			
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
			
			listOfStuff = new TitledTwoColumnScrollingList();
			listOfStuff.x = allocationDisplay.x + allocationDisplay.width + GAP_SIZE;
			listOfStuff.y = 0;
			listOfStuff.setTitleLabel("Diets & Allocations");
			listOfStuff.setListItemsSelectable(true);
			listOfStuff.addEventListener(ScrollingList.ITEM_SELECTED, itemSelected);
			listOfStuff.addEventListener(ScrollingList.SELECTION_CLEARED, itemSelectionCleared);
			this.addChild(listOfStuff);
		}
		private function showHideSaveCancelButtons(show:Boolean):void{
			saveButton.visible = show;
			cancelButton.visible = show;
			if(show){
				saveButton.addEventListener(MouseEvent.CLICK, saveAllocationSelection);
				cancelButton.addEventListener(MouseEvent.CLICK, cancelEditing);
			} else {
				saveButton.removeEventListener(MouseEvent.CLICK, saveAllocationSelection);
				cancelButton.removeEventListener(MouseEvent.CLICK, cancelEditing);
			}
		}
		private function itemSelected(e:Event):void {
			if(table.parent != null){
				table.parent.removeChild(table);
			}
			var allocationListItem:AllocationListItem = listOfStuff.getSelectedListItem() as AllocationListItem;
			if(allocationListItem != null){
				var allocation:Allocation = allocationListItem.getAllocation();
				this.displayAllocation(allocation);
				if(dietDisplay.parent != null){
					dietDisplay.parent.removeChild(dietDisplay);
				}
				this.addChild(allocationDisplay);
				dispatchEvent(new Event(ALLOCATION_DISPLAYED));
			} else {
				var dietListItem:DietListItem = listOfStuff.getSelectedListItem() as DietListItem;
				var diet:Diet = dietListItem.getDiet();
				dietDisplay.setDietName(diet.getName());
				dietDisplay.setDietTarget(diet.getTarget());
				dietDisplay.setPlateContents(diet.getDietItems());
				if(allocationDisplay.parent != null){
					allocationDisplay.parent.removeChild(allocationDisplay);
				}
				this.addChild(dietDisplay);
				dispatchEvent(new Event(DIET_DISPLAYED));
			}
		}
		private function itemSelectionCleared(e:Event):void {
			allocationDisplay.clearDisplay();
			if(allocationDisplay.parent != null){
				allocationDisplay.parent.removeChild(allocationDisplay);
			}
			dietDisplay.clearDisplay();
			if(dietDisplay.parent != null){
				dietDisplay.parent.removeChild(dietDisplay);
			}
			this.addChild(table);
			dispatchEvent(new Event(DISPLAY_CLEARED));
		}
		private function saveAllocationSelection(e:MouseEvent):void {
			dispatchEvent(new Event(SAVE_SELECTION));
		}
		private function cancelEditing(e:MouseEvent):void {
			dispatchEvent(new Event(CANCEL_SELECTION));
		}
		private function displayAllocation(allocation:Allocation):void{
			allocationDisplay.setAllocationName(allocation.getName());
			allocationDisplay.setAllocationDiets(allocation.getAllocationDiets());
		}
	}
}
