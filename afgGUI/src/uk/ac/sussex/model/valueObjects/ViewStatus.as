/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class ViewStatus {
		private var viewName:String;
		private var status:int;
		public function getViewName():String{
			return viewName;
		}
		public function setViewName(newName:String):void {
			this.viewName = newName;
		}
		public function getStatus():int {
			return status;
		}
		public function setStatus(newStatus:int):void {
			this.status = newStatus;
		}
	}
}
