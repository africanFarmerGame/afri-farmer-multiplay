/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.gameEventsTest;

import static org.junit.Assert.*;

import java.util.Date;
import java.util.List;
import java.util.Set;

import org.junit.Test;

import uk.ac.sussex.gameEvents.CoreClaimAnnualFinesEvent;
import uk.ac.sussex.gameEvents.CoreClaimSeasonalFinesEvent;
import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.CoreGame;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

public class CoreClaimOutstandingFinesEventTest {

	@Test
	public void testFireEvent() {
		//Need to create a few fines, and attempt to pay off each. 
		Date date = new Date();
		Game game = createGame("outstandingFinesGame" + date.getTime());
		SeasonDetail sd = game.getCurrentSeasonDetail();
		//I should now have a bunch of hearths with cash. 
		Set<Hearth> hearths = game.fetchHearths();
		Hearth cashRich = null;
		Hearth cashPoor = null;
		Hearth flatBroke = null;
		for (Hearth hearth: hearths){
			switch(hearth.getHousenumber()){
			case 1:
				cashRich = hearth;
				break;
			case 2:
				cashPoor = hearth;
				break;
			case 3: 
				flatBroke = hearth;
				break;
			}
		}
		Asset cash = fetchAsset(Asset.CASH);
		Asset cotton = fetchAsset(4);
		updateAssetOwnerAmount(cashRich, cash, (double) 1000);
		updateAssetOwnerAmount(cashPoor, cash, (double) 5);
		updateAssetOwnerAmount(cashPoor, cotton, (double) 30);
		updateAssetOwnerAmount(flatBroke, cash, (double) 0);
		createFine(cashRich, sd, BillPenalty.NAME);
		createFine(cashRich, sd, BillDeathDuty.NAME);
		//What do I want to test?
		//Annual fines are not paid off by the seasonal fines task.
		//Fines that can be paid off by cash are. 
		CoreClaimSeasonalFinesEvent ccSeasonalfe = new CoreClaimSeasonalFinesEvent(game);
		CoreClaimAnnualFinesEvent ccAnnualfe = new CoreClaimAnnualFinesEvent(game);
		try {
			ccSeasonalfe.fireEvent();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't fire the seasonal fines event");
		}
		List<Bill> cashRichFines = fetchHearthFines(cashRich);
		Double remainingCash = (double) 1000; 
		for (Bill fine: cashRichFines){
			if(fine.getDuration().equals(Bill.ANNUAL)){
				assertFalse(fine.getPaid().equals(Bill.BEEN_PAID));
			} else {
				assertTrue(fine.getPaid().equals(Bill.BEEN_PAID));
				remainingCash = remainingCash - fine.getLateRate();
			}
		}
		AssetOwner cashRichCash = fetchAssetOwner(cashRich, cash);
		assertEquals(cashRichCash.getAmount(), remainingCash);
		
		//Seasonal fines are not paid off by the annual fines task (although this is less of a problem).
		createFine(cashPoor, sd, BillPenalty.NAME);
		createFine(flatBroke, sd, BillPenalty.NAME);
		try {
			ccAnnualfe.fireEvent();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't fire the annual fines event");
		}
		cashRichFines = fetchHearthFines(cashRich);
		List<Bill> cashPoorFines = fetchHearthFines(cashPoor);
		List<Bill> flatBrokeFines = fetchHearthFines(flatBroke);
		for (Bill fine: cashRichFines){
			assertTrue(fine.getPaid().equals(Bill.BEEN_PAID));
		}
		for (Bill fine: cashPoorFines){
			assertFalse(fine.getPaid().equals(Bill.BEEN_PAID));
		}
		for (Bill fine: flatBrokeFines){
			assertFalse(fine.getPaid().equals(Bill.BEEN_PAID));
		}
		//Fines that can't be paid off by cash are paid by asset stripping.
		try {
			ccSeasonalfe.fireEvent();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't fire the seasonal event for the second time.");
		}
		cashPoorFines = fetchHearthFines(cashPoor);
		flatBrokeFines = fetchHearthFines(flatBroke);
		for(Bill fine: cashPoorFines){
			assertTrue(fine.getPaid().equals(Bill.BEEN_PAID));
		}
		AssetOwner cashPoorCotton = fetchAssetOwner(cashPoor, cotton);
		AssetOwner cashPoorCash = fetchAssetOwner(cashPoor, cash);
		assertEquals(cashPoorCotton.getAmount(), (Double)29.0);
		assertEquals(cashPoorCash.getAmount(), (Double)0.0);
		
		//Fines that can't be paid? Do we declare bankruptcy and clear the fines anyway?
		for(Bill fine: flatBrokeFines){
			assertFalse(fine.getPaid().equals(Bill.BEEN_PAID));
		}
	}
	private Game createGame(String gamename){
		GameFactory gf = new GameFactory();
		Game game = null;
		try {
			game = gf.createGame(CoreGame.TYPE, gamename, "", 15, "Village", 2);
		} catch (Exception e){
			e.printStackTrace();
			fail("Unable to create game");
		}
		return game;
	}
	private Asset fetchAsset(Integer assetId){
		AssetFactory af = new AssetFactory();
		Asset asset = null;
		try {
			asset = af.fetchAsset(assetId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't fetch asset");
		}
		return asset;
	}
	private void updateAssetOwnerAmount(Hearth hearth, Asset asset, Double amount){
		AssetOwner ao = fetchAssetOwner(hearth, asset);
		ao.setAmount(amount);
		try {
			ao.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't update the assetowner");
		}
		return;
	}
	private AssetOwner fetchAssetOwner(Hearth hearth, Asset asset){
		AssetOwnerFactory aof = new AssetOwnerFactory();
		AssetOwner ao = null;
		try {
			ao = aof.fetchSpecificAsset(hearth, asset);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Can't get assetowner");
		}
		return ao;
	}
	private void createFine(Hearth hearth, SeasonDetail sd, String finetype){
		Bill fine = null;
		try {
			fine = BillFactory.newBill(finetype);
		} catch (Exception e1) {
			e1.printStackTrace();
			fail("can't create the fine");
		}
		fine.setDescription("This is a " + finetype + " fine");
		fine.setEarlyRate((double) 10);
		fine.setLateRate((double) 20);
		fine.setPayee(hearth);
		fine.setSeason(sd);
		//fine.setDuration(finetype);
		try {
			fine.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unexpected problem saving.");
		}
	}
	private List<Bill> fetchHearthFines(Hearth hearth) {
		BillFactory ff = new BillFactory();
		List<Bill> hearthFines = null;
		try {
			hearthFines = ff.fetchHearthFines(hearth);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get the hearth fines");
		}
		return hearthFines;
	}
}
