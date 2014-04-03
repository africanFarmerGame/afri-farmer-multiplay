package uk.ac.sussex.model.seasons;

import uk.ac.sussex.model.game.Game;

public class AfriSeasonList extends SeasonList {

	public AfriSeasonList(Game game) {
		super(game);
	}

	@Override
	protected void setupSeasons() {
		Season pregame = new AfriPregameSeason(game, 0);
		Season earlyRains = new CoreEarlyRainsSeason(game, 1);
		Season lateRains = new CoreLateRainsSeason(game, 2);
		Season earlyHarvest = new CoreEarlyHarvestSeason(game, 3);
		Season lateHarvest = new CoreLateHarvestSeason(game, 4);
		Season endgame = new AfriEndgameSeason(game, 0);
		
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
		this.addSeason(endgame); //Need to add this to the list of possible seasons as well as marking it as the final.
		this.setEndSeason(endgame);
	}

}
