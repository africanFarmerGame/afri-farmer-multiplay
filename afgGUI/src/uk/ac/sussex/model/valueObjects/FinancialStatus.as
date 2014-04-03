/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class FinancialStatus {
		private var hearthId:int;
		private var hearthName:String;
		private var assetWorth:Number;
		private var cashWorth:Number;
		private var unpaidBills:int;
		
		public function getHearthId():int{
			return hearthId;
		}
		public function setHearthId(newId:int):void{
			this.hearthId = newId;
		}
		public function getHearthName():String{
			return hearthName;
		}
		public function setHearthName(newName:String):void {
			this.hearthName = newName;
		}
		public function getCashValue():Number{
			return cashWorth;
		}
		public function setCashValue(newValue:Number):void {
			this.cashWorth = newValue;
		}
		public function getAssetValue():Number {
			return this.assetWorth;
		}
		public function setAssetWorth(newValue:Number):void {
			this.assetWorth = newValue;
		}
		public function getUnpaidBills():int{
			return unpaidBills;
		}
		public function setUnpaidBills(unpaid:int):void{
			this.unpaidBills = unpaid;
		}
	}
}
