package uk.ac.sussex.gameEvents;

import java.util.Set;

import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.SeasonNotificationFactory;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.grading.ICriterion;
import uk.ac.sussex.utilities.Logger;

public class CoreCalculateAnnualGradingCriteriaEvent extends GameEvent {

	public CoreCalculateAnnualGradingCriteriaEvent(Game game) {
		super(game);
	}

	@Override
	public void fireEvent() throws Exception {
		Logger.ErrorLog("CoreCalculateAnnualGradingCriteriaEvent.fireEvent", "Firing.");
		ICriterion criteria = game.fetchGameCriteria();
		if(criteria==null){
			throw new Exception("Game criteria is null");
		}
		Integer gameYear = game.getGameYear();
		PlayerCharFactory pcf = new PlayerCharFactory();
		Set<PlayerChar> players;
		try {
			players = pcf.fetchGamePCs(game);
		} catch (Exception e) {
			throw new Exception ("Unable to fetch pcs for game" + e.getMessage());
		}
		Logger.ErrorLog("CoreCalculateAnnualGradingCriteriaEvent.fireEvent", "About to calculate criteria");
		for(PlayerChar pc: players){
			criteria.calculateValue(pc, gameYear);
		}
		Logger.ErrorLog("CoreCalculateAnnualGradingCriteriaEvent.fireEvent", "Reached end of calculate grading.");
	}

	@Override
	public void generateNotifications() throws Exception {
		SeasonNotificationFactory snf = new SeasonNotificationFactory();
		
		ICriterion criteria = game.fetchGameCriteria();
		Integer gameYear = game.getGameYear() - 1;	//By this point the game year has been increased!
		PlayerCharFactory pcf = new PlayerCharFactory();
		Set<PlayerChar> players = pcf.fetchGamePCs(game);
		for(PlayerChar pc: players){
			String notification = "Progress Report:\n";
			notification += criteria.displayYearEndOutput(pc, gameYear);
			snf.updateSeasonNotifications(notification, pc);
		}
	}

}
