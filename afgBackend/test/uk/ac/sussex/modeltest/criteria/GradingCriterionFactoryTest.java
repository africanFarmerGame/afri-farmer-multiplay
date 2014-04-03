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
