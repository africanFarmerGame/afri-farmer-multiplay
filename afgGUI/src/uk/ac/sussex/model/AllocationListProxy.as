/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model {
	import flash.events.Event;
	import uk.ac.sussex.model.valueObjects.DietItem;
	import uk.ac.sussex.model.valueObjects.GameAssetFood;
	import uk.ac.sussex.model.valueObjects.Diet;
	import uk.ac.sussex.model.valueObjects.AnyChar;
	import uk.ac.sussex.model.valueObjects.Allocation;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.interfaces.IProxy;

	/**
	 * @author em97
	 */
	public class AllocationListProxy extends Proxy implements IProxy {
		public static const NAME:String = "AllocationListProxy";
		public static const CURRENT_ALLOCATION_CHANGED:String = "CurrentAllocationChanged";
		public static const NEW_ALLOCATIONS_ADDED:String = "NewAllocationsAdded";
		public static const NEW_ALLOCATION_ADDED:String = "NewAllocationAdded";
		public static const ALLOCATION_UPDATED:String = "AllocationLP.AllocationUpdated";
		public static const ALLOCATION_DELETED:String = "AllocationDeleted";
		public static const SELECTED_ALLOCATION_CHANGED:String = "SelectedAllocationChanged";
		
		public static const CURRENT_ALLOCATION_CONTENTS_CHANGED:String = "CurrentAllocationContentsChanged";
		
		private var currentAllocation:Allocation;
		private var hearthMembersProxy:HearthMembersListProxy;
		private var gameAssetsLP:GameAssetListProxy;
		
		public function AllocationListProxy(hearthMembersProxy:HearthMembersListProxy, gameAssetsLP:GameAssetListProxy) {
			super(NAME, new Array());
			this.hearthMembersProxy = hearthMembersProxy;
			this.gameAssetsLP = gameAssetsLP;
		}
		public function getCurrentAllocation():Allocation {
			return currentAllocation;
		}
		public function addAllocations(newAllocations:Array):void {
			for each (var allocation:Allocation in newAllocations){
				allocationList.push (allocation);
			}
			sendNotification(NEW_ALLOCATIONS_ADDED, newAllocations);
		}
		
		public function getAllocations():Array {
			return allocationList;
		}
		
		public function saveAllocation(newAllocation:Allocation):void {
			//Search for the diet in the list.
			trace("AllocationListProxy sez: We have a non-null allocation to save " + (newAllocation!=null));
			trace("AllocationListProxy sez: We are saving an allocation with id " + newAllocation.getId());
			var allocation:Allocation = null;
			var newAllocId:int = newAllocation.getId();
			trace("AllocationListProxy sez: The allocationlist is not null " + (allocationList!=null));
			for each (var listAlloc:Allocation in allocationList){
				trace("AllocationListProxy sez: The listAlloc is not null " + (listAlloc!=null));
				trace("AllocationListProxy sez: The listAlloc has an id of " + listAlloc.getId());
				if(listAlloc.getId() == newAllocId){
					allocation = listAlloc;
					break;
				}
			}
			if (allocation == null){
				//This is a new allocation and should just be added.
				trace("AllocationListProxy sez: We think this is a brand spanking new allocation.");
				allocationList.push(newAllocation);
				sendNotification(NEW_ALLOCATION_ADDED, newAllocation);
			} else {
				trace("AllocationListProxy sez: We think we already have this allocation listed.");
				allocation.setName(newAllocation.getName());
				trace("AllocationListProxy sez: We have set the allocation name to " + newAllocation.getName());
				allocation.setSelected(newAllocation.getSelected());
				trace("AllocationListProxy sez: We have set the allocation selected to " + newAllocation.getSelected());
				var allocationDiets:Array = allocation.getAllocationDiets();
				trace("AllocationListProxy sez: The diets for this allocation are not null " + (allocationDiets!=null));
				if(allocationDiets == null){
					trace("AllocationListProxy sez: ok, the allocation had no diets. Let's try this.");
					allocationDiets = newAllocation.getAllocationDiets();
					allocation.setAllocationDiets(allocationDiets);
				} else {
					//TODO Check for diets in the new allocation that aren't in the original, and vice versa...
					var newDiets:Array = newAllocation.getAllocationDiets();
					if(newDiets.length>allocationDiets.length){
						for each (var aNewDiet:Diet in newDiets){
							var currentDiet:Diet = allocation.getAllocationDiet(aNewDiet.getId());
							if(currentDiet!=null){
								currentDiet.setDietItems(aNewDiet.getDietItems());
							} else {
								//Need to add this diet to the allocation.
								allocation.addDiet(aNewDiet);
							}
						}
					} else {
						for each (var aDiet:Diet in allocationDiets){
							var newDiet:Diet = newAllocation.getAllocationDiet(aDiet.getId());
							trace("AllocationListProxy sez: We are updating diet " + aDiet.getId());
							trace("AllocationListProxy sez: And the newDiet we're looking for is ok " + (newDiet!=null));
							if(newDiet!=null){
								aDiet.setDietItems(newDiet.getDietItems());
							} 
						}
					}
				}
				sendNotification(ALLOCATION_UPDATED, allocation);
			}
		}
		
		public function createNewAllocation():void {
			var allocation:Allocation = new Allocation();
			allocation.setId(-1);
			allocation.setName("New Allocation " + (allocationList.length + 1).toString());
			allocation.setSelected(false);
			
			var dietItems:Array = new Array();
			var foodItems:Array = gameAssetsLP.getFoodAssets();
			for each (var foodItem:GameAssetFood in foodItems){
				var di:DietItem = new DietItem;
				di.setAmount(0);
				di.setAsset(foodItem);
				dietItems.push(di);
			}
			
			var members:Array = hearthMembersProxy.getMembers();
			var membersDiets:Array = new Array();
			for each (var member:AnyChar in members){
				var diet:Diet = new Diet();
				diet.setId(member.getId());
				var dietaryReqs:Array = member.getDietaryReqs();
				trace("AllocationListProxy sez: The member " + member.getFirstName() + " has null dietary reqs " + (dietaryReqs == null));
				diet.setDietaryRequirements(dietaryReqs);
				diet.setDietItems(dietItems);
				diet.setTarget(member.getDietTarget());
				diet.setName(member.getFirstName() + " " + member.getFamilyName());
				membersDiets.push(diet);
			}
			allocation.setAllocationDiets(membersDiets);
			setCurrentAllocation(allocation);
		}
		public function clearCurrentAllocation():void {
			setCurrentAllocation(null);
		}
		public function changeCurrentAllocation(allocationId:int):void{
			for each (var allocation:Allocation in allocationList){
				if(allocation.getId()==allocationId){
					this.setCurrentAllocation(allocation.getCopy());
					break;
				}
			}
		}
		public function deleteAllocation (allocationId:int):void {
			var newAllocationArray:Array = new Array();
			for each (var allocation:Allocation in allocationList) {
				if(allocation.getId() != allocationId){
					newAllocationArray.push(allocation);
				}
			}
			data = newAllocationArray;
			sendNotification(ALLOCATION_DELETED, allocationId);
		}
		public function setSelectedAllocation(allocationId:int):void {
			for each (var allocation:Allocation in allocationList){
				allocation.setSelected((allocation.getId()==allocationId));
			}
			sendNotification(SELECTED_ALLOCATION_CHANGED);
		}
		private function setCurrentAllocation(newAllocation:Allocation):void{
			if(currentAllocation != null){
				//Clear up whatever we're listening for on this one. 
				var currentdiets:Array = currentAllocation.getAllocationDiets();
				for each (var currentdiet:Diet in currentdiets){
					currentdiet.removeEventListener(Diet.DIET_CONTENTS_CHANGED, allocationDietChanged);
				}
			}
			currentAllocation = newAllocation;
			if(currentAllocation != null) {
				//Set up whatever we need for the next one. 
				var diets:Array = currentAllocation.getAllocationDiets();
				for each (var diet:Diet in diets){
					diet.addEventListener(Diet.DIET_CONTENTS_CHANGED, allocationDietChanged);
				}
			}
			sendNotification(CURRENT_ALLOCATION_CHANGED);
		}
		protected function get allocationList():Array {
			return data as Array;
		}
		private function allocationDietChanged(e:Event):void {
			sendNotification(CURRENT_ALLOCATION_CONTENTS_CHANGED);
		}
	}
}
