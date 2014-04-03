package uk.ac.sussex.model.grading;

import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.utilities.Logger;

public class CoreLivingHearthMembersCriterion extends GradingCriterion {
	public static String TYPE = "CORETOTALHEARTH";
	public CoreLivingHearthMembersCriterion(){
		super();
		this.setType(TYPE);
	}
	/* (non-Javadoc)
	 * @see uk.ac.sussex.model.grading.ICriterion#calculateValue(uk.ac.sussex.model.PlayerChar)
	 * This criterion stores the total number of living household members in a year. 
	 */
	@Override
	public void calculateValue(PlayerChar pc, Integer gameYear) {
		HearthFactory hf = new HearthFactory();
		PlayerCharFactory pcf = new PlayerCharFactory();
		NPCFactory npcf = new NPCFactory();
		Double totalLiving = 0.0;
		if(pc.getHearth()!=null){
			Hearth hearth = null;
			try {
				hearth = hf.fetchHearth(pc.getHearth().getId());
			} catch (Exception e) {
				Logger.ErrorLog("CoreLivingHearthMembersCriterion.calculateValue", "Problem fetching the hearth for pc " + pc.getId() + ": " + e.getMessage());
				return;
			}
			try {
				Set<PlayerChar> pcs = pcf.fetchHearthPCs(hearth);
				for (PlayerChar pc1: pcs){
					if(!pc1.getAlive().equals(AllChars.DEAD)){
						totalLiving++;
					}
					if(pc1.getBabyCount()>0){
						Set<NPC> babies = npcf.fetchPCBabies(pc1);
						for (NPC baby: babies){
							if(!baby.getAlive().equals(AllChars.DEAD)){
								totalLiving ++;
							}
						}
					}
				}
			} catch (Exception e) {
				Logger.ErrorLog("CoreLivingHearthMembersCriterion.calculateValue", "Problem with the player chars in hearth " + hearth.getId() + ": " + e.getMessage());
			}
			try {
				Set<NPC> npcs = npcf.fetchHearthChildren(hearth);
				for(NPC hearthmember: npcs){
					if(!hearthmember.getAlive().equals(AllChars.DEAD)){
						totalLiving ++;
						if(hearthmember.getBabyCount()>0){
							Set<NPC> babies = npcf.fetchNPCBabies(hearthmember);
							for (NPC baby: babies){
								if(!baby.getAlive().equals(AllChars.DEAD)){
									totalLiving++;
								}
							}
						}
					}
				}
			} catch (Exception e) {
				Logger.ErrorLog("CoreLivingHearthMembersCriterion.calculateValue", "Problem with the npcs in hearth " + hearth.getId() + ": " + e.getMessage());
			}
			CoreLivingHearthMembersCriterion clhmc = new CoreLivingHearthMembersCriterion();
			clhmc.setGameYear(gameYear);
			clhmc.setHearth(hearth);
			clhmc.setPc(pc);
			clhmc.setValue(totalLiving);
			try {
				clhmc.save();
			} catch(Exception e){
				Logger.ErrorLog("CoreLivingHearthMembersCriterion.calculateValue", "Problem saving the total living.");
			}
		}
	}
	/* (non-Javadoc)
	 * @see uk.ac.sussex.model.grading.ICriterion#displayYearEndOutput(uk.ac.sussex.model.PlayerChar, java.lang.Integer)
	 */
	@Override
	public String displayYearEndOutput(PlayerChar pc, Integer gameYear) {
		String returnString = "";
		GradingCriterionFactory gcf = new GradingCriterionFactory();
		try {
			GradingCriterion gc = gcf.fetchSpecificAnnualCriterion(TYPE, pc, gameYear);
			returnString = "Your household currently has " + gc.getValue().intValue() + " living members.";
		} catch (Exception e) {
			Logger.ErrorLog("CoreLivingHearthMembersCriterion.displayYearEndOutput", "Problem generating output for pc " +pc.getId() + ": " + e.getMessage());
		}
		
		return returnString;
	}
	
	@Override
	public String displayFinalReckoning(PlayerChar pc) {
		String returnString = "";
		GradingCriterionFactory gcf = new GradingCriterionFactory();
		List<GradingCriterion> livingCriteria = null;
		try {
			livingCriteria = gcf.fetchAllSpecificCriterion(TYPE, pc);
		} catch (Exception e) {
			Logger.ErrorLog("CoreLivingHearthMembersCriterion.displayFinalReckoning", "Problem fetching criteria for pc " + pc.getId() + ": " + e.getMessage());
		}
		if(livingCriteria!=null){
			GameFactory gf = new GameFactory();
			Game game = null;
			try {
				game = gf.fetchGame(pc.getGame().getId());
			} catch (Exception e) {
				Logger.ErrorLog("CoreLivingHearthMembersCriterion.displayFinalReckoning", "There was a problem fetching the game for pc " + pc.getId() + ": " + e.getMessage());
				return returnString;
			}
			Integer maxGameYear = game.getGameYear();
			Integer hearthId = 0;
			
			HearthFactory hearthFactory = new HearthFactory();
			Hearth hearth = null;
			
			//TODO this only works if they stay in the same household!
			//The criteria should be in ascending gamezone order, so we'll try that. 
			Double firstSize = 0.0;
			Double lastSize = 0.0;
			
			returnString = "Household members:\n";
			for(Integer gameYear = 0 ; gameYear<maxGameYear ; gameYear++){
				GradingCriterion lhm = livingCriteria.get(gameYear);
				if(!lhm.getHearth().getId().equals(hearthId)){
					
					if(hearth!=null){
						returnString += addTextBlurb(firstSize, lastSize, hearth.getName() + "\n");
					}
					try {
						hearth = hearthFactory.fetchHearth(lhm.getHearth().getId());
					} catch( Exception e) {
						Logger.ErrorLog("CoreLivingHearthMembersCriterion.displayFinalReckoning", "Problem getting hearth for pc " + pc.getId() + " in game year " + gameYear + ": " + e.getMessage());
					}
					firstSize = lhm.getValue();
				}
				lastSize = lhm.getValue();
				
			}
			returnString += addTextBlurb(firstSize, lastSize, hearth.getName() + "\n");
		}
		return returnString;
	}
	private String addTextBlurb(Double firstSize, Double lastSize, String hearthName) {
		String returnString = "When you started in household " + hearthName + " there were " + firstSize.intValue() + " members and you ended up with " + lastSize.intValue();
		return returnString;
	}
}
