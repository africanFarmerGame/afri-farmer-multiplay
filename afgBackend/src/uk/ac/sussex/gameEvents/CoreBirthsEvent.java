package uk.ac.sussex.gameEvents;

//import java.util.ArrayList;
import java.util.Set;

import uk.ac.sussex.model.*;
//import uk.ac.sussex.utilities.NameGenerator;
import uk.ac.sussex.model.game.Game;

public class CoreBirthsEvent extends GameEvent {

	public CoreBirthsEvent(Game game) {
		super(game);
	}

	@Override
	public void fireEvent() throws Exception {
		PlayerCharFactory pcf = new PlayerCharFactory();
		
		Set<PlayerChar> pcwomen = pcf.fetchWomen(game);
		for(PlayerChar woman: pcwomen){
			generateBaby(woman);
		}
		NPCFactory npcf = new NPCFactory();
		HearthFactory hf = new HearthFactory();
		Set<Hearth> hearths = hf.fetchGameHearths(game);
		for(Hearth hearth: hearths){
			Set<NPC> hearthWomen = npcf.fetchHearthWomen(hearth);
			for(NPC hearthwoman: hearthWomen){
				generateBaby(hearthwoman);
			}
		}
	}
	private void generateBaby(AllChars woman) throws Exception{
		if(woman.getAlive().equals(AllChars.ALIVE)){
			//RoleFactory roleFactory = new RoleFactory();
			
			if(Math.random()<0.33){
				//We have a winner. 
				NPCFactory npcFactory = new NPCFactory();
				NPC baby = npcFactory.createBaby(woman);
				baby.setAge(0);
				baby.save();
			}
		}
	}

	@Override
	public void generateNotifications() throws Exception {
		Set<Hearth> hearths = game.fetchHearths();
		PlayerCharFactory pcf = new PlayerCharFactory();
		NPCFactory npcf = new NPCFactory();
		SeasonNotificationFactory snf = new SeasonNotificationFactory();
		int gameBabyCount = 0;
		String gmNotification = "";
		for(Hearth hearth: hearths){
			String notification = "New Births:\n";
			int babyCount = 0;
			Set<PlayerChar> pcs = pcf.fetchHearthPCs(hearth);
			for(PlayerChar pc : pcs){
				if(pc.getBabyCount()>0){
					Set<NPC> babies = npcf.fetchPCBabies(pc);
					for(NPC baby : babies){
						if(baby.getAge().equals(0)&&!baby.getAlive().equals(AllChars.DEAD)){
							babyCount++;
							notification += pc.getDisplayName() + " had a new baby - " + baby.getName() + " \n";
						}
					}
				}
			}
			Set<NPC> npcs = npcf.fetchHearthChildren(hearth);
			for(NPC npc: npcs){
				if(npc.getBabyCount()>0){
					Set<NPC> babies = npcf.fetchNPCBabies(npc);
					for(NPC baby: babies){
						if(baby.getAge().equals(0)&&!baby.getAlive().equals(AllChars.DEAD)){
							babyCount++;
							notification += npc.getDisplayName() + " had a new baby - " + baby.getName() + " \n";
						}
					}
				}
			}
			if(babyCount==0){
				notification += "Your household members have not had any new babies this year. \n";
				gmNotification += "Household " + hearth.getName() + " has not had any babies this year. \n";
			} else {
				notification = notification + "Congratulations!";
				gmNotification += "Household " + hearth.getName() + " have had " + babyCount + " new births.\n";
			}
			gameBabyCount += babyCount;
			snf.updateSeasonNotifications(notification, pcs);
		}
		snf.updateBankerNotifications("New Births:\nThere were " + gameBabyCount + " new births in the village.\n" + gmNotification, game);
	}
}
