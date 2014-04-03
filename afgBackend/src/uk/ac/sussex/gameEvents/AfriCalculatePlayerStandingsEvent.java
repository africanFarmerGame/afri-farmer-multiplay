/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.gameEvents;

import java.util.Set;

import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.SeasonNotificationFactory;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.grading.ICriterion;

public class AfriCalculatePlayerStandingsEvent extends GameEvent {

	public AfriCalculatePlayerStandingsEvent(Game game) {
		super(game);
	}

	@Override
	public void fireEvent() throws Exception {
		//Actually, everything on this one happens in the generateNotifications. 
	}

	@Override
	public void generateNotifications() throws Exception {
SeasonNotificationFactory snf = new SeasonNotificationFactory();
		
		ICriterion criteria = game.fetchGameCriteria();
		PlayerCharFactory pcf = new PlayerCharFactory();
		Set<PlayerChar> players = pcf.fetchGamePCs(game);
		for(PlayerChar pc: players){
			String notification = "Final Reckoning\n";
			notification += criteria.displayFinalReckoning(pc);
			snf.updateSeasonNotifications(notification, pc);
		}
	}

}
