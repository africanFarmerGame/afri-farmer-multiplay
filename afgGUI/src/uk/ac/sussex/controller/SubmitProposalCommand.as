/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.view.SubMenuMediator;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.serverhandlers.VillageHandlers;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.PlayerCharProxy;
	import uk.ac.sussex.model.valueObjects.Form;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SubmitProposalCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("SubmitProposalCommand sez: we should be submitting any time now. " );
			var proposalform:Form = note.getBody() as Form;
			
			var targetHearth:int = int(proposalform.getFieldValue(VillageHandlers.PROPOSAL_FORM_JOIN_HEARTH));
			var target:int = int(proposalform.getFieldValue(VillageHandlers.PROPOSAL_FORM_TARGET));
			if(targetHearth==0){
				sendNotification(ApplicationFacade.DISPLAY_ERROR_MESSAGE, "You need to select a household to move to.");
			} else if (target==0) {
				sendNotification(ApplicationFacade.DISPLAY_ERROR_MESSAGE, "You need to select a person to propose moves.");
			} else {
				var myChar:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
				var submitProxy:RequestProxy = facade.retrieveProxy(VillageHandlers.SUBMIT_PROPOSAL + RequestProxy.NAME) as RequestProxy;
				submitProxy.setParamValue(VillageHandlers.PROPOSAL_FORM_PROPOSER, myChar.getPlayerId());
				submitProxy.setParamValue(VillageHandlers.PROPOSAL_FORM_PROPOSER_HEARTH, myChar.getPCHearthId());
				submitProxy.setParamValue(VillageHandlers.PROPOSAL_FORM_TARGET, target);
				submitProxy.setParamValue(VillageHandlers.PROPOSAL_FORM_JOIN_HEARTH, targetHearth);
				submitProxy.sendRequest();
				
				var submenu:SubMenuMediator = facade.retrieveMediator(SubMenuMediator.NAME) as SubMenuMediator;
				submenu.setCurrentSelection(VillageHandlers.PROP_SUB_MENU_INCOMING);
			}
			
		}
	}
}
