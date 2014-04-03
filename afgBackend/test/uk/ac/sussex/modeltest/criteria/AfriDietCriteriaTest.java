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
