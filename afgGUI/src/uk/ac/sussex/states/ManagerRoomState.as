/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.states {
	import org.puremvc.as3.multicore.interfaces.IFacade;
	
	/**
	 * @author em97
	 */
	public class ManagerRoomState extends InGameState implements IGameState {
		
		public function ManagerRoomState(facade:IFacade, name:String){
			super(facade, name);
		}
		override public function displayState() : void {
			super.displayState();

			//Register Proxies
				
			//Register Mediators
						
			//Register Commands
		}

		override public function cleanUpState() : void {
			super.cleanUpState();
			//remove proxies
			//remove mediators
			//remove commands

		}

	}
}
