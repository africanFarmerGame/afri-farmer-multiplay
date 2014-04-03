/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.base.BaseFactory;
import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.base.RestrictionList;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

public class TickerFactory extends BaseFactory {

	public TickerFactory() {
		super(new Ticker());
	}
	
	/**
	 * Fetches the currently active ticker message for a given game (if there is one).
	 * @param game
	 * @return A ticker object.
	 * @throws Exception
	 */
	public Ticker fetchCurrentTicker(Game game) throws Exception{
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("game", game);
		restrictions.addEqual("active", 1);
		List<BaseObject> objects = this.fetchManyObjects(restrictions);
		Set<Ticker> tickermessages = new HashSet<Ticker>();
		for (BaseObject object : objects ) {
			tickermessages.add((Ticker) object);
		}
		Ticker ticker = null;
		//This finds the most recent and sends that back. If more than one active, sets the others to not active and saves.
		Long currentTimestamp = 0L;
		for(Ticker message: tickermessages) {
			if(message.getTimestamp() > currentTimestamp){
				currentTimestamp = message.getTimestamp();
				if(ticker != null){
					ticker.setActive(0);
					ticker.save();
				}
				ticker = message;
			} else {
				message.setActive(0);
				message.save();
			}
		}
		return ticker;
	}
	
	/**
	 * Fetches all active ticker messages for all games. 
	 * @return HashSet of ticker objects
	 * @throws Exception
	 */
	public Set<Ticker> fetchActiveTickers() throws Exception {
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("active", 1);
		List<BaseObject> objects = this.fetchManyObjects(restrictions);
		Set<Ticker> tickermessages = new HashSet<Ticker>();
		for (BaseObject object : objects ) {
			tickermessages.add((Ticker) object);
		}
		return tickermessages;
	}
	
	/**
	 * 
	 * @param sender
	 * @param message
	 * @param duration
	 * @return
	 * @throws Exception
	 */
	public Ticker createTicker(PlayerChar sender, String message, Double duration) throws Exception {
		Ticker ticker = new Ticker();
		GameFactory gf = new GameFactory();
		Game game = gf.fetchGame(sender.getGame().getId());
		//Should really disable any other message
		Ticker oldTicker = this.fetchCurrentTicker(game);
		if(oldTicker != null){
			oldTicker.setActive(0);
			oldTicker.save();
		}
		ticker.setSender(sender);
		ticker.setMessage(message);
		ticker.setDuration(duration);
		ticker.setGame(game);
		ticker.setSeasonDetail(game.getCurrentSeasonDetail());
		ticker.setActive(1);
		ticker.save();
		
		return ticker;
	}

}
