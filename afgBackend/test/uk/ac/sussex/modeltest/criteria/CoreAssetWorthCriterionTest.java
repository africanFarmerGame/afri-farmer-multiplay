package uk.ac.sussex.modeltest.criteria;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.grading.CoreAssetWorthCriterion;

public class CoreAssetWorthCriterionTest {

	@Test
	public void testCalculateValue() {
		//PlayerChar femalepc = fetchPC(8);
		CoreAssetWorthCriterion cawc = new CoreAssetWorthCriterion();
		//cawc.calculateValue(femalepc, 1);
		
		PlayerChar malepc = fetchPC(3);
		cawc.calculateValue(malepc, 3);
		
	}

	@Test
	public void testDisplayYearEndOutput() {
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
