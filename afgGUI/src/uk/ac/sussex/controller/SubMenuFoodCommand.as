/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.view.FoodViewMediator;
	import uk.ac.sussex.states.AllocationGameState;
	import uk.ac.sussex.states.DietGameState;
	import uk.ac.sussex.states.HomeGameState;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SubMenuFoodCommand extends SimpleCommand {
		override public function execute(note:INotification):void{
			var foodViewMediator:FoodViewMediator = facade.retrieveMediator(FoodViewMediator.NAME) as FoodViewMediator;
			var subMenuItem:String = note.getBody() as String;
			trace("SubMenuFoodCommand sez: Trying to fire off " + subMenuItem);
			switch(subMenuItem){
				case HomeHandlers.FOOD_SUB_MENU_ALLOCATION:
					sendNotification(ApplicationFacade.CHANGE_STATE, AllocationGameState.NAME);
					break;
				case HomeHandlers.FOOD_SUB_MENU_DIET:
					sendNotification(ApplicationFacade.CHANGE_STATE, DietGameState.NAME);
					break;
				case HomeHandlers.FOOD_SUB_MENU_EXIT:
					//Need to return to the home view. 
					sendNotification(ApplicationFacade.CHANGE_STATE, HomeGameState.NAME);
					break;
				case HomeHandlers.FOOD_SUB_MENU_OVERVIEW:
					var overviewText:String = "Food and Nutrition:\n";
					overviewText += "This is where you manage food allocation for your household. You can create individual diets for use in household allocations or create allocations directly. When you have finishing setting up allocations you must select one that will be applied to your household. Household members on poorer diets (B or C level) are more likely to become ill or die. Anyone on an X-level diet will die of malnutrition. \n";
					overviewText += "\nClick on the icons to view the contents of the diets or allocations.\n";
					overviewText += "\nChoose 'Diets' to create or edit the list of diets.\n";
					overviewText += "\nTo create or edit your allocations, click 'Allocations'.\n";
					overviewText += "\nTo choose the allocation to use for the next year, click on 'Select'.";
					sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, overviewText);
					if(foodViewMediator!= null){
						foodViewMediator.displayAllocationSelectionScreen(false);
					}
					break;
				case HomeHandlers.FOOD_SUB_MENU_SELECT:
					var selectText:String = "Select Allocation\n\nSelect the required allocation, then choose save to confirm.";
					sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, selectText);
					foodViewMediator.displayAllocationSelectionScreen(true);
					break;
				default:
					trace("SubMenuFoodCommand sez: I didn't recognise the name of that.");
			}
		}
	}
}
