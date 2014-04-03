/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view {
	import uk.ac.sussex.view.components.DietPlate;
	import uk.ac.sussex.view.components.InStockAssetListItem;
	import flash.display.MovieClip;
	import uk.ac.sussex.view.components.DietDisplay;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.model.valueObjects.DietItem;
	import uk.ac.sussex.model.valueObjects.Diet;
	import flash.events.Event;
	import uk.ac.sussex.model.GameAssetListProxy;
	import uk.ac.sussex.model.DietListProxy;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.view.components.DietCreation;
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	/**
	 * @author em97
	 */
	public class DietCreationMediator extends Mediator implements IMediator {
		public static const NAME:String = "DietOverviewMediator";
		
		private var dietListProxy:DietListProxy;
		private var gameAssetListProxy:GameAssetListProxy;
		
		public function DietCreationMediator() {
			super(NAME, null);
		}
		
		override public function listNotificationInterests():Array {
			return [DietListProxy.CURRENT_DIET_CHANGED, 
					DietListProxy.NEW_DIET_ADDED, 
					DietListProxy.NEW_DIETS_ADDED,
					DietListProxy.DIET_UPDATED, 
					GameAssetListProxy.FOOD_ASSETS_ADDED, 
					DietListProxy.DIET_DELETED, 
					DragLayerMediator.DRAG_STOPPED];
		}
		override public function handleNotification (note:INotification):void {
			switch (note.getName()){
				case DietListProxy.CURRENT_DIET_CHANGED:
					var diet:Diet = dietListProxy.getCurrentDiet();
					if(diet != null){
						dietCreation.setDietName(diet.getName());
						dietCreation.setDietTarget(diet.getTarget());
						dietCreation.setPlateContents(diet.getDietItems());
					} else {
						dietCreation.clearDisplay();
					}
					break;
				case DietListProxy.NEW_DIET_ADDED:
					var newDiet:Diet = note.getBody() as Diet;
					dietCreation.addDiet(newDiet);
					break;
				case DietListProxy.NEW_DIETS_ADDED:
					var diets:Array = note.getBody() as Array;
					dietCreation.addDiets(diets);
					break;
				case DietListProxy.DIET_UPDATED:
					var updatedDiet:Diet = note.getBody() as Diet;
					dietCreation.updateDiet(updatedDiet);
					break;
				case GameAssetListProxy.FOOD_ASSETS_ADDED:
					//TODO need to decide what to do with this one. 
					break;
				case DietListProxy.DIET_DELETED:
				trace("DietCreationMediator sez: We are deleting a diet");
					var dietId:int = note.getBody() as int;
					dietCreation.deleteDiet(dietId);
					break;
				case DragLayerMediator.DRAG_STOPPED:
					var dragItem:InStockAssetListItem = note.getBody() as InStockAssetListItem;
					trace("DietCreationMediator sez: We're dropped a " + dragItem.toString());
					dietCreation.stopFoodDrag(dragItem);
					break;
			}
		}
		public function allowEdit(canEdit:Boolean):void {
			dietCreation.setEditable(canEdit);
		}
		public function allowDeletion(canDelete:Boolean):void {
			dietCreation.showDietSelection(canDelete);
		}
		private function plateContentsChanged(e:Event):void{
			trace("DietCreationMediator sez: the plate contents changed");
			var currentDiet:Diet = dietListProxy.getCurrentDiet();
			currentDiet.setDietItems(dietCreation.getPlateContents());
			for each (var dietItem:DietItem in currentDiet.getDietItems()){
				trace("DietCreationMediator sez: The current diet has " + dietItem.getAmount() + " portions of " + dietItem.getAsset().getName());
			}
		}
		private function dietNameChanged(e:Event):void {
			trace("DietCreationMediator sez: the diet name changed");
			var currentDiet:Diet = dietListProxy.getCurrentDiet();
			currentDiet.setName(dietCreation.getDietName());
		}
		private function cancelEdit(e:Event):void {
			sendNotification(ApplicationFacade.SWITCH_SUBMENU_ITEM, HomeHandlers.DIET_SUB_MENU_OVERVIEW);
		}
		private function saveTheDiet(e:Event):void {
			trace("DietCreationMediator sez: We should be saving the diet round about now.");
			sendNotification(HomeHandlers.SAVE_DIET, dietListProxy.getCurrentDiet());
		}
		private function dietTargetChanged(e:Event):void {
			var currentDiet:Diet = dietListProxy.getCurrentDiet();
			currentDiet.setTarget(int(dietCreation.getDietTarget()));
		}
		private function changeDiet(e:Event):void{
			dietListProxy.changeCurrentDiet(dietCreation.getSelectedDiet());
		}
		private function clearSelectedDiet(e:Event):void {
			dietListProxy.clearCurrentDiet();
		}
		private function confirmDeletion(e:Event):void {
			var currentDiet:Diet = dietListProxy.getCurrentDiet();
			if(currentDiet != null){
				var deleteProxy:RequestProxy = facade.retrieveProxy(HomeHandlers.DELETE_DIET + RequestProxy.NAME) as RequestProxy;
				deleteProxy.setParamValue("DietId", currentDiet.getId());
				deleteProxy.sendRequest();
				dietListProxy.deleteDiet(currentDiet.getId());
				sendNotification(ApplicationFacade.SWITCH_SUBMENU_ITEM, HomeHandlers.DIET_SUB_MENU_OVERVIEW);
			}
		}
		private function startDragging(e:Event):void {
			trace("DietCreationMediator sez: I'm dragging");
			var dragItem:MovieClip= dietCreation.currentDragItem;
			sendNotification(ApplicationFacade.ADD_TO_DRAGLAYER, dragItem);
		}
		protected function get dietCreation():DietCreation {
			return viewComponent as DietCreation;
		}
		override public function onRegister():void {
			viewComponent = new DietCreation();
			var submenuMediator:SubMenuMediator = facade.retrieveMediator(SubMenuMediator.NAME) as SubMenuMediator;
			
			dietCreation.x = submenuMediator.getSubmenuWidth();
			dietCreation.y = 10;
			dietCreation.setEditable(false);
			sendNotification(ViewAreaMediator.ADD_VIEW_COMPONENT, dietCreation);
			
			dietListProxy = facade.retrieveProxy(DietListProxy.NAME) as DietListProxy;
			gameAssetListProxy = facade.retrieveProxy(GameAssetListProxy.NAME) as GameAssetListProxy;
			if(gameAssetListProxy != null){
				dietCreation.addFoods(gameAssetListProxy.getFoodAssets());
			}
		 	dietCreation.addEventListener(DietDisplay.DIET_NAME_CHANGED, dietNameChanged);
			dietCreation.addEventListener(DietPlate.PLATE_CONTENTS_CHANGED, plateContentsChanged);
			dietCreation.addEventListener(DietCreation.CANCEL_EDIT, cancelEdit);
			dietCreation.addEventListener(DietCreation.SAVE_DIET, saveTheDiet);
			dietCreation.addEventListener(DietDisplay.DIET_TARGET_CHANGED, dietTargetChanged);
			dietCreation.addEventListener(DietCreation.DIET_SELECTED, changeDiet);
			dietCreation.addEventListener(DietCreation.DIET_SELECTION_CLEARED, clearSelectedDiet);
			dietCreation.addEventListener(DietCreation.CONFIRM_DIET_SELECTION, confirmDeletion);
			dietCreation.addEventListener(DietCreation.START_DRAGGING, startDragging);
		}
		
		override public function onRemove():void {
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, dietCreation);
			dietCreation.removeEventListener(DietPlate.PLATE_CONTENTS_CHANGED, plateContentsChanged);
			dietCreation.removeEventListener(DietDisplay.DIET_NAME_CHANGED, dietNameChanged);
			dietCreation.removeEventListener(DietCreation.CANCEL_EDIT, cancelEdit);
			dietCreation.removeEventListener(DietCreation.SAVE_DIET, saveTheDiet);
			dietCreation.removeEventListener(DietDisplay.DIET_TARGET_CHANGED, dietTargetChanged);
			dietCreation.removeEventListener(DietCreation.DIET_SELECTED, changeDiet);
			dietCreation.removeEventListener(DietCreation.DIET_SELECTION_CLEARED, clearSelectedDiet);
			dietCreation.removeEventListener(DietCreation.CONFIRM_DIET_SELECTION, confirmDeletion);
			dietCreation.removeEventListener(DietCreation.START_DRAGGING, startDragging);
		}
	}
}
