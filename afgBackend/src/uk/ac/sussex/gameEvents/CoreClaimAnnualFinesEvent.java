package uk.ac.sussex.gameEvents;

import uk.ac.sussex.model.Bill;
import uk.ac.sussex.model.game.Game;

public class CoreClaimAnnualFinesEvent extends CoreClaimOutstandingFinesEvent {

	public CoreClaimAnnualFinesEvent(Game game) {
		super(game);
	}

	@Override
	public void fireEvent() throws Exception {
		super.claimFines(Bill.ANNUAL);
	}

	@Override
	public void generateNotifications() throws Exception {
		// TODO Auto-generated method stub
	}

}
