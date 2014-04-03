/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects {
	import uk.ac.sussex.model.valueObjects.requestParams.*;
	
	/**
	 * @author em97
	 */
	public class UserData {
		private var userName:String;
		private var myParams:Array;
		
		public function UserData(userName:String) {
			this.userName = userName;
			this.myParams = new Array();
			this.addUserParam(new DataParamPlayerChar("pc"));
		}
		
		public function getParamValue(paramName:String){
			var param:DataParam = this.myParams[paramName] as DataParam;
			
			if(param != null){
				return param.getParamValue();
			}
		}
		/** 
		 * Unlike the other data commands, the structure of a user shouldn't change on the fly.
		 * So I'm making this function private to the class, and we'll set up the fields in the constructor. 
		 */
		private function addUserParam(userParam:DataParam):void {
			var paramName:String = userParam.getParamName();
			if(myParams[paramName]==null){
				myParams[paramName] = userParam;
			}
		}
	}
}
