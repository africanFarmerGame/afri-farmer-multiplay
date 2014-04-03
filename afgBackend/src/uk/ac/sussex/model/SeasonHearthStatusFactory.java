/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.base.BaseFactory;

public class SeasonHearthStatusFactory extends BaseFactory {
	public SeasonHearthStatusFactory() {
		super(new SeasonHearthStatus());
	}
	public void generateSeasonHearthStatus(Hearth hearth, SeasonDetail sd) throws Exception {
		SeasonHearthStatus shs = new SeasonHearthStatus();
		shs.setHearth(hearth);
		shs.setSeason(sd);
		
		FieldFactory ff = new FieldFactory();
		List<Field> hearthFields = ff.getHearthFields(hearth);
		shs.setNumFields(hearthFields.size());
		
		Integer totalMembers = 0;
		Integer livingMembers = 0;
		Integer totalAdults = 0;
		Integer totalPCs = 0; // I *think* this is more useful. We'll see. 
		Integer deadMembers = 0;
			
		PlayerCharFactory pcf = new PlayerCharFactory();
		NPCFactory npcf = new NPCFactory();
		
		Set<PlayerChar> pcs = pcf.fetchHearthPCs(hearth);
		for(PlayerChar pc: pcs ) {
			totalMembers ++;
			totalPCs ++;
			totalAdults ++;
			if(pc.getAlive().equals(AllChars.DEAD)){
				deadMembers ++;
			} else {
				livingMembers ++;
			}
			if(pc.getBabyCount()>0){
				//Check for babies.
				Set<NPC> babies = npcf.fetchPCBabies(pc);
				for(NPC baby: babies){
					totalMembers ++;
					if(baby.getAlive().equals(AllChars.DEAD)){
						deadMembers++;
					} else {
						livingMembers++;
					}
				}
			}
		}
		
		Set<NPC> npcs = npcf.fetchHearthChildren(hearth);
		for (NPC npc: npcs) {
			totalMembers ++;
			if(npc.isAdult()){
				totalAdults++;
			}
			if(npc.getAlive().equals(AllChars.DEAD)){
				deadMembers ++;
			} else {
				livingMembers ++;
			}
			if(npc.getBabyCount()>0){
				//Check for babies.
				Set<NPC> babies = npcf.fetchNPCBabies(npc);
				for(NPC baby: babies){
					totalMembers ++;
					if(baby.getAlive().equals(AllChars.DEAD)){
						deadMembers++;
					} else {
						livingMembers++;
					}
				}
			}
		}
		
		shs.setDeadFamily(deadMembers);
		shs.setLivingFamily(livingMembers);
		shs.setNumPCs(totalPCs);
		shs.setTotalAdults(totalAdults);
		shs.setTotalFamily(totalMembers);
		shs.save();
	}
}
