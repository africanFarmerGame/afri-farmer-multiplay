package uk.ac.sussex.model.seasons;

import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.gameStage.CoreEndingStage;
import uk.ac.sussex.model.gameStage.GameStage;

public class CoreEndgameSeason extends Season {
	public static String ID = "CoreEndgameSeason";
	public static String NAME = "End Game";
	public CoreEndgameSeason(Game game, Integer displayOrder){
		super(game, ID);
		this.setDisplayOrder(displayOrder);
		this.setupClass();
	}
	private void setupClass() {
		this.name = NAME;
		 
		GameStage ending = new CoreEndingStage();
		//ending.addPreStageEvent(new AfriCalculatePlayerStandingsEvent(game));
		this.addStage(ending);
	}
}
