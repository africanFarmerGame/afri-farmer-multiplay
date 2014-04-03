package uk.ac.sussex.gameEvents;

import uk.ac.sussex.model.game.Game;

public abstract class GameEvent {
	protected Game game;
	public GameEvent(Game game){
		this.game = game;
	}
	abstract public void fireEvent() throws Exception;
	abstract public void generateNotifications() throws Exception;
}
