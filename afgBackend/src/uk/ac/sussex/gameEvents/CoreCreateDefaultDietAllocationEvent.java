/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.gameEvents;

import java.util.Set;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;

public class CoreCreateDefaultDietAllocationEvent extends GameEvent {

	public CoreCreateDefaultDietAllocationEvent(Game game) {
		super(game);
	}

	@Override
	public void fireEvent() throws Exception {
		HearthFactory hearthFactory = new HearthFactory();
		Set<Hearth> hearths = hearthFactory.fetchGameHearths(game);
		PlayerCharFactory pcf = new PlayerCharFactory();
		NPCFactory npcf = new NPCFactory();
		AllocationFactory af = new AllocationFactory();
		AllocationItemFactory aif = new AllocationItemFactory();
		for (Hearth hearth: hearths){
			Allocation allocation = af.createOrUpdateAllocation(-1, "Default", 1, hearth, game, 0);

			Set<PlayerChar> pcs = pcf.fetchHearthPCs(hearth);
			for (PlayerChar pc: pcs){
				if(!pc.getAlive().equals(AllChars.DEAD)){
					aif.createAdultAllocationItems(pc, allocation);
				}
				if(pc.getBabyCount()>0){
					Set<NPC> babies = npcf.fetchPCBabies(pc);
					for (NPC baby: babies){
						if(!baby.getAlive().equals(AllChars.DEAD)){
							aif.createChildAllocationItems(baby, allocation);
						}
					}
				}
			}
			Set<NPC> npcs = npcf.fetchHearthChildren(hearth);
			for(NPC hearthmember: npcs){
				if(!hearthmember.getAlive().equals(AllChars.DEAD)){
					if(hearthmember.isAdult()){
						aif.createAdultAllocationItems(hearthmember, allocation);
						if(hearthmember.getBabyCount()>0){
							Set<NPC> babies = npcf.fetchNPCBabies(hearthmember);
							for (NPC baby: babies){
								if(!baby.getAlive().equals(AllChars.DEAD)){
									aif.createChildAllocationItems(baby, allocation);
								}
							}
						}
					} else {
						aif.createChildAllocationItems(hearthmember, allocation);
					}
				}
			}
		}
		
	}

	@Override
	public void generateNotifications() throws Exception {
		Set<Hearth> hearths = game.fetchHearths();
		PlayerCharFactory pcf = new PlayerCharFactory();
		SeasonNotificationFactory snf = new SeasonNotificationFactory();
		
		for(Hearth hearth: hearths){
			Set<PlayerChar> pcs = pcf.fetchHearthPCs(hearth);
			String notification = "A new default diet allocation has been created for your family.";
			snf.updateSeasonNotifications(notification, pcs);
		}
		
		snf.updateBankerNotifications("New Diets:\nNew default diet allocations have been created for all families.", game);
	}
}
