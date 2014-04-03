/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.seasons;

import uk.ac.sussex.gameEvents.AfriCalculatePlayerStandingsEvent;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.gameStage.CoreEndingStage;
import uk.ac.sussex.model.gameStage.GameStage;

public class AfriEndgameSeason extends Season {
	public static String ID = "AfriEndgameSeason";
	public static String NAME = "End Game";
	public AfriEndgameSeason(Game game, Integer displayOrder){
		super(game, ID);
		
		this.setDisplayOrder(displayOrder);
		this.setupClass();
	}
	private void setupClass() {
		this.name = NAME;
		 
		GameStage ending = new CoreEndingStage();
		ending.addPreStageEvent(new AfriCalculatePlayerStandingsEvent(game));
		this.addStage(ending);
	}
}
