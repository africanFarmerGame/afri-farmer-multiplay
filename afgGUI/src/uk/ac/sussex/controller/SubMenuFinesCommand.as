/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.Form;
	import uk.ac.sussex.model.FormProxy;
	import uk.ac.sussex.model.valueObjects.Fine;
	import uk.ac.sussex.model.FinesProxy;
	import uk.ac.sussex.view.FinesListMediator;
	import uk.ac.sussex.view.FormMediator;
	import uk.ac.sussex.states.BankGameState;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.serverhandlers.BankHandlers;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SubMenuFinesCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("SubMenuFinesCommand sez: I've been triggered");
			var finesListMediator:FinesListMediator = facade.retrieveMediator(FinesListMediator.NAME) as FinesListMediator;
			if(finesListMediator == null){
				throw new Error("Fines List Mediator is null");
			}
			
			var subMenuItem:String = note.getBody() as String;
			
			switch(subMenuItem){
				case BankHandlers.FINES_SUB_MENU_LIST:
					showFinesList(finesListMediator, true);
					showPayForm(false);
					var displayText:String = "Bills\n\nIf you have accrued any bills it's best to pay them quickly before the cost goes up!";
					sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, displayText);
					break;
				case BankHandlers.FINES_SUB_MENU_PAY:
					checkSelected(finesListMediator);
					//sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, "Pay");
					break;
				case BankHandlers.FINES_SUB_MENU_EXIT:
					sendNotification(ApplicationFacade.CHANGE_STATE, BankGameState.NAME);
					break;
			}
		}
		private function showFinesList(finesListMediator:FinesListMediator, showList:Boolean):void {
			
			finesListMediator.showList(showList);
			
		}
		private function showPayForm(showForm:Boolean):void {
			var formMediator:FormMediator = facade.retrieveMediator(BankHandlers.FINES_PAY_FORM) as FormMediator;
			if(formMediator!=null){
		    	if(showForm){
		    		formMediator.addToViewArea();
		    	} else {
		    		formMediator.hideForm();
				}
			} else {
	      		throw new Error("Pay form mediator is null");
	    	}
		}
		private function checkSelected(finesListMediator:FinesListMediator):void {
			var selectedId:String = finesListMediator.getSelectedBillId();
			var sideTxt:String = "Penalties\n\n";
			if(selectedId==null){
				//We need to wait for a selection.
				trace("SubMenuFinesCommand sez: We haz no fine selected.");
				sideTxt += "Select a bill from the list to pay, then click save to confirm.\n";
				sideTxt += "\nClicking cancel will return to the overview.";
				sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, sideTxt);
				finesListMediator.listenForSelection(true); 
			} else {
				showFinesList(finesListMediator, false);
				showPayForm(true);
				//We need to display the fine value.
				var finesProxy:FinesProxy = facade.retrieveProxy(FinesProxy.NAME) as FinesProxy;
				if(finesProxy==null){
					throw new Error("Problem fetching the fines proxy");
				}
				var selectedFine:Fine = finesProxy.getFine(int(selectedId));
				if(selectedFine == null){
					throw new Error("Problem fetching the bill");
				}
				var finesFormProxy:FormProxy = facade.retrieveProxy(BankHandlers.FINES_PAY_FORM) as FormProxy;
				var finesForm:Form = finesFormProxy.getForm();
				finesForm.setFieldValue(BankHandlers.FINES_ID, selectedFine.getId().toString());
				finesForm.setFieldValue(BankHandlers.FINES_DESCRIPTION, selectedFine.getDescription());
				finesForm.setFieldValue(BankHandlers.FINES_RATE, selectedFine.getEarlyRate().toString());
			}
		}
	}
}
