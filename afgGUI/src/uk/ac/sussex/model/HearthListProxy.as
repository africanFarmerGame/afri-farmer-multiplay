/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model {
	import uk.ac.sussex.model.valueObjects.Hearth;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	/**
	 * @author em97
	 */
	public class HearthListProxy extends Proxy implements IProxy {
		public static const NAME:String = "HearthListProxy";
		public static const HEARTH_ADDED:String = "HearthAdded";
		public function HearthListProxy() {
			super(NAME, new Array());
		}
		public function addHearth(newHearth:Hearth):void {
			var newHearthId:int = newHearth.getId();
			var found:Boolean = false;
			for each (var hearth:Hearth in hearthlist){
				if(hearth.getId()==newHearthId){
					found = true;
					hearth.setHearthName(newHearth.getHearthName());
					hearth.setNumAdults(newHearth.getNumAdults());
					hearth.setNumChildren(newHearth.getNumChildren());
					hearth.setNumFields(newHearth.getNumFields());
				}
			}
			if(!found){
				hearthlist.push(newHearth);
			}
			sendNotification(HEARTH_ADDED, newHearth);
		}
		public function getHearthIds():Array{
			var idList:Array = new Array();
			for each (var hearth:Hearth in hearthlist){
				idList.push(hearth.getId());
			}
			return idList;
		}
		public function getHearthById(hearthId:int):Hearth{
			for each (var hearth:Hearth in hearthlist){
				if(hearth.getId() == hearthId){
					return hearth;
				}
			}
			return null;
		}
		public function getHearthCount():int {
			return this.hearthlist.length;
		}
		public function getHearths():Array {
			return hearthlist.sort(sortOnHearthNumber);
		}
		protected function get hearthlist():Array{
			return data as Array;
		}
		private function sortOnHearthNumber(a:Hearth, b:Hearth):int {
			var aNumber:int = a.getHouseNumber();
			var bNumber:int = b.getHouseNumber();
			if(aNumber>bNumber){
				return 1;
			} else if (aNumber<bNumber){
				return -1;
			} else {
				return 0;
			}
		}
	}
}
