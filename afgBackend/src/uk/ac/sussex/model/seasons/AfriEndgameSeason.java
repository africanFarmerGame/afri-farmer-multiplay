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
