package uk.ac.sussex.gameEvents;

import uk.ac.sussex.model.Bill;
import uk.ac.sussex.model.game.Game;

public class CoreClaimSeasonalFinesEvent extends CoreClaimOutstandingFinesEvent {

	public CoreClaimSeasonalFinesEvent(Game game) {
		super(game);
	}

	@Override
	public void fireEvent() throws Exception {
		super.claimFines(Bill.SEASONAL);
	}

	@Override
	public void generateNotifications() throws Exception {
		// TODO Auto-generated method stub
	}

}
