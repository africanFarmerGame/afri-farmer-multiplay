/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.modeltest.criteria;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;

import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.grading.AfriCashCriterion;
import uk.ac.sussex.model.grading.CoreAssetWorthCriterion;
import uk.ac.sussex.model.grading.CoreDietACriterion;
import uk.ac.sussex.model.grading.CoreDietXCriterion;
import uk.ac.sussex.model.grading.GradingCriterion;
import uk.ac.sussex.model.grading.GradingCriterionFactory;

public class GradingCriterionFactoryTest {

	@Test
	public void testFetchSpecificCriterion() {
		PlayerChar noCritPc = fetchPC(1);
		GradingCriterionFactory gcf = new GradingCriterionFactory();
		GradingCriterion gc = null;
		try {
			gc = gcf.fetchSpecificAnnualCriterion(CoreAssetWorthCriterion.TYPE, noCritPc, 1);
			fail("Should have thrown an error");
		} catch (Exception e) {
			e.printStackTrace();
			assertTrue(e.getMessage().contains("Query returned no results"));
		}
		
		PlayerChar tooManyPc = fetchPC(8);
		try {
			gc = gcf.fetchSpecificAnnualCriterion(CoreDietXCriterion.TYPE, tooManyPc, 1);
			fail("Should have thrown a different error");
		} catch (Exception e) {
			e.printStackTrace();
			assertTrue(e.getMessage().contains("Query returned too many results"));
		}
		
		PlayerChar justRightPC = fetchPC(42);
		try {
			gc = gcf.fetchSpecificAnnualCriterion(AfriCashCriterion.TYPE, justRightPC, 1);
			assertNotNull(gc);
		} catch (Exception e) {
			e.printStackTrace();
			fail("unexpected failure");
		}
	}
	@Test
	public void testFetchAllSpecificCriterion() {
		PlayerChar pc = fetchPC(8);
		GradingCriterionFactory gcf = new GradingCriterionFactory();
		List<GradingCriterion> criteria = null;
		try {
			criteria = gcf.fetchAllSpecificCriterion(CoreDietACriterion.TYPE, pc);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching. ");
		}
		assertNotNull(criteria);
		assertTrue(criteria.size()>0);
		for(GradingCriterion gc: criteria){
			System.out.println("Criterion " + gc.getId() + " is for player " + pc.getId() + " in year " + gc.getGameYear());
		}
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
