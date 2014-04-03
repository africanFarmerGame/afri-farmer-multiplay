/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class GMHouseholdData {
		private var hearthId:int;
		private var pendingTaskCount:int;
		private var aDiets:int;
		private var bDiets:int;
		private var cDiets:int;
		private var xDiets:int;
		private var enoughFood:Boolean;
		
		public function GMHouseholdData(){
			
		}
		public function getHearthId():int{
			return hearthId;
		}
		public function setHearthId(newId:int):void {
			this.hearthId = newId;
		}
		public function getPendingTaskCount():int{
			return pendingTaskCount;
		}
		public function setPendingTaskCount(pendingCount:int):void {
			this.pendingTaskCount = pendingCount;
		}
		public function getADiets():int{
			return aDiets;
		}
		public function setADiets(numDiets:int):void {
			this.aDiets = numDiets;
		}
		public function getBDiets():int{
			return bDiets;
		}
		public function setBDiets(numDiets:int):void {
			this.bDiets = numDiets;
		}
		public function getCDiets():int{
			return cDiets;
		}
		public function setCDiets(numDiets:int):void {
			this.cDiets = numDiets;
		}
		public function getXDiets():int{
			return xDiets;
		}
		public function setXDiets(numDiets:int):void {
			this.xDiets = numDiets;
		}
		public function getEnoughFood():Boolean {
			return enoughFood;
		}
		public function setEnoughFood(enough:Boolean):void {
			this.enoughFood = enough;
		}
		public function toString():String{
			return "GMHouseholdData: hearthId " + hearthId + " tasks " + pendingTaskCount + " aDiets " + aDiets + " bDiets " + bDiets + " cDiets " + cDiets + " xDiets " + xDiets + " enough " + enoughFood.toString(); 
		}
	}
}
