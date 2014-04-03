/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.base.BaseFactory;
import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.base.OrderList;
import uk.ac.sussex.model.base.RestrictionList;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.seasons.SeasonList;
import uk.ac.sussex.utilities.Logger;

public class SeasonNotificationFactory extends BaseFactory {

	public SeasonNotificationFactory() {
		super(new SeasonNotification());
	}
	public void createSeasonNotifications(Game game, String message) throws Exception {
		Set<PlayerChar> playerChars = game.fetchAllCharacters();
		SeasonList sl = game.fetchSeasonList();
		
		SeasonDetail previousSeason = game.getCurrentSeasonDetail();
		String previousStage;
		if(sl.getCurrentSeason()!=null && sl.getCurrentStage()!=null){
			previousStage = sl.getCurrentSeason().getName() + " " + sl.getCurrentStage().getName();
		} else {
			previousStage = "First stage";
		}	
		
		for (PlayerChar pc : playerChars){
			SeasonNotification sn = new SeasonNotification();
			sn.setCharacter(pc);
			sn.setPreviousSeason(previousSeason);
			sn.setPreviousStage(previousStage);
			sn.setNotification(message);
			sn.save();
		}
	}
	public void updateNextSeasonNotification(Game game) throws Exception {
		Set<PlayerChar> playerChars = game.fetchAllCharacters();
		SeasonList sl = game.fetchSeasonList();
		
		SeasonDetail nextSeason = game.getCurrentSeasonDetail();
		String nextStage = sl.getCurrentSeason().getName() + " " + sl.getCurrentStage().getName();
		
		for (PlayerChar pc : playerChars){
			SeasonNotification sn = fetchLatestPlayerCharNotification(pc);
			if(sn!=null){
				sn.setNextSeason(nextSeason);
				sn.setNextStage(nextStage);
				sn.save();
			}
		}
	}
	public void updateSeasonNotifications(String message, Game game) throws Exception{
		Set<PlayerChar> playerChars = game.fetchAllCharacters();
		this.updateSeasonNotifications(message, playerChars);
	}
	public void updateSeasonNotifications(String message, Set<PlayerChar> playerChars) throws Exception{
		for(PlayerChar pc: playerChars){
			this.updateSeasonNotifications(message, pc);
		}
	}
	public void updateSeasonNotifications(String message, PlayerChar playerChar) throws Exception {
		SeasonNotification sn = fetchLatestPlayerCharNotification(playerChar);
		if(sn!=null){
			String currentMessage = sn.getNotification();
			sn.setNotification(currentMessage + "\n\n" + message);
			sn.save();
		} else {
			Logger.ErrorLog("SeasonNotificationFactory.updateSeasonNotifications", "PlayerChar " + playerChar.getId() + " has no notification.");
		}
	}
	public SeasonNotification fetchLatestPlayerCharNotification(PlayerChar pc) throws Exception{
		SeasonNotification sn = null;
		RestrictionList rl = new RestrictionList();
		rl.addEqual("character", pc);
		OrderList ol = new OrderList();
		ol.addDescending("id");
		List<BaseObject> objects = this.fetchManyObjects(rl, ol);
		if(objects.size()>0){
			sn = (SeasonNotification) objects.get(0);
		}
		return sn;
	}
	public void updateBankerNotifications(String message, Game game) throws Exception {
		PlayerChar banker = game.fetchBanker();
		
		this.updateSeasonNotifications(message, banker);
	}
}
