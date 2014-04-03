/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
