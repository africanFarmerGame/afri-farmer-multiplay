/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.seasons;

import uk.ac.sussex.gameEvents.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.gameStage.CoreMarketTradingStage;
import uk.ac.sussex.model.gameStage.CoreTaskAllocationStage;
import uk.ac.sussex.model.gameStage.GameStage;

public class CoreEarlyRainsSeason extends Season {
	public static String ID = "CoreEarlyRainsSeason";
	public static String NAME = "Early Rains";
	public CoreEarlyRainsSeason(Game game, Integer displayOrder){
		super(game, ID);
		this.name = NAME;
		this.setDisplayOrder(displayOrder);
		
		GameStage marketTrading = new CoreMarketTradingStage();
		marketTrading.addPreStageEvent(new CoreCreateDefaultDietAllocationEvent(game));
		marketTrading.addPreStageEvent(new CoreGenerateFieldHistoryEvent(game));
		
		GameStage tasks = new CoreTaskAllocationStage();
		tasks.addPreStageEvent(new CoreCreateHouseholdTasksEvent(game));
		tasks.addPostStageEvent(new CoreAnnounceWeatherEvent(game));
		tasks.addPostStageEvent(new CoreCompleteTasksEvent(game));
		tasks.addPostStageEvent(new CoreAgeCropsEvent(game));
		tasks.addPostStageEvent(new CoreRemoveUnusedFoodEvent(game));
		tasks.addPostStageEvent(new CoreClaimSeasonalFinesEvent(game));
		tasks.addPostStageEvent(new CoreGenerateFinesEvent(game));
		
		this.addStage(marketTrading);
		this.addStage(tasks);
		
	}
}
