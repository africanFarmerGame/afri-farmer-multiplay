/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.gameEvents;

import uk.ac.sussex.model.SeasonNotificationFactory;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.utilities.Logger;

public class CoreIncrementGameYearEvent extends GameEvent {

	public CoreIncrementGameYearEvent(Game game){
		super(game);
	}
	@Override
	public void fireEvent() throws Exception {
		Logger.ErrorLog("CoreIncrementGameYearEvent.fireEvent", "I am fired");
		Integer currentGameYear = game.getGameYear();
		game.setGameYear(currentGameYear + 1);
		game.save();
	}
	@Override
	public void generateNotifications() throws Exception {
		Integer gameYear = game.getGameYear();
		SeasonNotificationFactory snf = new SeasonNotificationFactory();
		snf.updateSeasonNotifications("You are now entering Year " + gameYear, game);
	}

}
