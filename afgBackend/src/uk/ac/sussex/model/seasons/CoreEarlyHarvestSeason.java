package uk.ac.sussex.model.seasons;

import uk.ac.sussex.gameEvents.CoreAgeCropsEvent;
import uk.ac.sussex.gameEvents.CoreAnnounceCropHazardEvent;
import uk.ac.sussex.gameEvents.CoreAnnounceWeatherEvent;
import uk.ac.sussex.gameEvents.CoreClaimSeasonalFinesEvent;
import uk.ac.sussex.gameEvents.CoreCompleteTasksEvent;
import uk.ac.sussex.gameEvents.CoreCreateHouseholdTasksEvent;
import uk.ac.sussex.gameEvents.CoreGenerateFinesEvent;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.gameStage.CoreTaskAllocationStage;
import uk.ac.sussex.model.gameStage.GameStage;

public class CoreEarlyHarvestSeason extends Season {
	public static String ID = "CoreEarlyHarvestSeason";
	public static String NAME = "Early Harvest";
	public CoreEarlyHarvestSeason(Game game, Integer displayOrder){
		super(game, ID);
		this.name = NAME;
		this.setDisplayOrder(displayOrder);
		
		GameStage tasks = new CoreTaskAllocationStage();
		tasks.addPreStageEvent(new CoreAnnounceCropHazardEvent(game));
		tasks.addPreStageEvent(new CoreCreateHouseholdTasksEvent(game));
		tasks.addPostStageEvent(new CoreAnnounceWeatherEvent(game));
		tasks.addPostStageEvent(new CoreCompleteTasksEvent(game));
		tasks.addPostStageEvent(new CoreAgeCropsEvent(game));
		tasks.addPostStageEvent(new CoreClaimSeasonalFinesEvent(game));
		tasks.addPostStageEvent(new CoreGenerateFinesEvent(game));
		this.addStage(tasks);
		
	}
}
