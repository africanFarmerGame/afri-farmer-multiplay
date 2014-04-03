package uk.ac.sussex.modeltest.criteria;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.grading.CoreLivingHearthMembersCriterion;

public class CoreLivingHearthMembersCriterionTest {

	@Test
	public void testCalculateValue() {
		PlayerChar femalepc = fetchPC(129);
		CoreLivingHearthMembersCriterion adc = new CoreLivingHearthMembersCriterion();
		adc.calculateValue(femalepc, 0);
	}

	@Test
	public void testDisplayYearEndOutput() {
		PlayerChar pc = fetchPC(129);
		CoreLivingHearthMembersCriterion agc = new CoreLivingHearthMembersCriterion();
		String cash = agc.displayYearEndOutput(pc, 0);
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
