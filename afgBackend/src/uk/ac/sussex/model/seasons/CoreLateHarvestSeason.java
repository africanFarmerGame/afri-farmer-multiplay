package uk.ac.sussex.model.seasons;

import uk.ac.sussex.gameEvents.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.gameStage.*;

public class CoreLateHarvestSeason extends Season {
	public static String ID = "CoreLateHarvestSeason";
	public static String NAME = "Late Harvest";
	public CoreLateHarvestSeason(Game game, Integer displayOrder){
		super(game, ID);
		this.name = NAME;
		this.setDisplayOrder(displayOrder);
		
		GameStage tasks = new CoreTaskAllocationStage();
		tasks.addPreStageEvent(new CoreAnnounceCropHazardEvent(game));
		tasks.addPreStageEvent(new CoreCreateHouseholdTasksEvent(game));
		tasks.addPostStageEvent(new CoreAnnounceWeatherEvent(game));
		tasks.addPostStageEvent(new CoreCompleteTasksEvent(game));
		tasks.addPostStageEvent(new CoreAnnounceChanceEvent(game));
		//tasks.addPostStageEvent(new CoreGenerateFinesEvent(game));
		
		GameStage food = new CoreFoodAllocationStage();
		food.addPostStageEvent(new CoreAgeCropsEvent(game));
		food.addPostStageEvent(new CoreAllocateFoodEvent(game));
		food.addPostStageEvent(new CoreClaimSeasonalFinesEvent(game));
		food.addPostStageEvent(new CoreClaimAnnualFinesEvent(game));
		food.addPostStageEvent(new CoreGenerateFinesEvent(game));
		food.addPostStageEvent(new CoreAnnounceHealthHazardEvent(game));
		food.addPostStageEvent(new CoreCalculateAnnualGradingCriteriaEvent(game));//This way the diets of the new babies doesn't have any effect.
		food.addPostStageEvent(new CoreAgeCharactersEvent(game));
		food.addPostStageEvent(new CoreBirthsEvent(game));
		food.addPostStageEvent(new CoreIncrementGameYearEvent(game));
		
		this.addStage(tasks);
		//this.addStage(new CoreMarketTradingStage());
		this.addStage(food);
	}
}
