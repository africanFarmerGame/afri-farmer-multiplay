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
import uk.ac.sussex.model.village.Village;

public class CoreCreatePlayersEvent extends GameEvent {
	public CoreCreatePlayersEvent(Game game) {
		super(game);
	}

	//private final Integer DEFAULT_FAMILY_SIZE = 2;
	
	@Override
	public void fireEvent() throws Exception {
		Integer numPlayerChars = game.getMaxPlayers() - 1; //Subtract the banker. 
		//Calculate the number of households - maybe this should be on the hearth factory, so it generates the right number.
		Integer gameFamilySize = game.getHouseholdSize();
		double totalFamilies = Math.floor(numPlayerChars/gameFamilySize);
		
		//Create a banker
		PlayerCharFactory pcf = new PlayerCharFactory();
		try{
			pcf.createBanker(game);
		} catch (Exception e) {
			throw new Exception("Problem creating banker: " + e.getMessage());
		}
		//Create the men
		Village village = game.fetchVillageType();
		Integer numMen = village.calculateProportionMen((int) totalFamilies);
		try{
			pcf.createMen(numMen, game);
		} catch (Exception e) {
			throw new Exception("Problem creating men: " + e.getMessage());
		}
		//Create the women
		Integer numWomen = numPlayerChars - numMen;
		try {
			pcf.createWomen(numWomen, game);
		} catch (Exception e) {
			throw new Exception("Problem creating women: " + e.getMessage());
		}
		
		SeasonNotificationFactory snf = new SeasonNotificationFactory();
		snf.createSeasonNotifications(game, "Start of game");
	}

	@Override
	public void generateNotifications() throws Exception {
		// This only needs to be put in the Game manager's notification I think.
		PlayerCharFactory pcf = new PlayerCharFactory();
		Set<PlayerChar> pcs = pcf.fetchGamePCs(game);
		SeasonNotificationFactory snf = new SeasonNotificationFactory();
		
		String notification = "Character creation:\n";
		notification += pcs.size() + " characters were created for your game (including you!).";
		snf.updateBankerNotifications(notification, game);
		
	}

}
