/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view {
	import uk.ac.sussex.view.components.DietListItem;
	import uk.ac.sussex.view.components.InStockAssetListItem;
	import flash.display.MovieClip;
//	import uk.ac.sussex.model.valueObjects.DietItem;
//	import uk.ac.sussex.model.valueObjects.Diet;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.model.DietListProxy;
	import uk.ac.sussex.model.GameAssetListProxy;
	import uk.ac.sussex.model.valueObjects.Allocation;
	import uk.ac.sussex.model.AllocationListProxy;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import flash.events.Event;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.view.components.AllocationCreation;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.interfaces.IMediator;

	/**
	 * @author em97
	 */
	public class AllocationCreationMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "AllocationCreationMediator";
		
		private var allocationLP:AllocationListProxy;
		
		var dietsListProxy:DietListProxy;
		
		public function AllocationCreationMediator() {
			super(NAME, null);
		}
		override public function listNotificationInterests():Array {
			return [ AllocationListProxy.CURRENT_ALLOCATION_CHANGED,
					 DietListProxy.NEW_DIETS_ADDED, 
					 DietListProxy.NEW_DIET_ADDED, 
					 AllocationListProxy.NEW_ALLOCATIONS_ADDED, 
					 AllocationListProxy.NEW_ALLOCATION_ADDED, 
					 AllocationListProxy.ALLOCATION_UPDATED, 
					 AllocationListProxy.ALLOCATION_DELETED, 
					 DragLayerMediator.DRAG_STOPPED ];
		}
		override public function handleNotification (note:INotification):void {
			switch (note.getName()){
				case AllocationListProxy.CURRENT_ALLOCATION_CHANGED:
					sendNotification(ApplicationFacade.REVERT_TEMP_INFO_TEXT);
					var allocation:Allocation = allocationLP.getCurrentAllocation();
					if(allocation!= null){
						allocationCreation.setAllocationName(allocation.getName());
						allocationCreation.setAllocationDiets(allocation.getAllocationDiets());
					} else {
						allocationCreation.clearDisplay();
					}
					break;
				case DietListProxy.NEW_DIET_ADDED:
				case DietListProxy.NEW_DIETS_ADDED:
					allocationCreation.addDiets(dietsListProxy.getDiets());
					break;
				case AllocationListProxy.NEW_ALLOCATIONS_ADDED:
					allocationCreation.addAllocations(allocationLP.getAllocations());
					break;
				case AllocationListProxy.NEW_ALLOCATION_ADDED:
					var newAllocation:Allocation = note.getBody() as Allocation;
					allocationCreation.addAllocation(newAllocation);
					break;
				case AllocationListProxy.ALLOCATION_UPDATED:
					var updatedAllocation:Allocation = note.getBody() as Allocation;
					allocationCreation.updateAllocation(updatedAllocation);
					break;
				case AllocationListProxy.ALLOCATION_DELETED:
					var allocationId:int = note.getBody() as int;
					
					allocationCreation.deleteAllocation(allocationId);
					break;
				case DragLayerMediator.DRAG_STOPPED:
					var droppedItem:MovieClip = note.getBody() as MovieClip;
					if(droppedItem is InStockAssetListItem){
						allocationCreation.stopFoodDrag(droppedItem as InStockAssetListItem);
					} else if (droppedItem is DietListItem){
						allocationCreation.stopDietDrag(droppedItem as DietListItem);
					}
			}
		}
		public function allowEdit(canEdit:Boolean):void {
			allocationCreation.setEditable(canEdit);
		}
		public function allowDeletion(canDelete:Boolean):void {
			allocationCreation.showAllocationSelection(canDelete);
		}
		/**
		private function displayAllocationTotals(allocation:Allocation):void {
			var title:String = "Allocation Totals:\n";
			var allocationDiets:Array = allocation.getAllocationDiets();
			var totalAmounts:Array = new Array();
			for each (var diet:Diet in allocationDiets){
				var dietItems:Array = diet.getDietItems();
				for each (var dietItem:DietItem in dietItems){
					var dietItemName:String = dietItem.getAsset().getName();
					var dietAmount:int = dietItem.getAmount();
					var dietItemMeasurement:String = dietItem.getAsset().getMeasurement();
					if(totalAmounts[dietItemName] == null){
						totalAmounts[dietItemName] = new Array(0, dietItemName, dietItemMeasurement);
					}
					totalAmounts[dietItemName][0] += dietAmount;
				}
			}
			var totalText:String = "";
			for each (var item:Array in totalAmounts){
				var totalplural:String = (item[0]!=1?"s":"");
				totalText += item[0] + " " + item[2] + totalplural + " " + item[1] + "\n";
			}
			sendNotification(ApplicationFacade.DISPLAY_TEMP_INFO_TEXT, title + totalText);
		}**/
		private function cancelEdit(e:Event):void {
			sendNotification(ApplicationFacade.SWITCH_SUBMENU_ITEM, HomeHandlers.DIET_SUB_MENU_OVERVIEW);
		}
		private function saveAllocation(e:Event):void {
			trace("AllocationCreationMediator sez: We should be saving an allocation around now.");
			var allocation:Allocation = allocationLP.getCurrentAllocation();
			allocation.setName(allocationCreation.getAllocationName());
			allocation.setAllocationDiets(allocationCreation.getAllocationDiets());
			sendNotification(HomeHandlers.SAVE_ALLOCATION, allocation);
		}
		private function changeAllocationSelection(e:Event):void {
			var newId:int = allocationCreation.getSelectedAllocation();
			allocationLP.changeCurrentAllocation(newId);
		}
		private function clearAllocationSelection(e:Event):void {
			allocationLP.clearCurrentAllocation();
		}
		private function confirmDeletion(e:Event):void {
			var currentAllocation:Allocation = allocationLP.getCurrentAllocation();
			if(currentAllocation != null){
				var deleteProxy:RequestProxy = facade.retrieveProxy(HomeHandlers.DELETE_ALLOCATION + RequestProxy.NAME) as RequestProxy;
				deleteProxy.setParamValue("AllocationId", currentAllocation.getId());
				deleteProxy.sendRequest();
				allocationLP.deleteAllocation(currentAllocation.getId());
				sendNotification(ApplicationFacade.SWITCH_SUBMENU_ITEM, HomeHandlers.DIET_SUB_MENU_OVERVIEW);
			}
		}
		private function startDrag(e:Event):void {
			trace("AllocationCreationMediator sez: I'm dragging");
			var dragItem:MovieClip = allocationCreation.currentDragItem;
			sendNotification(ApplicationFacade.ADD_TO_DRAGLAYER, dragItem);
		}
		protected function get allocationCreation():AllocationCreation {
			return viewComponent as AllocationCreation;
		}
		override public function onRegister():void {
			viewComponent = new AllocationCreation();
			
			var submenuMediator:SubMenuMediator = facade.retrieveMediator(SubMenuMediator.NAME) as SubMenuMediator;
			
			allocationCreation.x = submenuMediator.getSubmenuWidth();
			allocationCreation.y = 10;
			
			allocationLP = facade.retrieveProxy(AllocationListProxy.NAME) as AllocationListProxy;
			
			var gameAssetListProxy:GameAssetListProxy = facade.retrieveProxy(GameAssetListProxy.NAME) as GameAssetListProxy;
			if(gameAssetListProxy != null){
				allocationCreation.addFoods(gameAssetListProxy.getFoodAssets());
			}
			dietsListProxy = facade.retrieveProxy(DietListProxy.NAME) as DietListProxy;
			if(dietsListProxy != null){
				trace("AllocationCreationMediator sez: DietsListProxy is not null");
				allocationCreation.addDiets(dietsListProxy.getDiets());
			}
			
			sendNotification(ViewAreaMediator.ADD_VIEW_COMPONENT, allocationCreation);
			allocationCreation.addEventListener(AllocationCreation.CANCEL_EDIT, cancelEdit);
			allocationCreation.addEventListener(AllocationCreation.SAVE_ALLOCATION, saveAllocation);
			allocationCreation.addEventListener(AllocationCreation.ALLOCATION_SELECTED, changeAllocationSelection);
			allocationCreation.addEventListener(AllocationCreation.ALLOCATION_SELECTION_CLEARED, clearAllocationSelection);
			allocationCreation.addEventListener(AllocationCreation.CONFIRM_ALLOCATION_SELECTION, confirmDeletion);
			allocationCreation.addEventListener(AllocationCreation.START_DRAGGING, startDrag);
		}
		override public function onRemove():void {
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, allocationCreation);
			allocationCreation.removeEventListener(AllocationCreation.CANCEL_EDIT, cancelEdit);
			allocationCreation.removeEventListener(AllocationCreation.SAVE_ALLOCATION, saveAllocation);
			allocationCreation.removeEventListener(AllocationCreation.ALLOCATION_SELECTED, changeAllocationSelection);
			allocationCreation.removeEventListener(AllocationCreation.ALLOCATION_SELECTION_CLEARED, clearAllocationSelection);
			allocationCreation.removeEventListener(AllocationCreation.CONFIRM_ALLOCATION_SELECTION, confirmDeletion);
			allocationCreation.removeEventListener(AllocationCreation.START_DRAGGING, startDrag);
			allocationCreation.destroy();
		}
	}
}
