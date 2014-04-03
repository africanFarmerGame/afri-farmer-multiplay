/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.GameAssetListProxy;
	import uk.ac.sussex.model.DietaryRequirementsProxy;
	import uk.ac.sussex.model.HearthMembersListProxy;
	import uk.ac.sussex.model.valueObjects.GameAssetFood;
	import uk.ac.sussex.model.valueObjects.DietItem;
	import uk.ac.sussex.model.valueObjects.Diet;
	import uk.ac.sussex.model.valueObjects.AnyChar;
	import uk.ac.sussex.model.AllocationListProxy;
	import uk.ac.sussex.model.valueObjects.Allocation;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class AllocationUpdateReceivedCommand extends SimpleCommand {
		override public function execute(note:INotification) : void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			if(incomingData==null){
				throw new Error("The incoming data was null and this is not right. Check for notification name clash. " + note.getName());
			}
			var allocations:Array = incomingData.getParamValue("Allocations") as Array;
			var allocationLP:AllocationListProxy = facade.retrieveProxy(AllocationListProxy.NAME) as AllocationListProxy;
			var galp:GameAssetListProxy = facade.retrieveProxy(GameAssetListProxy.NAME) as GameAssetListProxy;
			var drlp:DietaryRequirementsProxy = facade.retrieveProxy(DietaryRequirementsProxy.NAME) as DietaryRequirementsProxy;
			var hmlp:HearthMembersListProxy = facade.retrieveProxy(HearthMembersListProxy.NAME) as HearthMembersListProxy;
			if(galp != null && drlp!= null){
				for each (var allocation:Allocation in allocations){
					var diets:Array = allocation.getAllocationDiets();
					for each (var diet:Diet in diets){
						var member:AnyChar = hmlp.getMember(diet.getId());
						diet.setTarget(member.getDietTarget());
						diet.setDietaryRequirements(drlp.getTargetRequirements(diet.getTarget()));
						diet.setName(member.getFirstName() + " " + member.getFamilyName());
						var diarray:Array = diet.getDietItems();
						
						for each (var di:DietItem in diarray){
							var foodAsset:GameAssetFood = galp.getFoodAsset(di.getAssetId());
							di.setAsset(foodAsset);
						}
						diet.updateNutrientLevels();
					}
					allocationLP.saveAllocation(allocation);
				}
			}
		}
	}
}
