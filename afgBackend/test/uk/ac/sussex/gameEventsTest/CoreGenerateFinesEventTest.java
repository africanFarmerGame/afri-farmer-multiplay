/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.gameEventsTest;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;

import uk.ac.sussex.gameEvents.CoreGenerateFinesEvent;
import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

public class CoreGenerateFinesEventTest {

	@Test
	public void testFireEvent() {
		GameFactory gameFactory = new GameFactory();
		Game game = null;
		try {
			game = gameFactory.fetchGame(1);
		} catch (Exception e) {
			e.printStackTrace();
			fail("can't get game");
		}
		CoreGenerateFinesEvent finesEvent = new CoreGenerateFinesEvent(game);
		try {
			finesEvent.fireEvent();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem running");
		}
		BillFactory ff = new BillFactory();
		//Hearth hearth1 = fetchHearth(1);
		Hearth hearth2 = fetchHearth(19);
		List<Bill> fines1 = null;
		List<Bill> fines2 = null;
		try {
			//fines1 = ff.fetchHearthFines(hearth1);
			fines2 = ff.fetchHearthFines(hearth2);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Probelm getting fines. ");
		}
		assertEquals(0, fines2.size());
		assertNotNull(fines1);
	}
	private Hearth fetchHearth(Integer hearthid){
		HearthFactory hf = new HearthFactory();
		Hearth hearth = null;
		try {
			hearth= hf.fetchHearth(hearthid);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem with the hearths");
		}
		return hearth;
	}
}
