/**
 * 
 */
package uk.ac.sussex.model.grading;

import java.util.List;

import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.Role;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.utilities.Logger;

/**
 * @author eam31
 *
 */
public class AfriDietCriteria extends GradingCriteria {
	public AfriDietCriteria() {
		this.addCriterion(new CoreDietACriterion());
		this.addCriterion(new CoreDietBCriterion());
		this.addCriterion(new CoreDietCCriterion());
		this.addCriterion(new CoreDietXCriterion());
	}
	/* (non-Javadoc)
	 * @see uk.ac.sussex.model.grading.ICriterion#calculateValue(uk.ac.sussex.model.PlayerChar)
	 */
	@Override
	public void calculateValue(PlayerChar pc, Integer gameYear) {
		if(pc.getRole().getId().equals(Role.WOMAN)){
			super.calculateValue(pc, gameYear);
		}
	}
	/* (non-Javadoc)
	 * @see uk.ac.sussex.model.grading.ICriterion#displayYearEndOutput(uk.ac.sussex.model.PlayerChar, java.lang.Integer)
	 */
	@Override
	public String displayYearEndOutput(PlayerChar pc, Integer gameYear) {
		String returnString = "";
		GradingCriterionFactory gcf = new GradingCriterionFactory();
		GradingCriterion aDiet = null;
		GradingCriterion bDiet = null;
		GradingCriterion cDiet = null;
		GradingCriterion xDiet = null;
		try {
			aDiet = gcf.fetchSpecificAnnualCriterion(CoreDietACriterion.TYPE, pc, gameYear);
			bDiet = gcf.fetchSpecificAnnualCriterion(CoreDietBCriterion.TYPE, pc, gameYear);
			cDiet = gcf.fetchSpecificAnnualCriterion(CoreDietCCriterion.TYPE, pc, gameYear);
			xDiet = gcf.fetchSpecificAnnualCriterion(CoreDietXCriterion.TYPE, pc, gameYear);
			returnString = "You have " + aDiet.getValue().intValue() + " family members on a top-notch A diet, " 
				+ bDiet.getValue().intValue() + " on a B diet, and " + cDiet.getValue().intValue() + " family members on a poor C diet.";
			if(xDiet.getValue()>0){
				returnString = "\nSadly, since the start of the game this household has failed to provide enough food for " + xDiet.getValue().intValue() + " members to survive.";
			}
		} catch (Exception e) {
			Logger.ErrorLog("AfriDietCriteria.displayYearEndOutput", "Problem generating diet info for pc " + pc.getId() + ": " + e.getMessage());
		}
		
		return returnString;
	}
	@Override
	public String displayFinalReckoning(PlayerChar pc) {
		String returnString = "Dietary overview:\n";
		GradingCriterionFactory gcf = new GradingCriterionFactory();
		List<GradingCriterion> dietACriteria = null;
		List<GradingCriterion> dietBCriteria = null;
		List<GradingCriterion> dietCCriteria = null;
		List<GradingCriterion> dietXCriteria = null;
		try {
			dietACriteria = gcf.fetchAllSpecificCriterion(CoreDietACriterion.TYPE, pc);
			dietBCriteria = gcf.fetchAllSpecificCriterion(CoreDietBCriterion.TYPE, pc);
			dietCCriteria = gcf.fetchAllSpecificCriterion(CoreDietCCriterion.TYPE, pc);
			dietXCriteria = gcf.fetchAllSpecificCriterion(CoreDietXCriterion.TYPE, pc);
		} catch (Exception e) {
			Logger.ErrorLog("AfriDietCriteria.displayFinalReckoning", "There's been a problem fetching the relevent criteria for pc " + pc.getId() + ": " + e.getMessage());
			return returnString;
		}
		GameFactory gf = new GameFactory();
		Game game = null;
		try {
			game = gf.fetchGame(pc.getGame().getId());
		} catch (Exception e) {
			Logger.ErrorLog("AfriDietCriteria.displayFinalReckoning", "There was a problem fetching the game for pc " + pc.getId() + ": " + e.getMessage());
			return returnString;
		}
		Integer maxGameYear = game.getGameYear();
		Integer hearthId = 0;
		
		HearthFactory hearthFactory = new HearthFactory();
		Hearth hearth = null;
		for (Integer gameYear = 0; gameYear<maxGameYear; gameYear++){
			GradingCriterion dietACriterion = fetchGameYearCriterion(dietACriteria, gameYear);
			GradingCriterion dietBCriterion = fetchGameYearCriterion(dietBCriteria, gameYear);
			GradingCriterion dietCCriterion = fetchGameYearCriterion(dietCCriteria, gameYear);
			GradingCriterion dietXCriterion = fetchGameYearCriterion(dietXCriteria, gameYear);
			if(dietACriterion == null||dietBCriterion == null||dietCCriterion == null||dietXCriterion == null){
				returnString += "The data for year " + gameYear + " is incomplete.\n";
			} else {
				if(!dietACriterion.getHearth().getId().equals(hearthId)){
					try {
						hearthId = dietACriterion.getHearth().getId();
						hearth = hearthFactory.fetchHearth(hearthId);
						returnString += "Data for membership of household " + hearth.getName() + ":\n";
					} catch (Exception e) {
						Logger.ErrorLog("AfriDietCriteria.displayFinalReckoning", 
								        "Issue fetching the hearth for pc " + pc.getId() + "in gameYear" + gameYear + ": " + e.getMessage());
					}
					returnString += padRight("Game Year", 12) + padRight("A Diets", 13) + padRight("B Diets", 13) + padRight("C Diets",12) + "X Diets\n";
				}
				returnString += padRight("   " + gameYear, 24) 
							+ padRight("   " + dietACriterion.getValue().intValue(), 18)  
							+ padRight("   " + dietBCriterion.getValue().intValue(), 18)  
							+ padRight("   " + dietCCriterion.getValue().intValue(), 18) 
							+ "   " + dietXCriterion.getValue().intValue() + " \n";
			}
		}
		return returnString;
	}
}
