package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.model.*;

public class CharHealthHazardTest {

	@Test
	public void testCreateCharHealthHazard(){
		
		//Yes, this doesn't strictly belong here, but there we go. 
		CharHealthHazard chh = new CharHealthHazard();
		try {
			chh.save();
			fail("Unexpected success on save");
		} catch (Exception e) {
			e.printStackTrace();
			String message = e.getMessage();
			assertTrue(message.contains("CharHealthHazard|Season|Null||"));
			assertTrue(message.contains("CharHealthHazard|Hazard|Null||"));
			assertTrue(message.contains("CharHealthHazard|Bill|Null||"));
			assertTrue(message.contains("CharHealthHazard|Outcome|Null||"));
			assertTrue(message.contains("CharHealthHazard|Character|Null||"));
			assertFalse(message.contains("CharHealthHazard|Id|Null||"));
		}
		chh.setHazard(this.fetchHealthHazard(DietaryLevels.A));
		chh.setOutcome(CharHealthHazard.OUTCOME_DEATH);
		AllChars character = new AllChars();
		character.setId(1);
		chh.setCharacter(character);
		chh.setBill(this.fetchBill(1));
		SeasonDetail sd = new SeasonDetail();
		sd.setId(1);
		chh.setSeason(sd);
		try {
			chh.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't save when should");
		}
		assertNotNull(chh.getId());
	}
	private HealthHazard fetchHealthHazard(DietaryLevels level){
		HealthHazardFactory hff = new HealthHazardFactory();
		HealthHazard healthHazard = null;
		try {
			healthHazard = hff.fetchRandomHealthHazard(level);
		} catch (Exception e) {
			e.printStackTrace();
			fail("couldn't fetch hazard");
		}
		return healthHazard;
	}
	private Bill fetchBill(Integer billId){
		BillFactory bf = new BillFactory();
		Bill bill = null;
		try {
			bill = bf.fetchFine(billId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("couldn't get bill");
		}
		return bill;
	}
}
