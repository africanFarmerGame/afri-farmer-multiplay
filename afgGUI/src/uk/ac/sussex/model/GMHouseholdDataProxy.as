/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model {
	import uk.ac.sussex.model.valueObjects.GMHouseholdData;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.interfaces.IProxy;

	/**
	 * @author em97
	 */
	public class GMHouseholdDataProxy extends Proxy implements IProxy {
		public static const NAME:String = "GMHouseholdDataProxy";
		public static const HOUSEHOLD_DATA_UPDATED:String = "GMHouseholdDataUpdated";
		public function GMHouseholdDataProxy() {
			super(NAME, null);
		}
		public function addHouseholdTaskData(newData:Array):void{
			for each(var dataObj:GMHouseholdData in newData){
				if(checkExists(dataObj.getHearthId())){
					updateTaskDetails(dataObj);
				} else {
					
					householdData.push(dataObj);
				}
			}
			sendNotification(HOUSEHOLD_DATA_UPDATED);
		}
		public function addHouseholdFoodData(newData:Array):void {
			for each(var dataObj:GMHouseholdData in newData){
				if(checkExists(dataObj.getHearthId())){
					updateFoodDetails(dataObj);
				} else {
					householdData.push(dataObj);
				}
			}
			sendNotification(HOUSEHOLD_DATA_UPDATED);
		}
		public function updateHouseholdTaskData(hearthId:int, pendingTaskCount:int):void{
			trace("GMHouseholdDataProxy sez: I have " + householdData.length + " households stored");
			for each (var household:GMHouseholdData in householdData){
				trace("GMHouseholdDataProxy sez: looking at household " + household.getHearthId());
				if(household.getHearthId()==hearthId){
					trace("GMHouseholdDataProxy sez: I am updating the count.");
					household.setPendingTaskCount(pendingTaskCount);
					sendNotification(HOUSEHOLD_DATA_UPDATED);
					return;
				}
			}
		}
		public function fetchHouseholdTaskCount(hearthId:int):int{
			for each (var taskCount:GMHouseholdData in householdData){
				if(taskCount.getHearthId()==hearthId){
					return taskCount.getPendingTaskCount();
				}
			}
			return 0;
		}
		public function fetchHouseholdData(hearthId:int):GMHouseholdData {
			for each (var household:GMHouseholdData in householdData){
				if(household.getHearthId()==hearthId){
					return household;
				}
			}
			return null;
		}
		private function updateFoodDetails(dataObj:GMHouseholdData):void {
			var hearthId:int = dataObj.getHearthId();
			for each(var household:GMHouseholdData in householdData){
				if(hearthId==household.getHearthId()){
					household.setADiets(dataObj.getADiets());
					household.setBDiets(dataObj.getBDiets());
					household.setCDiets(dataObj.getCDiets());
					household.setXDiets(dataObj.getXDiets());
					household.setEnoughFood(dataObj.getEnoughFood());
					return;
				}
			}
		}
		private function updateTaskDetails(dataObj:GMHouseholdData):void {
			var hearthId:int = dataObj.getHearthId();
			for each(var household:GMHouseholdData in householdData){
				if(hearthId==household.getHearthId()){
					household.setPendingTaskCount(dataObj.getPendingTaskCount());
					return;
				}
			}
		}
		private function checkExists(hearthId:int):Boolean{
			for each(var household:GMHouseholdData in householdData){
				if(hearthId == household.getHearthId()){
					return true;
				}
			}
			return false;
		}
		protected function get householdData():Array {
			 return data as Array;
		}
		override public function onRegister():void {
			data = new Array();	
		}
	}
}
