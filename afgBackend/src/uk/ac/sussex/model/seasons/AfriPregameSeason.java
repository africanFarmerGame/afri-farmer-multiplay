/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.seasons;

import uk.ac.sussex.gameEvents.AfriAssetAllocationEvent;
import uk.ac.sussex.gameEvents.AfriCreateFamiliesEvent;
import uk.ac.sussex.gameEvents.AfriEndIntroMopUpEvent;
import uk.ac.sussex.gameEvents.CoreCalculateAnnualGradingCriteriaEvent;
import uk.ac.sussex.gameEvents.CoreCreatePlayersEvent;
import uk.ac.sussex.gameEvents.AfriHearthAllocationEvent;
import uk.ac.sussex.gameEvents.CoreIncrementGameYearEvent;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.gameStage.CoreIntroductionStage;
import uk.ac.sussex.model.gameStage.GameStage;

public class AfriPregameSeason extends Season {
	public static String ID = "AfriPregameSeason";
	public static String NAME = "Pre-game";
	
	public AfriPregameSeason(Game game, Integer displayOrder){
		super(game, ID);
		
		this.setupClass();
		this.setDisplayOrder(displayOrder);
	}
	private void setupClass() {
		this.name = NAME;
		 
		GameStage intro = new CoreIntroductionStage();
		intro.addPreStageEvent(new CoreCreatePlayersEvent(game));
		intro.addPreStageEvent(new AfriHearthAllocationEvent(game));
		intro.addPreStageEvent(new AfriCreateFamiliesEvent(game));
		intro.addPreStageEvent(new AfriAssetAllocationEvent(game));
		intro.addPostStageEvent(new AfriEndIntroMopUpEvent(game));
		intro.addPostStageEvent(new CoreCalculateAnnualGradingCriteriaEvent(game));
		intro.addPostStageEvent(new CoreIncrementGameYearEvent(game));
		this.addStage(intro);
	}
}
