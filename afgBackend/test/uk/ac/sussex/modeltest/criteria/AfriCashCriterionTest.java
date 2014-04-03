package uk.ac.sussex.modeltest.criteria;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.grading.AfriCashCriterion;

public class AfriCashCriterionTest {

	@Test
	public void testCalculateValue() {
		//PlayerChar femalepc = fetchPC(8);
		AfriCashCriterion acc = new AfriCashCriterion();
		//acc.calculateValue(femalepc, 1);
		
		//assertNull(acc.getId()); // This criterion shouldn't work for a woman. 
		
		PlayerChar malepc = fetchPC(3);
		acc.calculateValue(malepc, 3);
		
		//assertNotNull(acc.getId());
	}

	@Test
	public void testDisplayOutput() {
		PlayerChar pc = fetchPC(42);
		AfriCashCriterion acc = new AfriCashCriterion();
		String cash = acc.displayYearEndOutput(pc, 1);
		System.out.println(cash);
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
