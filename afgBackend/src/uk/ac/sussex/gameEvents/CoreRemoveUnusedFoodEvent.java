package uk.ac.sussex.gameEvents;

import uk.ac.sussex.model.game.Game;
/**
 * This event removes unused food. 
 * @author em97
 *
 */
public class CoreRemoveUnusedFoodEvent extends GameEvent {

	
	public CoreRemoveUnusedFoodEvent(Game game) {
		super(game);
	}

	@Override
	public void fireEvent() throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public void generateNotifications() throws Exception {
		// TODO Auto-generated method stub
	}

}
