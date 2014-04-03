package uk.ac.sussex.model.seasons;

import uk.ac.sussex.model.game.Game;

public class CoreSeasonList extends SeasonList {
	public CoreSeasonList(Game game){
		super(game);
	}

	@Override
	protected void setupSeasons() {
		Season pregame = new CorePregameSeason(game, 0);
		Season earlyRains = new CoreEarlyRainsSeason(game, 1);
		Season lateRains = new CoreLateRainsSeason(game, 2);
		Season earlyHarvest = new CoreEarlyHarvestSeason(game, 3);
		Season lateHarvest = new CoreLateHarvestSeason(game, 4);
		Season endgame = new CoreEndgameSeason(game, 0);
		
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
		this.addSeason(endgame);
		this.setEndSeason(endgame);
	}
}
