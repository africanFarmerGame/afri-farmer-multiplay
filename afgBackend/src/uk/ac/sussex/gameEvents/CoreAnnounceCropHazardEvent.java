package uk.ac.sussex.gameEvents;

import java.util.Iterator;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.utilities.Logger;

public class CoreAnnounceCropHazardEvent extends GameEvent {
	private List<CropHazard> cropHazards;
	private Integer maxProbability=0;
	private SeasonDetail currentSeason;
	
	public CoreAnnounceCropHazardEvent(Game game) {
		super(game);
	}

	@Override
	public void fireEvent() throws Exception {
		//First decide whether each household gets hit or not. 
		HearthFactory hf = new HearthFactory();
		currentSeason = game.getCurrentSeasonDetail();
		Set<Hearth> hearths = hf.fetchGameHearths(game);
		for (Hearth hearth : hearths){
			if(Math.random()<0.7){
				CropHazard hazard = generateCropHazard();
				applyHazard(hearth, hazard);
			} else {
				Logger.Log("Auto", "Hearth " + hearth.getId() + " had no crop hazard this season.");
			}
		}
	}
	private CropHazard generateCropHazard() throws Exception{
		//Need to decide which crop hazard they get.
		if(cropHazards==null){
			HazardFactory hazardFactory = new HazardFactory();
			cropHazards = hazardFactory.fetchCropHazards();
			for(CropHazard ch: cropHazards){
				maxProbability += ch.getProbability();
			}
		}
		Integer hazardProbability = (int) Math.floor(Math.random() * maxProbability);
		Iterator<CropHazard> iterator = cropHazards.iterator();
		Integer upperBound = 0;
		Integer lowerBound = 0;
		CropHazard chosenHazard = null;
		Boolean found = false;
		while(iterator.hasNext() && !found){
			chosenHazard = iterator.next();
			lowerBound = upperBound;
			upperBound += chosenHazard.getProbability();
			found = ((upperBound>hazardProbability)&&(lowerBound<=hazardProbability));
		}
		return chosenHazard;
	}
	private void applyHazard(Hearth household, CropHazard hazard) throws Exception{
		FieldFactory ff = new FieldFactory();
		List<Field> fields = ff.getHearthFields(household);
		HazardFactory hazardFactory = new HazardFactory();
		
		for(Field field: fields){
			Asset crop = field.getCrop();
			if(crop != null){
				//Limit the crop hazards to the middle growth period, or there's a risk of being unable to mitigate before harvest.
				if(field.getCropAge().equals(1)){
					//I need to get the CropHazardEffect. 
					CropHazardEffect effect = hazardFactory.fetchCropHazardEffect(hazard, crop, field.getCropPlanting(), field.getCropAge());
					if(effect!=null){
						//Unlucky!
						FieldHazardHistory fhh = new FieldHazardHistory();
						fhh.setCropHazardEffect(effect);
						fhh.setField(field);
						fhh.setMitigated(0);
						fhh.setSeasonDetail(currentSeason);
						fhh.save();
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
		FieldFactory fieldfactory = new FieldFactory(); 
		HazardFactory hazardFactory = new HazardFactory();
		String gmNotification = "";
		int totalHazards = 0;
		int totalPlanted = 0;
		for(Hearth hearth: hearths){
			Set<PlayerChar> pcs = pcf.fetchHearthPCs(hearth);
			String notification = "Crop Hazards: \n";
			List<Field> fields = fieldfactory.getHearthFields(hearth);
			int plantedFields = 0;
			int hearthHazards = 0;
			for(Field field: fields){
				if(field.getCrop()!=null){
					plantedFields ++;
					FieldHazardHistory fhh = hazardFactory.fetchCurrentFieldHazard(field, currentSeason);
					if(fhh!=null){
						hearthHazards ++;
						CropHazardEffect effect = hazardFactory.fetchCropHazardEffect(fhh.getCropHazardEffect().getId());
						CropHazard hazard = hazardFactory.fetchCropHazard(effect.getCropHazard().getId());
						notification += field.getName() + " has an outbreak of " + hazard.getName() + "\n";
						hearthHazards ++;
					} else {
						notification += field.getName() + " has no crop hazards this season.\n";
					}
				}
			}
			gmNotification += "Household " + hearth.getName();
			if(plantedFields==0){
				gmNotification += " has no planted fields at this time.\n";
			} else if(hearthHazards==0) {
				gmNotification += " has " + plantedFields + " fields planted and no hazards.\n";
			} else {
				gmNotification += " has " + plantedFields + " fields planted, " + hearthHazards + " have crop hazards.\n";
			}
			totalHazards += hearthHazards;
			totalPlanted += plantedFields;
			snf.updateSeasonNotifications(notification, pcs);
		}
		String gmFinalNote = "Crop Hazards:\n";
		if(totalPlanted == 0){
			gmFinalNote += "None of the fields in your village are planted at the moment.\n";
		} else if (totalHazards==0) {
			gmFinalNote += "Your village has " + totalPlanted + " fields planted, and all are healthy.\n";
		} else {
			gmFinalNote += "Your village has " + totalPlanted + " fields planted, and " + totalHazards + " have hazards - \n "+ gmNotification;
		}
		snf.updateBankerNotifications(gmFinalNote, game);
	}
}
