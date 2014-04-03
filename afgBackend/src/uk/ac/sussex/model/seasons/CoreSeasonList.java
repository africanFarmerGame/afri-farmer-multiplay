/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.seasons;

import uk.ac.sussex.model.game.Game;

public class CoreSeasonList extends SeasonList {
	public CoreSeasonList(Game game){
		super(game);
	}

	@Override
	protected void setupSeasons() {
		Season pregame = new CorePregameSeason(game, 0);
		Season earlyRains = new CoreEarlyRainsSeason(game, 1);
		Season lateRains = new CoreLateRainsSeason(game, 2);
		Season earlyHarvest = new CoreEarlyHarvestSeason(game, 3);
		Season lateHarvest = new CoreLateHarvestSeason(game, 4);
		Season endgame = new CoreEndgameSeason(game, 0);
		
		pregame.setNextSeason(earlyRains);
		earlyRains.setNextSeason(lateRains);
		lateRains.setNextSeason(earlyHarvest);
		earlyHarvest.setNextSeason(lateHarvest);
		lateHarvest.setNextSeason(earlyRains);
		
		this.addSeason(pregame);
		this.addSeason(earlyRains);
		this.addSeason(lateRains);
		this.addSeason(earlyHarvest);
		this.addSeason(lateHarvest);
		this.addSeason(endgame);
		this.setEndSeason(endgame);
	}
}
