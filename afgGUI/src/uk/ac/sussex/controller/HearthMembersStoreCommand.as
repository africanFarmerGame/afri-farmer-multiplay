/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.view.SubMenuMediator;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.valueObjects.AnyChar;
	import uk.ac.sussex.model.DietaryRequirementsProxy;
	import uk.ac.sussex.model.HearthMembersListProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class HearthMembersStoreCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var pcMembersList:Array = incomingData.getParamValue("PCList") as Array;
			var npcMembersList:Array = incomingData.getParamValue("NPCList") as Array;
			var deadList:Array = incomingData.getParamValue("DeadList") as Array;
			
			var dietaryRP:DietaryRequirementsProxy = facade.retrieveProxy(DietaryRequirementsProxy.NAME) as DietaryRequirementsProxy;
			if(dietaryRP!= null){
				var dietaryReqs:Array;
				var member:AnyChar;
				for each (member in pcMembersList){
					dietaryReqs = dietaryRP.getTargetRequirements(member.getDietTarget());
					member.setDietaryReqs(dietaryReqs);
				}
				for each (member in npcMembersList){
					dietaryReqs = dietaryRP.getTargetRequirements(member.getDietTarget());
					member.setDietaryReqs(dietaryReqs);
				}
				
			}
			var hearthMembersLP:HearthMembersListProxy = facade.retrieveProxy(HearthMembersListProxy.NAME) as HearthMembersListProxy;
			hearthMembersLP.addNPCHearthMembers(npcMembersList);
			hearthMembersLP.addPCHearthMembers(pcMembersList);
			hearthMembersLP.addDeadHearthMembers(deadList);
			
			var subMenu:SubMenuMediator = facade.retrieveMediator(SubMenuMediator.NAME) as SubMenuMediator;
			sendNotification(ApplicationFacade.SWITCH_SUBMENU_ITEM, subMenu.getCurrentSelection());
		}
	}
}
