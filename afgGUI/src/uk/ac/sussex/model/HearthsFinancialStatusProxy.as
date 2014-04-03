/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model {
	import uk.ac.sussex.model.valueObjects.FinancialStatus;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.interfaces.IProxy;

	/**
	 * @author em97
	 */
	public class HearthsFinancialStatusProxy extends Proxy implements IProxy {
		public static const NAME:String = "HearthsFinancialStatusProxy";
		public static const STATUSES_ADDED:String = "HearthsFinancialStatusesAdded";
		public static const STATUS_UPDATED:String = "HearthsFinancialStatusUpdated";
		
		public function HearthsFinancialStatusProxy() {
			super(NAME, new Array());
		}
		public function addHouseholdStatuses(statuses:Array):void {
			for each (var status:FinancialStatus in statuses){
				householdList.push(status);
				trace("HearthsFinancialStatusProxy sez: I has a status added. "  + status.getHearthId());
			}
			sendNotification(STATUSES_ADDED);
		}
		public function getHouseholdStatuses():Array{
			return householdList.sort(orderById);
		}
		public function updateHouseholdBillCount(hearthId:int, billCount:int, cashValue:Number):void {
			for each(var fs:FinancialStatus in householdList){
				if(hearthId == fs.getHearthId()){
					fs.setUnpaidBills(billCount);
					fs.setCashValue(cashValue);
					sendNotification(STATUS_UPDATED, fs);
					return;
				}
			}
		}
		public function updateHouseholdValue(hearthId:int, cashValue:Number, assetValue:Number):void{
			for each(var fs:FinancialStatus in householdList){
				if(hearthId == fs.getHearthId()){
					fs.setCashValue(cashValue);
					fs.setAssetWorth(assetValue);
					sendNotification(STATUS_UPDATED, fs);
					return;
				}
			}
		}
		private function get householdList():Array {
			return data as Array;
		}
		
		private function orderById(a:FinancialStatus, b:FinancialStatus):int {
			var aId:int = a.getHearthId();
			var bId:int = b.getHearthId();
			
			if(aId>bId){
				return 1;
			} else if (aId<bId){
				return -1;
			} else {
				return 0;
			}
		}
	}
}
