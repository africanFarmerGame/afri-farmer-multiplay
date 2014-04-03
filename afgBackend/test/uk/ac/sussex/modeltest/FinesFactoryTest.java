package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;

import uk.ac.sussex.model.*;

public class FinesFactoryTest {

	@Test
	public void testFetchFine() {
		fail("Not yet implemented");
	}

	@Test
	public void testFetchHearthFines() {
		BillFactory ff = new BillFactory();
		List<Bill> fines= null;
		try {
			fines = ff.fetchHearthFines(fetchHearth(1));
		} catch (Exception e) {
			e.printStackTrace();
			fail("Error getting the fines");
		}
		assertNotNull(fines);
		assertTrue(fines.size()>0);
	}
	@Test
	public void testFetchOutstandingHearthFines(){
		BillFactory ff = new BillFactory();
		List<Bill> seasonalFines = null;
		List<Bill> annualFines = null;
		Hearth hearth = fetchHearth(1);
		try{
			seasonalFines = ff.fetchOutstandingHearthFines(hearth, Bill.SEASONAL);
			annualFines = ff.fetchOutstandingHearthFines(hearth, Bill.ANNUAL);
		} catch (Exception e){
			e.printStackTrace();
			fail("Error getting the fines");
		}
		assertNotNull(seasonalFines);
		assertTrue(seasonalFines.size()>0);
		assertNotNull(annualFines);
		assertEquals(annualFines.size(), 0);
	}
	@Test 
	public void testNewFine(){
		Bill billPenalty = null;
		try {
			billPenalty = BillFactory.newBill(BillPenalty.NAME);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get a penalty");
		}
		assertNotNull(billPenalty);
		assertTrue(billPenalty.getBillType().equals(BillPenalty.NAME));
		
		Bill billDeathDuty = null;
		try {
			billDeathDuty = BillFactory.newBill(BillDeathDuty.NAME);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get a death duty");
		}
		assertNotNull(billDeathDuty);
		assertTrue(billDeathDuty.getBillType().equals(BillDeathDuty.NAME));
	}
	@Test 
	public void testFetchOutstandingDeathDuty(){
		BillFactory billFactory = new BillFactory();
		Hearth hearth = fetchHearth(5);
		List<Bill> deathDuty = null;
		try {
			deathDuty = billFactory.fetchOutstandingDeathDuty(hearth);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't do ti. ");
		}
		assertNotNull(deathDuty);
		assertTrue(deathDuty.size()>0);
	}
	@Test
	public void testCountUnpaidFines(){
		BillFactory billFactory = new BillFactory();
		Hearth hearth = fetchHearth(101);
		Integer pending = 0;
		try {
			pending = billFactory.countHouseholdUnpaidBills(hearth);
		} catch(Exception e){
			e.printStackTrace();
			fail("Unexpected issue counting.");
		}
		assertEquals(0, pending.intValue());
	}
	@Test
	public void testFetchUnpaidCharacterBill(){
		BillFactory billFactory = new BillFactory();
		AllChars character = fetchPC(11);
		List<Bill> bills = null;
		try {
			bills = billFactory.fetchUnpaidCharacterBill(BillDeathDuty.NAME, character);
		} catch (Exception e){
			e.printStackTrace();
			fail("Problem");
		}
		assertNotNull(bills);
		assertTrue(bills.size()>0);
	}
	@Test
	public void testFetchSeasonalHouseholdBills(){
		BillFactory billFactory = new BillFactory();
		Hearth hearth = fetchHearth(355);
		SeasonDetail sd = fetchSeasonDetail(20);
		List<Bill> bills = null;
		try {
			bills = billFactory.fetchSeasonalHouseholdBills(BillDeathDuty.NAME, hearth, sd);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem!");
		}
		assertNotNull(bills);
		assertEquals(bills.size(), 0);
	}
	private Hearth fetchHearth(Integer hearthId){
		HearthFactory hf = new HearthFactory();
		Hearth hearth = null;
		try {
			hearth = hf.fetchHearth(hearthId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("couldn't get hearth");
		}
		return hearth;
	}
	private PlayerChar fetchPC(Integer playerId) {
		PlayerCharFactory pcf = new PlayerCharFactory();
		PlayerChar samplegm = null;
		try {
			samplegm = pcf.fetchPlayerChar(playerId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting the samplegm: " + e.getMessage());
		}
		return samplegm;
	}
	private SeasonDetail fetchSeasonDetail(Integer sdId){
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		SeasonDetail sd = null;
		try {
			sd = sdf.fetchSeasonDetail(sdId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem with the season detail");
		}
		return sd;
	}

}
