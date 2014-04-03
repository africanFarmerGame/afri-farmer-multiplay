package uk.ac.sussex.gameEvents;

import uk.ac.sussex.model.SeasonNotificationFactory;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.utilities.Logger;

public class CoreIncrementGameYearEvent extends GameEvent {

	public CoreIncrementGameYearEvent(Game game){
		super(game);
	}
	@Override
	public void fireEvent() throws Exception {
		Logger.ErrorLog("CoreIncrementGameYearEvent.fireEvent", "I am fired");
		Integer currentGameYear = game.getGameYear();
		game.setGameYear(currentGameYear + 1);
		game.save();
	}
	@Override
	public void generateNotifications() throws Exception {
		Integer gameYear = game.getGameYear();
		SeasonNotificationFactory snf = new SeasonNotificationFactory();
		snf.updateSeasonNotifications("You are now entering Year " + gameYear, game);
	}

}
