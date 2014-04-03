/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.gameEventsTest;

import static org.junit.Assert.*;

import java.util.Set;

import org.junit.Test;

import uk.ac.sussex.gameEvents.CoreAgeCharactersEvent;
import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

public class CoreAgeCharactersEventTest {

	@SuppressWarnings("unused")
	@Test
	public void testFireEvent() {
		//Need a hearth, a bunch of NPCs, and a PC with babies. 
		GameFactory gf = new GameFactory();
		Game game = null;
		try {
			game = gf.fetchGame(1);
		} catch (Exception e) {
			e.printStackTrace();
			fail("can't get the game.");
		}
		
		Hearth testHearth = createHearth(game, "AgedCharsHearth");
		NPC adult = createNPC(testHearth, "TestAgeAdult", 14);
		PlayerChar pc = createPlayerChar(game, testHearth, "TestAgePC");
		NPC baby = createBaby(pc, "TestAgeBaby", 7);
		NPC baby2 = createBaby(pc, "TestAgeBaby2", 2);
		CoreAgeCharactersEvent cace = new CoreAgeCharactersEvent(game);
		try {
			cace.fireEvent();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Error firing the event");
		}
		NPCFactory npcFactory = new NPCFactory();
		Set<NPC> children = null;
		try {
			children = npcFactory.fetchHearthChildren(testHearth);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get the hearth children.");
		}
		assertNotNull(children);
		assertEquals(2, children.size());
		for (NPC child: children){
			assertNull(child.getParent());
		}
	}

	private Hearth createHearth(Game game, String hearthName) {
		Hearth hearth = new Hearth();
		hearth.setGame(game);
		hearth.setName(hearthName);
		hearth.setHousenumber(1);
		try {
			hearth.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem creating hearth " + hearthName);
		}
		return hearth;
	}
	private PlayerChar createPlayerChar(Game game, Hearth hearth, String firstname) {
		Role role = fetchRandomRole();
		PlayerChar pc = new PlayerChar();
		pc.setGame(game);
		pc.setHearth(hearth);
		pc.setFamilyName("GenericTest");
		pc.setName(firstname);
		pc.setAvatarBody(1);
		pc.setRole(role);
		pc.setSocialStatus(5);
		try {
			pc.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem saving pc " + firstname);
		}
		return pc;
	}
	private NPC createNPC(Hearth hearth, String firstname, Integer age){
		Role role = fetchRandomRole();
		NPC npc = new NPC();
		npc.setAge(age);
		npc.setFamilyName("GenericTest");
		npc.setName(firstname);
		npc.setHearth(hearth);
		npc.setRole(role);
		try {
			npc.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't save the NPC " + firstname);
		}
		return npc;
	}
	private NPC createBaby(PlayerChar parent, String firstname, Integer age){
		Role role = fetchRandomRole();
		NPC npc = new NPC();
		npc.setAge(age);
		npc.setFamilyName("GenericTest");
		npc.setName(firstname);
		npc.setParent(parent);
		npc.setRole(role);
		try {
			npc.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't save the NPC " + firstname);
		}
		return npc;
	}
	private Role fetchRandomRole(){
		RoleFactory rf = new RoleFactory();
		Role role = null;
		try {
			role = rf.fetchRandomRole();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting a random role");
		}
		return role;
	}
}
