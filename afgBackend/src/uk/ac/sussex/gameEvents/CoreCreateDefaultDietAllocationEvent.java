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
