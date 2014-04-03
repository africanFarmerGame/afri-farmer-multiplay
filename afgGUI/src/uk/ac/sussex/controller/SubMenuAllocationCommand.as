/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.Allocation;
	import uk.ac.sussex.model.AllocationListProxy;
	import uk.ac.sussex.view.AllocationCreationMediator;
	import uk.ac.sussex.states.FoodGameState;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.general.ApplicationFacade;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SubMenuAllocationCommand extends SimpleCommand {
		override public function execute(note:INotification):void{
			
			var subMenuItem:String = note.getBody() as String;
			trace("SubMenuAllocationCommand sez: Trying to fire off " + subMenuItem);
			switch(subMenuItem){
				case HomeHandlers.ALLOC_SUB_MENU_DELETE:
					this.deleteAllocation();
					break;
				case HomeHandlers.ALLOC_SUB_MENU_EDIT:
					this.editAllocation();
					break;
				case HomeHandlers.ALLOC_SUB_MENU_EXIT:
					//Need to return to the food view. 
					sendNotification(ApplicationFacade.CHANGE_STATE, FoodGameState.NAME);
					break;
				case HomeHandlers.ALLOC_SUB_MENU_OVERVIEW:
					this.displayOverview();
					break;
				case HomeHandlers.ALLOC_SUB_MENU_NEW:
					this.createAllocation();
					break;
				default:
					trace("SubMenuAllocationCommand sez: I didn't recognise the name of that.");
			}
		}
		private function displayOverview():void {
			var allocationCreationMediator:AllocationCreationMediator = facade.retrieveMediator(AllocationCreationMediator.NAME) as AllocationCreationMediator;
			if(allocationCreationMediator != null){
	 			allocationCreationMediator.allowEdit(false);
				allocationCreationMediator.allowDeletion(false);
			}
			var allocationListProxy:AllocationListProxy = facade.retrieveProxy(AllocationListProxy.NAME) as AllocationListProxy;
			allocationListProxy.clearCurrentAllocation();
			var sideTxt:String = "Allocation Management\n";
			sideTxt += "Here you can create, edit and delete allocations.";
			sideTxt += "\nYou can save an allocation even if you do not have the required food stocks. However you must ensure that you have sufficient food to fulfil the allocation you select for your household.";

			sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, sideTxt);
		}
		private function createAllocation():void {
			var allocationCreationMediator:AllocationCreationMediator = facade.retrieveMediator(AllocationCreationMediator.NAME) as AllocationCreationMediator;
			allocationCreationMediator.allowEdit(true);
			allocationCreationMediator.allowDeletion(false);
			var allocationListProxy:AllocationListProxy = facade.retrieveProxy(AllocationListProxy.NAME) as AllocationListProxy;
			allocationListProxy.createNewAllocation();
			var sideTxt:String ="New Allocation\n";
			sideTxt += "Choose a name for your allocation, and add food or previously created diets for each person. ";
			sideTxt += "You can see the overview or the detail for each plate by toggling the radio button. \n";
			sideTxt += "\nClick save when you're done editing, or cancel to return to the overview.";
			sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, sideTxt);
		}
		private function editAllocation():void {
			var allocationListProxy:AllocationListProxy = facade.retrieveProxy(AllocationListProxy.NAME) as AllocationListProxy;
			var currentAllocation:Allocation = allocationListProxy.getCurrentAllocation();
			if(currentAllocation!=null && currentAllocation.getId()==-1){
				allocationListProxy.clearCurrentAllocation();
			}
			var dietCreationMediator:AllocationCreationMediator = facade.retrieveMediator(AllocationCreationMediator.NAME) as AllocationCreationMediator;
			dietCreationMediator.allowEdit(true);
			dietCreationMediator.allowDeletion(false);
			var sideTxt:String = "Edit Allocation\n";
			sideTxt += "Choose an allocation from the list to edit. Then tweak the allocation.\n";
			sideTxt += "\nClick save when you're done editing, or cancel to leave the allocation unchanged.";
			sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, sideTxt); 
		}
		private function deleteAllocation():void {
			var allocationListProxy:AllocationListProxy = facade.retrieveProxy(AllocationListProxy.NAME) as AllocationListProxy;
			var currentAllocation:Allocation = allocationListProxy.getCurrentAllocation();
			if(currentAllocation!= null && currentAllocation.getId()==-1){
				allocationListProxy.clearCurrentAllocation();
			}
			var allocationCreationMediator:AllocationCreationMediator = facade.retrieveMediator(AllocationCreationMediator.NAME) as AllocationCreationMediator;
			allocationCreationMediator.allowEdit(false);
			allocationCreationMediator.allowDeletion(true);
			var sideTxt:String = "Delete Allocation\n";
			sideTxt+= "Choose an allocation from the list, then click confirm to delete the allocation.\n";
			sideTxt+= "Be aware though, this cannot be undone.";
			sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, sideTxt);
		}
	}
}
