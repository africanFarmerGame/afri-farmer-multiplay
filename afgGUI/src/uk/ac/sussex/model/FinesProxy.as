/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model {
	import uk.ac.sussex.model.valueObjects.Fine;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	/**
	 * @author em97
	 */
	public class FinesProxy extends Proxy {
		public static const NAME:String = "FinesProxy";
		public static const FINES_ADDED:String = "FinesAdded";
		
		public function FinesProxy() {
			super(NAME, new Array());
		}
		public function addFines(newFines:Array):void {
			for each (var fine:Fine in newFines){
				addFine(fine);
			}
			sendNotification(FINES_ADDED);
		}
		public function getFines():Array {
			return finesList;
		}
		public function getFine(fineId:int):Fine {
			for each (var fine:Fine in finesList){
				if(fine.getId()==fineId){
					return fine;
				}
			}
			return null;
		}
		public function getFinesByPayee(payeeId:int):Array{
			var payeeFines:Array = new Array();
			for each (var fine:Fine in finesList) {
				trace("FinesProxy sez: this fine has payee " + fine.getPayee());
				if(fine.getPayee()==payeeId){
					payeeFines.push(fine);
				}
			}
			return payeeFines.sort(orderbyId);
		}
		private function addFine(fine:Fine):void {
			var newFieldId:int = fine.getId();
			var preexisting:Boolean = false;
			for each (var existingFine:Fine in finesList){
				if(existingFine.getId()==newFieldId){
					existingFine.setDescription(fine.getDescription());
					existingFine.setEarlyRate(fine.getEarlyRate());
					existingFine.setLateRate(fine.getLateRate());
					existingFine.setPaid(fine.getPaid());
					existingFine.setPayee(fine.getPayee());
					preexisting = true;
					break;
				}
			}
			if(!preexisting){
				finesList.push(fine);
			}
		}
		private function orderbyId(a:Fine, b:Fine):int {
			var aId:int = a.getId();
			var bId:int = b.getId();
			if(aId<bId){
				return 1;
			} else if (aId>bId) {
				return -1;
			} else {
				return 0;
			}
		}
		protected function get finesList():Array{
			return data as Array;
		}
	}
}
