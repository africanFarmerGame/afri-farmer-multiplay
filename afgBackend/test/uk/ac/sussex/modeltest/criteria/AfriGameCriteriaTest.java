/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.modeltest.criteria;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.grading.AfriGameCriteria;

public class AfriGameCriteriaTest {

	@Test
	public void testDisplayYearEndOutput() {
		PlayerChar pc = fetchPC(137);
		AfriGameCriteria agc = new AfriGameCriteria();
		String cash = agc.displayYearEndOutput(pc, 0);
		System.out.println(cash);
	}

	@Test
	public void testCalculateValue() {
		PlayerChar pc = fetchPC(137);
		AfriGameCriteria agc = new AfriGameCriteria();
		agc.calculateValue(pc, 0);
		
	}
	
	@Test 
	public void testFinalReckoning() {
		PlayerChar malepc = fetchPC(3);
		AfriGameCriteria agc = new AfriGameCriteria();
		System.out.println(agc.displayFinalReckoning(malepc));
		
		PlayerChar femalepc = fetchPC(7);
		System.out.println(agc.displayFinalReckoning(femalepc));
	}
	private PlayerChar fetchPC(Integer allCharId) {
		PlayerCharFactory pcf = new PlayerCharFactory();
		PlayerChar pc = null;
		try {
			pc = pcf.fetchPlayerChar(allCharId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unexpected issue getting the player char " + allCharId);
		}
		return pc;
	}
}
