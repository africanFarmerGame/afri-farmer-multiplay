/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.gameEventsTest;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.gameEvents.CoreAssetAllocationEvent;
import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

public class CoreAssetAllocationEventTest {

	@Test
	public void test() {
		Game game = null;
		Hearth hearth = null;
		Integer pcAdults = 1;
		Integer npcAdults = 1;
		Integer numChildren = 1;
		//Need to create a family. 
		try{
			game = fetchGame(1);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Issue! " + e.getMessage());
		}
		try {
			hearth = fetchHearth("AssetAllocation", game);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Issue with hearth creation! " + e.getMessage());
		}
		try {
			createHearthMembers(game, hearth, pcAdults, npcAdults, numChildren);
		} catch (Exception e) {
			e.printStackTrace();
			fail ("Couldn't create hearth members.");
		}
		CoreAssetAllocationEvent caae = new CoreAssetAllocationEvent(game);
		try {
			caae.fireEvent();
		} catch (Exception e1) {
			e1.printStackTrace();
			fail("Couldn't execute event");
		}
		AssetOwnerFactory aof = new AssetOwnerFactory();
		Asset cash = new Asset();
		cash.setId(Asset.CASH);
		AssetOwner cashOwner = null;
		try {
			cashOwner = aof.fetchSpecificAsset(hearth, cash);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't fetch asset");
		}
		Double amount = (double) ((pcAdults + npcAdults) * 30);
		assertEquals(amount, cashOwner.getAmount());
	}
	private Game fetchGame(Integer gameId) throws Exception{
		try {
			GameFactory gf = new GameFactory();
			Game game = gf.fetchGame(gameId);
			return game;
		} catch (Exception e) {
			throw new Exception ("We had a problem getting the game. " + e.getMessage());
		}
	}
	private Hearth fetchHearth(String hearthName, Game game) throws Exception {
		//HearthFactory hf = new HearthFactory();
		Hearth hearth = new Hearth();
		hearth.setName(hearthName);
		hearth.setHousenumber(37);
		hearth.setGame(game);
		hearth.save();
		return hearth;
	}
	private void createHearthMembers(Game game, Hearth hearth, Integer pcAdults, Integer npcAdults, Integer numChildren) throws Exception{
		RoleFactory rf = new RoleFactory();
		Role man = rf.fetchRole(Role.MAN);
		Role woman = rf.fetchRole(Role.WOMAN);
	
		String familyName = hearth.getName();
		for (Integer pcCount = 0; pcCount < pcAdults; pcCount ++){
			PlayerChar pc = new PlayerChar();
			pc.setAvatarBody(1);
			pc.setFamilyName(familyName);
			pc.setGame(game);
			pc.setHearth(hearth);
			pc.setName("pc" + pcCount.toString());
			pc.setRole(man);
			pc.setSocialStatus(0);
			pc.save();
		}
		for (Integer npcaCount = 0; npcaCount<npcAdults; npcaCount ++){
			NPC npc = new NPC();
			npc.setAge(24);
			npc.setFamilyName(familyName);
			npc.setHearth(hearth);
			npc.setName("npca" + npcaCount.toString());
			npc.setRole(woman);
			npc.setSchool(0);
			npc.save();
		}
		for (Integer npccCount = 0; npccCount<numChildren; npccCount ++){
			NPC npcc = new NPC();
			npcc.setAge(9);
			npcc.setFamilyName(familyName);
			npcc.setHearth(hearth);
			npcc.setName("npcc" + npccCount.toString());
			npcc.setRole(man);
			npcc.setSchool(0);
			npcc.save();
		}
	}
}
