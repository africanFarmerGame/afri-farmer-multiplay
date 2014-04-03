/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model {
	import uk.ac.sussex.model.valueObjects.DietaryRequirement;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	/**
	 * @author em97
	 */
	public class DietaryRequirementsProxy extends Proxy implements IProxy {
		public static const NAME:String = "DietaryRequirementsProxy";
		public function DietaryRequirementsProxy() {
			super(NAME, new Array());
		}
		public function addRequirements(reqArray:Array):void {
			//this.data = reqArray;
			for each (var dr:DietaryRequirement in reqArray){
				dietaryRequirements.push(dr);
			}
		}
		public function getDietaryRequirement(type:int, level:String):DietaryRequirement {
			for each (var dr:DietaryRequirement in dietaryRequirements){
				if(dr.getType()==type && dr.getLevel() == level){
					return dr;
				}
			}
		}
		public function getTargetRequirements(type:int):Array {
			var reqs:Array = new Array();
			for each (var dr:DietaryRequirement in dietaryRequirements){
				if(dr.getType()==type){
					reqs[dr.getLevel()] = dr;
				}
			}
			return reqs;
		}
		protected function get dietaryRequirements():Array{
			return data as Array;
		}
	}
}
