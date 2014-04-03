package uk.ac.sussex.gameEvents;

import uk.ac.sussex.model.game.Game;

public class CoreAnnounceChanceEvent extends GameEvent {

	public CoreAnnounceChanceEvent(Game game) {
		super(game);
		// TODO Auto-generated constructor stub
	}

	@Override
	public void fireEvent() throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public void generateNotifications() throws Exception {
		// TODO Auto-generated method stub
		//SeasonNotificationFactory snf = new SeasonNotificationFactory();
		//snf.updateSeasonNotifications("Chance Events:\n", game);
	}

}
