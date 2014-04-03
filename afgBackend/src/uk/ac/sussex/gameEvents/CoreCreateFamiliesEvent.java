package uk.ac.sussex.gameEvents;

import java.util.Iterator;
import java.util.Set;

import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.NPCFactory;
import uk.ac.sussex.model.SeasonNotificationFactory;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.village.Village;
import uk.ac.sussex.model.village.VillageFamilies;
import uk.ac.sussex.model.village.VillageFamily;

public class CoreCreateFamiliesEvent extends GameEvent {

	public CoreCreateFamiliesEvent(Game game) {
		super(game);
	}

	@Override
	public void fireEvent() throws Exception {
		//Assign family members
		NPCFactory npc = new NPCFactory();
		Village village = game.fetchVillageType();
		Set<Hearth> hearths = game.fetchHearths();
		int numberOfFamilies = hearths.size();
		if(numberOfFamilies < village.getMinFamilies()){
			throw new Exception("There are not enough hearths in this game: " + numberOfFamilies);
		} else if (numberOfFamilies > village.getMaxFamilies()) {
			throw new Exception("There are too many hearths in this game: " + numberOfFamilies);
		}
		VillageFamilies families = village.getFamilies(numberOfFamilies);
		
		Iterator<VillageFamily> itFamilies = families.getIterator();
		Iterator<Hearth> itHearth = hearths.iterator();
		while(itHearth.hasNext() && itFamilies.hasNext()){
			Hearth hearth = itHearth.next();
			VillageFamily family = itFamilies.next();
			int numFamilyMembers = family.getTotalSize();
			int currentAdults = hearth.getCharacters().size();
			int maxAdults = family.getNumAdults();
			int currentBabies = hearth.fetchNumberOfChildren();
			for(int j=currentAdults; j<numFamilyMembers-currentBabies; j++){
				if(j<maxAdults){
					npc.createAdult(hearth);
				} else {
					npc.createChild(hearth);
				}
			}
		}
	}

	@Override
	public void generateNotifications() throws Exception {
		String notification = "Family creation: \n";
		notification += "We have created a village for you.";
		SeasonNotificationFactory snf = new SeasonNotificationFactory();
		snf.updateBankerNotifications(notification, game);
	}

}
