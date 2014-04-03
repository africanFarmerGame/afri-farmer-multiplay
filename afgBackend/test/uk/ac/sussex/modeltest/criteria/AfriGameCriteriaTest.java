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
