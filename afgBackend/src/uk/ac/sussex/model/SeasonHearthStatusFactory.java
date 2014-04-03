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
