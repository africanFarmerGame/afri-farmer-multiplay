/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.gameEvents;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.FieldFactory;
import uk.ac.sussex.model.Field;
import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.SeasonNotificationFactory;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.village.Village;
import uk.ac.sussex.model.village.VillageFarm;
import uk.ac.sussex.utilities.Logger;

public class AfriEndIntroMopUpEvent extends GameEvent {

	public AfriEndIntroMopUpEvent(Game game) {
		super(game);
	}

	@Override
	public void fireEvent() throws Exception {
		FieldFactory fieldFactory = new FieldFactory();
		Village village = game.fetchVillageType();
		//Need the total hearths in this game. 
		Set<Hearth> hearths = game.fetchHearths();
		//Need to find the hearth(s) with no fields.
		Set<Hearth> fieldless = new HashSet<Hearth>();
		for (Hearth hearth : hearths) {
			List<Field> fields = fieldFactory.getHearthFields(hearth);
			if(fields.size()==0){
				fieldless.add(hearth);
			}
		}
		VillageFarm smallestFarm = village.getSmallestFarm(hearths.size());
		if(smallestFarm!=null){
			for(Hearth hearth: fieldless){
				try {
					fieldFactory.createFields(smallestFarm.getFarmSize(), hearth);
				} catch (Exception e) {
					Logger.ErrorLog("AfriIntroMopUpEvent.fireEvent", "There was a problem creating fields for hearth " + hearth.getId() + ": " + e.getMessage());
				}
			}
		} else {
			Logger.ErrorLog("AfriIntroMopUpEvent.fireEvent", "I couldn't get the smallest farm, it returned null.");
		}
	}

	@Override
	public void generateNotifications() throws Exception {
		Set<Hearth> hearths = game.fetchHearths();
		FieldFactory fieldFactory = new FieldFactory();
		SeasonNotificationFactory noteFactory = new SeasonNotificationFactory();
		for(Hearth hearth: hearths){
			Set<PlayerChar> playerChars = hearth.getCharacters();
			List<Field> fields = fieldFactory.getHearthFields(hearth);
			String message = "Introductions complete:\n";
			message += "You now have " + playerChars.size() + " players in your family, and " + fields.size() + " fields to plant.";
			for(PlayerChar playerChar: playerChars){
				noteFactory.updateSeasonNotifications(message, playerChar);
			}
		}
		String bankerMessage = "Introductions complete:\n Every hearth should now have some fields.";
		noteFactory.updateBankerNotifications(bankerMessage, game);
	}

}
