/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view {
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import uk.ac.sussex.model.valueObjects.HearthAsset;
	import uk.ac.sussex.model.valueObjects.Allocation;
	import uk.ac.sussex.model.valueObjects.DietItem;
	import uk.ac.sussex.model.valueObjects.Diet;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import flash.events.Event;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.*;
	import uk.ac.sussex.view.components.FoodView;
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	/**
	 * @author em97
	 */
	public class FoodViewMediator extends Mediator implements IMediator {
		public static const NAME:String = "FoodViewMediator";
		
		private var allocationLP:AllocationListProxy;
		private var dietLP:DietListProxy;
		private var gameAssetLP:GameAssetListProxy;
		
		public function FoodViewMediator() {
			super(NAME, null);
		}
		override public function listNotificationInterests():Array {
			return [ AllocationListProxy.NEW_ALLOCATIONS_ADDED, 
					 DietListProxy.NEW_DIETS_ADDED, 
					 GameAssetListProxy.FOOD_ASSETS_ADDED, 
					 AllocationListProxy.SELECTED_ALLOCATION_CHANGED, 
					 AllocationListProxy.ALLOCATION_UPDATED, 
					 AllocationListProxy.ALLOCATION_DELETED
					];
		}
		
		override public function handleNotification (note:INotification):void {
			switch ( note.getName() ) {
				case AllocationListProxy.NEW_ALLOCATIONS_ADDED:
					foodView.addAllocations(allocationLP.getAllocations());
					break;
				case DietListProxy.NEW_DIETS_ADDED:
					foodView.addDiets(dietLP.getDiets());
					break;
				case GameAssetListProxy.FOOD_ASSETS_ADDED:
					foodView.addFoods(gameAssetLP.getFoodAssets());
					break;
				case AllocationListProxy.SELECTED_ALLOCATION_CHANGED:
					foodView.updateAllocationSelection();
					break;
				case AllocationListProxy.ALLOCATION_UPDATED:
					var updatedAllocation:Allocation = note.getBody() as Allocation;
					foodView.updateAllocation(updatedAllocation);
					break;
				case AllocationListProxy.ALLOCATION_DELETED:
					//TODO Make this actually work.
					foodView.deleteAllocation();
					break;
			}
		}
		public function displayAllocationSelectionScreen(show:Boolean):void {
			foodView.showAllocationSelectionScreen(show);
		}
		private function saveSelection(e:Event):void {
			var selectedAllocation:Allocation = foodView.getSelectedAllocation();
			if(selectedAllocation != null){
				sendNotification(HomeHandlers.SET_SELECTED_ALLOCATION, selectedAllocation.getId());			
			}
			sendNotification(ApplicationFacade.SWITCH_SUBMENU_ITEM, HomeHandlers.FOOD_SUB_MENU_OVERVIEW);
		}
		private function cancelSelectionProcess(e:Event):void {
			sendNotification(ApplicationFacade.SWITCH_SUBMENU_ITEM, HomeHandlers.FOOD_SUB_MENU_OVERVIEW);
		}
		private function displayDiet(e:Event):void{
			sendNotification(ApplicationFacade.REVERT_TEMP_INFO_TEXT);
			var selectedDiet:Diet = foodView.getSelectedDiet();
			sendNotification(HomeHandlers.DISPLAY_DIET, selectedDiet);
			if(selectedDiet!=null){
				dietLP.changeCurrentDiet(selectedDiet.getId());
				var dietText:String = "Diet: " +selectedDiet.getName() + "\n";
				dietText += "Contents:";
				var dietItems:Array = selectedDiet.getDietItems();
				for each (var item:DietItem in dietItems){
					dietText += "\n" + item.getAmount() + "m " + item.getAsset().getName();
				}
				sendNotification(ApplicationFacade.DISPLAY_TEMP_INFO_TEXT, dietText);
			}
		}
		private function displayAllocation(e:Event):void {
			sendNotification(ApplicationFacade.REVERT_TEMP_INFO_TEXT);
			sendNotification(HomeHandlers.DISPLAY_DIET, null);
			
			var sideTextMessage:String = "Allocation Totals:\n\n";
			var hearthAssetsLP:HearthAssetListProxy = facade.retrieveProxy(HearthAsset.OWNER_HEARTH + HearthAssetListProxy.NAME ) as HearthAssetListProxy;
			var gameAssetsLP:GameAssetListProxy = facade.retrieveProxy(GameAssetListProxy.NAME) as GameAssetListProxy;
			if(gameAssetsLP!=null){
				var foodGameAssets:Array = gameAssetsLP.getFoodAssets();
				var currentAllocation:Allocation = foodView.getSelectedAllocation();
				if(currentAllocation!=null){
					//Work through the allocation
					var allocationTotals:Array = new Array();
					for each (var food1:GameAsset in foodGameAssets){
						allocationTotals[food1.getName()] = 0;
					}
					sideTextMessage += "Allocation: " + currentAllocation.getName() +"\n";
					var currentDiets:Array = currentAllocation.getAllocationDiets();
					var allocText:String = "Detail:\n";
					for each (var diet:Diet in currentDiets){
						allocText += diet.getName() + ", " + Diet.translateDietTargetToText(diet.getTarget()) + ":\n";
						var dietItems:Array = diet.getDietItems();
						for each (var dietItem:DietItem in dietItems)
						{
							var dietItemName:String = dietItem.getAsset().getName();
							var dietAmount:int = dietItem.getAmount();
							allocationTotals[dietItemName] += dietAmount;
							var plural:String = (dietAmount!=1?"s":"");
							allocText += dietAmount + " " + dietItem.getAsset().getMeasurement() + plural + " " + dietItemName + "\n";
						}
						
					}
					for each (var food3:GameAsset in foodGameAssets){
						sideTextMessage += allocationTotals[food3.getName()] + " " + food3.getMeasurement() + "(s) " + food3.getName() + "\n";
					}
					sideTextMessage += "\n";
					//Set up the current hearth amounts;
					if(hearthAssetsLP!=null){
						sideTextMessage += "You currently have: \n";
						for each (var food2:GameAsset in foodGameAssets){
							var hearthAsset:HearthAsset = hearthAssetsLP.fetchHearthAssetByAssetId(food2.getId());
							sideTextMessage += hearthAsset.getAmount() + " " + food2.getMeasurement() + "(s) " + food2.getName() + "\n"; 
						}
						sideTextMessage += "\n";
					}
					
					sendNotification(ApplicationFacade.DISPLAY_TEMP_INFO_TEXT, sideTextMessage + allocText);
				} 
			}
		}
		private function clearDietAllocationSelection(e:Event):void {
			sendNotification(HomeHandlers.DISPLAY_DIET, null);
			sendNotification(ApplicationFacade.REVERT_TEMP_INFO_TEXT);
		}
		//Cast the viewComponent to the correct type.
		protected function get foodView():FoodView {
			return viewComponent as FoodView;
		}
		override public function onRegister():void {
			viewComponent = new FoodView();
			
			var submenuMediator:SubMenuMediator = facade.retrieveMediator(SubMenuMediator.NAME) as SubMenuMediator;
			foodView.x = submenuMediator.getSubmenuWidth();
			foodView.y = 10;
			
			allocationLP = facade.retrieveProxy(AllocationListProxy.NAME) as AllocationListProxy;
			
			gameAssetLP = facade.retrieveProxy(GameAssetListProxy.NAME) as GameAssetListProxy;
			if(gameAssetLP != null){
				foodView.addFoods(gameAssetLP.getFoodAssets());
			}
			dietLP = facade.retrieveProxy(DietListProxy.NAME) as DietListProxy;
			if(dietLP != null){
				foodView.addDiets(dietLP.getDiets());
			}
			foodView.addEventListener(FoodView.SAVE_SELECTION, saveSelection);
			foodView.addEventListener(FoodView.CANCEL_SELECTION, cancelSelectionProcess);
			foodView.addEventListener(FoodView.ALLOCATION_DISPLAYED, displayAllocation);
			foodView.addEventListener(FoodView.DIET_DISPLAYED, displayDiet);
			foodView.addEventListener(FoodView.DISPLAY_CLEARED, clearDietAllocationSelection);
			sendNotification(ViewAreaMediator.ADD_VIEW_COMPONENT, foodView);
		}
		override public function onRemove():void {
			foodView.removeEventListener(FoodView.SAVE_SELECTION, saveSelection);
			foodView.removeEventListener(FoodView.CANCEL_SELECTION, cancelSelectionProcess);
			foodView.removeEventListener(FoodView.ALLOCATION_DISPLAYED, displayAllocation);
			foodView.removeEventListener(FoodView.DIET_DISPLAYED, displayDiet);
			foodView.removeEventListener(FoodView.DISPLAY_CLEARED, clearDietAllocationSelection);
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, foodView);
		}
	}
}
