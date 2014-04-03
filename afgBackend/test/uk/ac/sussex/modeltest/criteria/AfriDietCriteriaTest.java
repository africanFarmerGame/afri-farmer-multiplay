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
import uk.ac.sussex.model.grading.AfriDietCriteria;

public class AfriDietCriteriaTest {

	@Test
	public void testCalculateValue() {
		PlayerChar femalepc = fetchPC(7);
		AfriDietCriteria adc = new AfriDietCriteria();
		adc.calculateValue(femalepc, 3);
		
		//PlayerChar malepc = fetchPC(42);
		//adc.calculateValue(malepc, 1);
		
		
	}

	@Test
	public void testDisplayOutput() {
		fail("Not yet implemented");
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
