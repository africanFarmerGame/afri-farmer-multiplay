/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import java.util.Random;
import java.util.Set;

import org.junit.Test;

import uk.ac.sussex.model.*;

public class FinesTest {

	@Test
	public void testSave() {
		Hearth hearth = fetchHearth(1);
		
		Bill penalty = fetchNewBill(BillPenalty.NAME);
		try {
			penalty.save();
			fail("Save success");
		} catch (Exception e) {
			e.printStackTrace();
			String message = e.getMessage();
			assertTrue(message.contains("BillPenalty|Description|Null||"));
			assertTrue(message.contains("BillPenalty|EarlyRate|Null||"));
			assertTrue(message.contains("BillPenalty|LateRate|Null||"));
			assertTrue(message.contains("BillPenalty|Payee|Null||"));
			assertTrue(message.contains("BillPenalty|Season|Null||"));
			assertFalse(message.contains("BillPenalty|Duration|Null||"));
			assertFalse(message.contains("BillPenalty|Paid|Null||"));
			assertFalse(message.contains("BillPenalty|BillType|Null||"));
		}
		penalty.setDescription("This is a test fine");
		penalty.setEarlyRate((double) 10);
		penalty.setLateRate((double)20);
		penalty.setPayee(hearth);
		penalty.setSeason(fetchSeason(5));
		penalty.setDuration(Bill.SEASONAL);
		try {
			penalty.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unexpected problem saving penalty.");
		}
		assertNotNull(penalty.getId());
		
		Bill deathDuty = fetchNewBill(BillDeathDuty.NAME);
		try {
			deathDuty.save();
			fail("Save success");
		} catch (Exception e) {
			e.printStackTrace();
			String message = e.getMessage();
			assertTrue(message.contains("BillDeathDuty|Description|Null||"));
			assertFalse(message.contains("BillDeathDuty|EarlyRate|Null||"));
			assertFalse(message.contains("BillDeathDuty|LateRate|Null||"));
			assertTrue(message.contains("BillDeathDuty|Payee|Null||"));
			assertTrue(message.contains("BillDeathDuty|Season|Null||"));
			assertTrue(message.contains("BillDeathDuty|Character|Null"));
			assertFalse(message.contains("BillDeathDuty|Duration|Null||"));
			assertFalse(message.contains("BillDeathDuty|Paid|Null||"));
			assertFalse(message.contains("BillDeathDuty|BillType|Null||"));
		}
		deathDuty.setDescription("This is a test fine");
		deathDuty.setPayee(hearth);
		deathDuty.setSeason(fetchSeason(5));
		deathDuty.setCharacter(fetchChar(hearth));
		try {
			deathDuty.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unexpected problem saving deathDuty.");
		}
		assertNotNull(deathDuty.getId());
		
		Bill hospital = fetchNewBill(BillHospital.NAME);
		try {
			hospital.save();
			fail("Save success");
		} catch (Exception e) {
			e.printStackTrace();
			String message = e.getMessage();
			assertTrue(message.contains("BillHospital|Description|Null||"));
			assertTrue(message.contains("BillHospital|EarlyRate|Null||"));
			assertTrue(message.contains("BillHospital|LateRate|Null||"));
			assertTrue(message.contains("BillHospital|Payee|Null||"));
			assertTrue(message.contains("BillHospital|Season|Null||"));
			assertTrue(message.contains("BillHospital|Character|Null"));
			assertFalse(message.contains("BillHospital|Duration|Null||"));
			assertFalse(message.contains("BillHospital|Paid|Null||"));
			assertFalse(message.contains("BillHospital|BillType|Null||"));
		}
		hospital.setDescription("This is a test fine");
		hospital.setPayee(hearth);
		hospital.setEarlyRate((double) 10);
		hospital.setLateRate((double)20);
		hospital.setSeason(fetchSeason(5));
		hospital.setCharacter(fetchChar(hearth));
		try {
			hospital.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unexpected problem saving hospital.");
		}
		assertNotNull(hospital.getId());
	}
	@Test
	public void testPayFine() {
		Hearth hearth = fetchHearth(1);
		SeasonDetail season = fetchSeason(5);
		
		Bill penalty = fetchNewBill(BillPenalty.NAME);
		penalty.setDescription("Penalty to test payment");
		penalty.setEarlyRate(10.00);
		penalty.setLateRate(20.00);
		penalty.setPayee(hearth);
		penalty.setSeason(season);
		try {
			penalty.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't save penalty");
		}
		
		
		Bill deathduty = fetchNewBill(BillDeathDuty.NAME);
		deathduty.setDescription("Death duty to test payment.");
		deathduty.setEarlyRate(10.00);
		deathduty.setLateRate(10.00);
		deathduty.setPayee(hearth);
		deathduty.setSeason(season);
		try {
			deathduty.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't save deathduty");
		}
		
		HealthHazard hazard = fetchHazard();
		
		Bill hospitalBill = fetchNewBill(BillHospital.NAME);
		hospitalBill.setDescription("Hospital bill for testing payment.");
		hospitalBill.setEarlyRate(hazard.getMedicineCost());
		hospitalBill.setLateRate(hazard.getMedicineCost());
		hospitalBill.setPayee(hearth);
		hospitalBill.setSeason(season);
		try {
			hospitalBill.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't save hospitalBill");
		}
		AllChars character = fetchChar(hearth);
		CharHealthHazard chh = new CharHealthHazard();
		chh.setBill(hospitalBill);
		chh.setHazard(hazard);
		chh.setOutcome(CharHealthHazard.OUTCOME_HOSPITAL);
		chh.setSeason(season);
		chh.setCharacter(character);
		try {
			chh.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't save the char health hazard");
		}
		
		try{
			penalty.payBill();
		} catch (Exception e){
			e.printStackTrace();
			fail("Couldn't pay penalty");
		}
		assertEquals(penalty.getPaid(), Bill.BEEN_PAID);
		
		try {
			deathduty.payBill();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't pay death duty");
		}
		assertEquals(deathduty.getPaid(), Bill.BEEN_PAID);
		
		try {
			hospitalBill.payBill();
		} catch(Exception e) {
			e.printStackTrace();
			fail("Couldn't pay hospital bill");
		}
		
		assertEquals(hospitalBill.getPaid(), Bill.BEEN_PAID);
		AllCharsFactory acf = new AllCharsFactory();
		try {
			character = acf.fetchAllChar(character.getId());
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't test the character detail.");
		}
		assertEquals(character.getAlive(), AllChars.ALIVE);
	}
	private Hearth fetchHearth(Integer hearthId){
		HearthFactory hf = new HearthFactory();
		Hearth hearth = null;
		try {
			hearth = hf.fetchHearth(hearthId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the hearth");
		}
		return hearth;
	}
	private SeasonDetail fetchSeason(Integer seasonId){
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		SeasonDetail sd = null;
		try {
			sd = sdf.fetchSeasonDetail(seasonId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Can't get the season.");
		}
		return sd;
	}
	private Bill fetchNewBill(String billType){
		Bill bill = null;
		try {
			bill = BillFactory.newBill(billType);
		} catch (Exception e1) {
			e1.printStackTrace();
			fail("Can't get the bill");
		}
		return bill;
	}
	private HealthHazard fetchHazard(){
		HealthHazardFactory hhf = new HealthHazardFactory();
		HealthHazard hazard = null;
		try {
			hazard = hhf.fetchRandomHealthHazard(DietaryLevels.B);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get a health hazard");
		}
		return hazard;
	}
	private AllChars fetchChar(Hearth hearth) {
		Set<PlayerChar> characters = hearth.getCharacters();
		int rnd = new Random().nextInt(characters.size());
		AllChars character = (AllChars) characters.toArray()[rnd];
		character.setAlive(AllChars.ILL);
		try {
			character.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't make char ill.");
		}
		
		return  character;
	}
}
