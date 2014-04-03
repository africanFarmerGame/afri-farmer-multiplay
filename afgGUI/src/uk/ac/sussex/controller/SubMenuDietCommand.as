/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.Diet;
	import uk.ac.sussex.view.DietCreationMediator;
	import uk.ac.sussex.model.*;
	import uk.ac.sussex.states.FoodGameState;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SubMenuDietCommand extends SimpleCommand {
		override public function execute(note:INotification):void{
			
			var subMenuItem:String = note.getBody() as String;
			trace("SubMenuDietCommand sez: Trying to fire off " + subMenuItem);
			switch(subMenuItem){
				case HomeHandlers.DIET_SUB_MENU_DELETE:
					this.deleteDiet();
					break;
				case HomeHandlers.DIET_SUB_MENU_EDIT:
					this.editDiet();
					break;
				case HomeHandlers.DIET_SUB_MENU_EXIT:
					//Need to return to the food view. 
					sendNotification(ApplicationFacade.CHANGE_STATE, FoodGameState.NAME);
					break;
				case HomeHandlers.DIET_SUB_MENU_NEW:
					this.createDiet();
					break;
				case HomeHandlers.DIET_SUB_MENU_OVERVIEW:
					this.displayOverview();
				break;
				default:
					trace("SubMenuDietCommand sez: I didn't recognise the name of that.");
			}
		}
		private function displayOverview():void {
			var dietCreationMediator:DietCreationMediator = facade.retrieveMediator(DietCreationMediator.NAME) as DietCreationMediator;
			if(dietCreationMediator != null){
	 			dietCreationMediator.allowEdit(false);
				dietCreationMediator.allowDeletion(false);
			}
			var dietListProxy:DietListProxy = facade.retrieveProxy(DietListProxy.NAME) as DietListProxy;
			dietListProxy.clearCurrentDiet();
			var helptext:String = "Diet Management:\n";
			/**
			if(dietListProxy.getNumberOfDiets()==0){
				helptext += "\nThere are no saved diets.\n";
			}**/
			helptext += "\nHere you can create, edit and delete diets. ";
			helptext += "\nDrag and drop food on and off the plate to create or modify a diet.";
			helptext += "\nThe Diet Level depends on both the quantity and variety of selected foods. A C-level diet is the minimum required for survival. Adult males have the highest nutritional requirements, followed by women and children and finally  babies.";

			sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, helptext);
		}
		private function createDiet():void {
			var dietCreationMediator:DietCreationMediator = facade.retrieveMediator(DietCreationMediator.NAME) as DietCreationMediator;
			dietCreationMediator.allowEdit(true);
			dietCreationMediator.allowDeletion(false);
			var dietListProxy:DietListProxy = facade.retrieveProxy(DietListProxy.NAME) as DietListProxy;
			dietListProxy.createNewDiet();
			var helptext:String = "Create Diet\nGive your diet a name and select the target diet type.\n\nThen drag the required food icons to the plate until the diet is complete.\n\nClick 'Save' when finished.";
			sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, helptext);
		}
		private function editDiet():void {
			var dlp:DietListProxy = facade.retrieveProxy(DietListProxy.NAME) as DietListProxy;
			var currentDiet:Diet = dlp.getCurrentDiet();
			if(currentDiet!=null && currentDiet.getId()==-1){
				dlp.clearCurrentDiet();
			}
			var dietCreationMediator:DietCreationMediator = facade.retrieveMediator(DietCreationMediator.NAME) as DietCreationMediator;
			dietCreationMediator.allowEdit(true);
			dietCreationMediator.allowDeletion(false);
			var sideTxt:String = "Edit Diet \n";
			sideTxt += "Select a diet from the list to edit, complete the necessary changes, then click save to confirm.\n";
			sideTxt += "\nClicking cancel will discard any changes you have made and return to the overview.";
			sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, sideTxt);
		}
		private function deleteDiet():void {
			var dlp:DietListProxy = facade.retrieveProxy(DietListProxy.NAME) as DietListProxy;
			var currentDiet:Diet = dlp.getCurrentDiet();
			if(currentDiet!=null && currentDiet.getId()==-1){
				dlp.clearCurrentDiet();
			}
			var dcm:DietCreationMediator = facade.retrieveMediator(DietCreationMediator.NAME) as DietCreationMediator;
			dcm.allowEdit(false);
			dcm.allowDeletion(true);
			var sideTxt:String = "Delete Diet\n";
			sideTxt += "Choose a diet to delete, then confirm your selection by clicking the confirm button. Cancel exits without deleting.\n";
			sideTxt += "\nDeleting cannot be undone!";
			sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, sideTxt);
		}
	}
}
