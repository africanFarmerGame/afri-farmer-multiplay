package uk.ac.sussex.model.grading;

import java.util.Set;

import uk.ac.sussex.model.DietaryLevels;
import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.NPC;
import uk.ac.sussex.model.NPCFactory;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.utilities.Logger;

public class CoreDietCCriterion extends GradingCriterion {
	public static String TYPE = "COREDIETC";
	
	public CoreDietCCriterion(){
		super();
		this.setType(TYPE);
	}
	/* (non-Javadoc)
	 * @see uk.ac.sussex.model.grading.ICriterion#calculateValue(uk.ac.sussex.model.PlayerChar)
	 */
	@Override
	public void calculateValue(PlayerChar pc, Integer gameYear) {
		CoreDietCCriterion cdcc = new CoreDietCCriterion();
		HearthFactory hf = new HearthFactory();
		PlayerCharFactory pcf = new PlayerCharFactory();
		NPCFactory npcf = new NPCFactory();
		Double totalC = 0.0;
		String dietaryLevelC = DietaryLevels.C.toString();
		if(pc.getHearth()!=null){
			Hearth hearth = null;
			try {
				hearth = hf.fetchHearth(pc.getHearth().getId());
			} catch (Exception e) {
				Logger.ErrorLog("CoreDietCCriterion.calculateValue", "Problem fetching the hearth for pc " + pc.getId() + ": " + e.getMessage());
				return;
			}
			try {
				Set<PlayerChar> pcs = pcf.fetchHearthPCs(hearth);
				for (PlayerChar pc1: pcs){
					if(pc1.getDiet().equals(dietaryLevelC)){
						totalC++;
					}
					if(pc1.getBabyCount()>0){
						Set<NPC> babies = npcf.fetchPCBabies(pc1);
						for (NPC baby: babies){
							if(baby.getDiet().equals(dietaryLevelC)){
								totalC ++;
							}
						}
					}
				}
			} catch (Exception e) {
				Logger.ErrorLog("CoreDietCCriterion.calculateValue", "Problem with the player chars in hearth " + hearth.getId() + ": " + e.getMessage());
			}
			try {
				Set<NPC> npcs = npcf.fetchHearthChildren(hearth);
				for(NPC hearthmember: npcs){
					if(hearthmember.getDiet().equals(dietaryLevelC)){
						totalC ++;
						if(hearthmember.getBabyCount()>0){
							Set<NPC> babies = npcf.fetchNPCBabies(hearthmember);
							for (NPC baby: babies){
								if(baby.getDiet().equals(dietaryLevelC)){
									totalC++;
								}
							}
						}
					}
				}
			} catch (Exception e) {
				Logger.ErrorLog("CoreDietCCriterion.calculateValue", "Problem with the npcs in hearth " + hearth.getId() + ": " + e.getMessage());
			}
			cdcc.setGameYear(gameYear);
			cdcc.setHearth(hearth);
			cdcc.setPc(pc);
			cdcc.setValue(totalC);
			try {
				cdcc.save();
			} catch(Exception e){
				Logger.ErrorLog("CoreDietCCriterion.calculateValue", "Problem saving the total on C diet.");
			}
		}
	}
}
