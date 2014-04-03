/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.gameEvents;

import java.util.Set;

import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.SeasonNotificationFactory;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.grading.ICriterion;
import uk.ac.sussex.utilities.Logger;

public class CoreCalculateAnnualGradingCriteriaEvent extends GameEvent {

	public CoreCalculateAnnualGradingCriteriaEvent(Game game) {
		super(game);
	}

	@Override
	public void fireEvent() throws Exception {
		Logger.ErrorLog("CoreCalculateAnnualGradingCriteriaEvent.fireEvent", "Firing.");
		ICriterion criteria = game.fetchGameCriteria();
		if(criteria==null){
			throw new Exception("Game criteria is null");
		}
		Integer gameYear = game.getGameYear();
		PlayerCharFactory pcf = new PlayerCharFactory();
		Set<PlayerChar> players;
		try {
			players = pcf.fetchGamePCs(game);
		} catch (Exception e) {
			throw new Exception ("Unable to fetch pcs for game" + e.getMessage());
		}
		Logger.ErrorLog("CoreCalculateAnnualGradingCriteriaEvent.fireEvent", "About to calculate criteria");
		for(PlayerChar pc: players){
			criteria.calculateValue(pc, gameYear);
		}
		Logger.ErrorLog("CoreCalculateAnnualGradingCriteriaEvent.fireEvent", "Reached end of calculate grading.");
	}

	@Override
	public void generateNotifications() throws Exception {
		SeasonNotificationFactory snf = new SeasonNotificationFactory();
		
		ICriterion criteria = game.fetchGameCriteria();
		Integer gameYear = game.getGameYear() - 1;	//By this point the game year has been increased!
		PlayerCharFactory pcf = new PlayerCharFactory();
		Set<PlayerChar> players = pcf.fetchGamePCs(game);
		for(PlayerChar pc: players){
			String notification = "Progress Report:\n";
			notification += criteria.displayYearEndOutput(pc, gameYear);
			snf.updateSeasonNotifications(notification, pc);
		}
	}

}
