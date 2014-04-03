/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.states {
	import org.puremvc.as3.multicore.interfaces.IFacade;

	/**
	 * @author em97
	 */
	public class FarmManagerGameState extends ManagerRoomState implements IGameState {
		public static const NAME:String = "FarmManagerGameState";
		public static const LOCATION_NAME:String = "FARM";
		
		public function FarmManagerGameState(facade : IFacade) {
			super(facade, NAME);
		}
		override public function displayState():void{
			trace("You've reached the Farm Manager Game State");
			super.displayState();
			//add proxies
			//add mediators
			//add commands
		}
		override public function cleanUpState():void{
			//remove proxies
			//remove mediators
			//remove commands
			super.cleanUpState();
		}
	}
}
