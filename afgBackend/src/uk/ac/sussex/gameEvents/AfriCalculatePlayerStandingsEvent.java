package uk.ac.sussex.gameEvents;

import java.util.Set;

import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.SeasonNotificationFactory;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.grading.ICriterion;

public class AfriCalculatePlayerStandingsEvent extends GameEvent {

	public AfriCalculatePlayerStandingsEvent(Game game) {
		super(game);
	}

	@Override
	public void fireEvent() throws Exception {
		//Actually, everything on this one happens in the generateNotifications. 
	}

	@Override
	public void generateNotifications() throws Exception {
SeasonNotificationFactory snf = new SeasonNotificationFactory();
		
		ICriterion criteria = game.fetchGameCriteria();
		PlayerCharFactory pcf = new PlayerCharFactory();
		Set<PlayerChar> players = pcf.fetchGamePCs(game);
		for(PlayerChar pc: players){
			String notification = "Final Reckoning\n";
			notification += criteria.displayFinalReckoning(pc);
			snf.updateSeasonNotifications(notification, pc);
		}
	}

}
