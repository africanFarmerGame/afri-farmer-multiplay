/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.games {
	import uk.ac.sussex.states.*;
	import uk.ac.sussex.view.ApplicationMediator;
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import uk.ac.sussex.model.games.BaseGame;

	/**
	 * @author em97
	 */
	public class CoreBaseGame extends BaseGame {
		public static const TYPE:String = "CORE-GAME";
		public function CoreBaseGame() {
			super();
			this.setGameType(TYPE);
		}
		override public function registerGameStates(facade:IFacade, appMediator:ApplicationMediator, banker:Boolean):void {
			appMediator.registerState(new JoinGameGameState(facade));
			appMediator.registerState(new VillageGameState(facade));
			appMediator.registerState(new BankGameState(facade));
			appMediator.registerState(new FinesGameState(facade));
			appMediator.registerState(new HomeGameState(facade));
			appMediator.registerState(new MarketGameState(facade));
			appMediator.registerState(new FarmGameState(facade));
			appMediator.registerState(new GameSettingsGameState(facade));
			appMediator.registerState(new FoodGameState(facade));
			appMediator.registerState(new DietGameState(facade));
			appMediator.registerState(new TaskGameState(facade));
			appMediator.registerState(new AllocationGameState(facade));
			//Register the game manager states only if this is a game manager.
			if(banker){
				appMediator.registerState(new BankManagerGameState(facade));
				appMediator.registerState(new MarketManagerGameState(facade));
				appMediator.registerState(new VillageManagerGameState(facade));
				appMediator.registerState(new HomeManagerGameState(facade));
				appMediator.registerState(new FarmManagerGameState(facade));
				appMediator.registerState(new FinesManagerGameState(facade));
			}
		}
	}
}
