/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects {
  
  public class VillageOverview {
    private var name:String;
    private var numAdults:int;
    private var numKids:int;
    private var households:int;
    public function VillageOverview(){
      
    }
    public function getName():String {
      return name;
    }
    public function setName(newName:String):void {
      this.name = newName;
    }
    public function getNumAdults():int {
      return numAdults;
    }
    public function setNumAdults(numberOfAdults:int):void {
      this.numAdults = numberOfAdults;
    }
    public function getNumKids():int {
      return numKids;
    }
    public function setNumKids(numberOfKids:int):void {
      this.numKids = numberOfKids;
    }
    public function getHouseholds():int {
      return households;
    }
    public function setHouseholds(numberOfHouseholds:int):void {
      this.households = numberOfHouseholds;
    }
  }
}