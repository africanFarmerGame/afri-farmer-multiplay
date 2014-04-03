/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.games {
	import uk.ac.sussex.view.ApplicationMediator;
	import org.puremvc.as3.multicore.interfaces.IFacade;
	/**
	 * @author em97
	 */
	public class BaseGame {
		private var gameType:String;
		
		public function BaseGame() {		
			
		}
		protected function setGameType(gameType:String):void {
			this.gameType = gameType;
		}
		public function getGameType():String {
			return this.gameType;
		}
		public function registerGameStates(facade:IFacade, appMediator:ApplicationMediator, banker:Boolean):void {
		
		}
		
	}
}
