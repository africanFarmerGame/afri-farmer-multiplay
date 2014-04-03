package uk.ac.sussex.gameEvents;

import java.util.Iterator;
import java.util.Set;

import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.NPC;
import uk.ac.sussex.model.NPCFactory;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.SeasonNotificationFactory;
import uk.ac.sussex.model.game.Game;

public class AfriHearthAllocationEvent extends GameEvent {

	public AfriHearthAllocationEvent(Game game) {
		super(game);
	}

	@Override
	public void fireEvent() throws Exception {
		HearthFactory hf = new HearthFactory();
		Integer numPlayerChars = game.getMaxPlayers() - 1; //Subtract the banker. 
		//Calculate the number of households - maybe this should be on the hearth factory, so it generates the right number.
		Integer gameFamilySize = game.getHouseholdSize();
		double totalFamilies = Math.floor(numPlayerChars/gameFamilySize);
		Set<Hearth> newHearths = null;
		try{
			newHearths = hf.createHearths(totalFamilies, this.game);
		} catch (Exception e){
			throw new Exception("Problem creating families: " + e.getMessage());
		}
		PlayerCharFactory pcf = new PlayerCharFactory();
		Set<PlayerChar> women = pcf.fetchWomen(this.game);
		double numWomen = women.size();
		//Assign the players to households
		Iterator<PlayerChar> itWomen = women.iterator();
		Integer household = 0;
		Integer oversizedFamilies = (int) (numWomen%totalFamilies);
		
		for(Hearth hearth: newHearths){
			Integer familyMembers = 0;
			String hearthName = hearth.getName();
			
			Integer familySize = gameFamilySize - 1; //Subtracting one for the missing man!
			if(household<oversizedFamilies){
				familySize ++;
			}
			while(familyMembers<familySize&&itWomen.hasNext()){
				PlayerChar woman = itWomen.next();
				woman.setHearth(hearth);
				woman.setFamilyName(hearthName);
				woman.save();
				//At this point, also need to check the name of any children. 
				if(woman.getBabyCount()>0){
					NPCFactory npcf = new NPCFactory();
					Set<NPC> babies = npcf.fetchPCBabies(woman);
					for (NPC baby: babies){
						baby.setFamilyName(hearthName);
						baby.save();
					}
				}
				familyMembers++;
			}
			household++;
		}
	}

	@Override
	public void generateNotifications() throws Exception {
		Set<Hearth> hearths = game.fetchHearths();
		PlayerCharFactory pcf = new PlayerCharFactory();
		SeasonNotificationFactory snf = new SeasonNotificationFactory();
		
		for(Hearth hearth: hearths){
			Set<PlayerChar> pcs = pcf.fetchHearthPCs(hearth);
			String notification = "Household Allocation: \n";
			notification += "You have been allocated to the " + hearth.getName() + " household.";
			snf.updateSeasonNotifications(notification, pcs);
		}
		
		String bankerNote = "HouseholdAllocation: \n";
		bankerNote += "The women have successfully been allocated between " + hearths.size() + " hearths.";
		snf.updateBankerNotifications(bankerNote, game);
	}

}
