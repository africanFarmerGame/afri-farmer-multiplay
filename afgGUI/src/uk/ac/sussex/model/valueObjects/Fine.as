/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class Fine {
		private var id:int;
		private var payee:int;
		private var description:String;
		private var earlyRate:Number;
		private var lateRate:Number;
		private var season:int;
		private var paid:Boolean;
		public function Fine(){
			
		}
		public function getId():int {
			return this.id;
		}
		public function setId(newId:int):void {
			this.id = newId;
		}
		public function getPayee():int {
			return payee;
		}
		public function setPayee(newPayee:int):void {
			this.payee = newPayee;
		}
		public function getDescription():String {
			return this.description;
		}
		public function setDescription(newDescription:String):void {
			this.description = newDescription;
		}
		public function getEarlyRate():Number {
			return this.earlyRate;
		}
		public function setEarlyRate(newRate:Number):void {
			this.earlyRate = newRate;
		}
		public function getLateRate():Number {
			return this.lateRate;
		}
		public function setLateRate(newRate:Number):void {
			this.lateRate = newRate;
		}
		public function getSeason():int {
			return season;
		}
		public function setSeason(newSeason:int):void{
			this.season = newSeason;
		}
		public function getPaid():Boolean{
			return paid;
		}
		public function setPaid(newPaid:Boolean):void {
			this.paid = newPaid;
		}
	}
}
