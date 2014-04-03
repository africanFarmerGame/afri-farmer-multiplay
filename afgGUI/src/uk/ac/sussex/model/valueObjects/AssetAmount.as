/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class AssetAmount {
		private var id: int;
		private var amount:Number;
		private var asset:GameAsset;
		public function getId():int {
			return id;
		}
		public function setId(newId:int):void {
			this.id = newId;
		}
		public function getAsset():GameAsset {
			return this.asset; 
		}
		public function setAsset(newAsset:GameAsset):void {
			this.asset = newAsset;
		}
		public function getAmount():Number {
			return this.amount;
		}
		public function setAmount(newAmount:Number):void {
			this.amount = newAmount;
		}
	}
}
