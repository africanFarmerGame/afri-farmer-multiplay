package uk.ac.sussex.model.seasons;

import uk.ac.sussex.gameEvents.CoreAssetAllocationEvent;
import uk.ac.sussex.gameEvents.CoreCalculateAnnualGradingCriteriaEvent;
import uk.ac.sussex.gameEvents.CoreCreateFamiliesEvent;
import uk.ac.sussex.gameEvents.CoreCreatePlayersEvent;
import uk.ac.sussex.gameEvents.CoreHearthAllocationEvent;
import uk.ac.sussex.gameEvents.CoreIncrementGameYearEvent;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.gameStage.*;

public class CorePregameSeason extends Season {
	public static String ID = "CorePregameSeason";
	public static String NAME = "Pre-game";
	public CorePregameSeason(Game game, Integer displayOrder){
		super(game, ID);
		
		this.setupClass();
		this.setDisplayOrder(displayOrder);
	}
	private void setupClass() {
		this.name = NAME;
		 
		GameStage intro = new CoreIntroductionStage();
		intro.addPreStageEvent(new CoreCreatePlayersEvent(game));
		intro.addPreStageEvent(new CoreHearthAllocationEvent(game));
		intro.addPreStageEvent(new CoreCreateFamiliesEvent(game));
		intro.addPreStageEvent(new CoreAssetAllocationEvent(game));
		intro.addPostStageEvent(new CoreCalculateAnnualGradingCriteriaEvent(game));
		intro.addPostStageEvent(new CoreIncrementGameYearEvent(game));
		this.addStage(intro);
	}
}
