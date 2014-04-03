/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.gameEventsTest;

import static org.junit.Assert.*;

import java.util.Date;

import org.junit.Test;

import uk.ac.sussex.gameEvents.CoreBirthsEvent;
import uk.ac.sussex.model.game.CoreGame;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

public class CoreBirthsEventTest {

	@Test
	public void testFireEvent() {
		//Not quite sure how to test this one. It's random.
		Date date = new Date();
		
		Game game = createGame("BirthTest" + date.getTime());
		CoreBirthsEvent cbe = new CoreBirthsEvent(game);
		try {
			cbe.fireEvent();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to complete");
		}
	}

	private Game createGame(String gamename){
		GameFactory gf = new GameFactory();
		Game game = null;
		try {
			game = gf.createGame(CoreGame.TYPE, gamename, "", 13, gamename, 2);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to create game " + gamename);
		}
		return game;
	}
}
