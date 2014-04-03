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
