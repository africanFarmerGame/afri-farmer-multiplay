/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.gameEvents;

import java.util.Set;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;

public class CoreAgeCharactersEvent extends GameEvent {

	public CoreAgeCharactersEvent(Game game) {
		super(game);
	}

	@Override
	public void fireEvent() throws Exception {
		// Need to age the NPCs. 
		HearthFactory hf = new HearthFactory();
		Set<Hearth> hearths = hf.fetchGameHearths(game);
		NPCFactory npcFactory = new NPCFactory();
		PlayerCharFactory pcFactory = new PlayerCharFactory();
		for(Hearth hearth: hearths){
			Set<NPC> npcs = npcFactory.fetchHearthChildren(hearth);
			for(NPC npc : npcs ){
				if(!npc.getAlive().equals(AllChars.DEAD)){
					Integer currentAge = npc.getAge();
					npc.setAge(currentAge + 1);
					npc.save();
				}
				if(npc.getRole().getId().equals(Role.WOMAN)){
					Set<NPC> babies = npcFactory.fetchNPCBabies(npc);
					for(NPC baby: babies){
						if(!baby.getAlive().equals(AllChars.DEAD)){
							Integer newAge = baby.getAge() + 1;
							baby.setAge(newAge);
							if(newAge > NPC.CHILD_AGE){
								baby.setParent(null);
								baby.setHearth(hearth);
							}
							baby.save();
						}
					}
				}
			}
			Set<PlayerChar> pcs = pcFactory.fetchHearthPCs(hearth);
			for(PlayerChar pc : pcs){
				Set<NPC> babies = npcFactory.fetchPCBabies(pc);
				for(NPC baby : babies){
					if(!baby.getAlive().equals(AllChars.DEAD)){
						Integer newAge = baby.getAge() + 1;
						baby.setAge(newAge);
						if(newAge > NPC.CHILD_AGE){
							baby.setParent(null);
							baby.setHearth(hearth);
						}
						baby.save();
					}
				}
			}
		}

	}

	@Override
	public void generateNotifications() throws Exception {
		Set<Hearth> hearths = game.fetchHearths();
		PlayerCharFactory pcf = new PlayerCharFactory();
		NPCFactory npcf = new NPCFactory();
		SeasonNotificationFactory snf = new SeasonNotificationFactory();
		
		for (Hearth hearth: hearths){
			Set<PlayerChar> playerChars = pcf.fetchHearthPCs(hearth);
			String notification = "Aging:\n";
			notification += "All household members are 1 year older.\n";
			Set<NPC> npcs = npcf.fetchHearthChildren(hearth);
			for (NPC npc: npcs){
				if(!npc.getAlive().equals(NPC.DEAD)){
					Integer npcAge = npc.getAge();
					if(npcAge.equals(NPC.CHILD_AGE + 1)){
						notification += npc.getDisplayName() + " is no longer a baby.\n";
					} else if (npcAge.equals(NPC.ADULT_AGE)){
						notification += npc.getDisplayName() + " is no longer a child.\n";
					}
				}
			}
			snf.updateSeasonNotifications(notification, playerChars);
		}
		snf.updateBankerNotifications("Aging:\nAll living villagers are 1 year older.", game);
	}

}
