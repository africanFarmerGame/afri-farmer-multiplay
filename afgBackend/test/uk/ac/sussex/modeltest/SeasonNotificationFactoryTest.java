package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

public class SeasonNotificationFactoryTest {

	@Test
	public void testCreateSeasonNotifications() {
		SeasonNotificationFactory snf = new SeasonNotificationFactory();
		Game game = fetchGame(1);
		try {
			snf.createSeasonNotifications(game, "This is a test");
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't create the notifications");
		}
	}

	@Test
	public void testUpdateSeasonNotificationsStringGame() {
		SeasonNotificationFactory snf = new SeasonNotificationFactory();
		Game game = fetchGame(1);
		try {
			snf.updateSeasonNotifications("Updated", game);
		} catch (Exception e) {
			e.printStackTrace();
			fail("couldn't update the buggers. ");
		}
	}

	@Test
	public void testUpdateSeasonNotificationsStringSetOfPlayerChar() {
		fail("Not yet implemented");
	}

	private Game fetchGame(Integer gameId) {
		Game game = null;
		GameFactory gf = new GameFactory();
		try {
			game = gf.fetchGame(gameId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't fetch game");
		}
		return game;
	}
}
