/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model {
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import uk.ac.sussex.model.valueObjects.UserData;
	import uk.ac.sussex.model.valueObjects.PlayerChar;
	
	/**
	 * @author em97
	 */
	public class UserProxy extends Proxy implements IProxy {
		public static const NAME:String = "UserProxy";
		public function UserProxy(userName : String) {
			super(userName + NAME, new UserData(userName));
		}
		public function getPlayerChar():PlayerChar{
			return userData.getParamValue("pc") as PlayerChar;
		}
		protected function get userData():UserData {
	 		return data as UserData;
	  	}
	}
}
