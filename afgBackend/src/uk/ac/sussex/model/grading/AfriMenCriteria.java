package uk.ac.sussex.model.grading;

import java.util.List;

import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.Role;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.utilities.Logger;

public class AfriMenCriteria extends GradingCriteria {
	public AfriMenCriteria() {
		this.addCriterion(new AfriCashCriterion());
		this.addCriterion(new CoreAssetWorthCriterion());
	}
	/* (non-Javadoc)
	 * @see uk.ac.sussex.model.grading.ICriterion#calculateValue(uk.ac.sussex.model.PlayerChar)
	 */
	@Override
	public void calculateValue(PlayerChar pc, Integer gameYear) {
		if(pc.getRole().getId().equals(Role.MAN)){
			super.calculateValue(pc, gameYear);
		}
	}
	@Override
	public String displayFinalReckoning(PlayerChar pc) {
		String returnString = "Financial overview:\n";
		GradingCriterionFactory gcf = new GradingCriterionFactory();
		List<GradingCriterion> cashCriteria = null;
		List<GradingCriterion> assetCriteria = null;
		try {
			cashCriteria = gcf.fetchAllSpecificCriterion(AfriCashCriterion.TYPE, pc);
			assetCriteria = gcf.fetchAllSpecificCriterion(CoreAssetWorthCriterion.TYPE, pc);
		} catch (Exception e) {
			Logger.ErrorLog("AfriMenCriteria.displayFinalReckoning", "There's been a problem fetching the relevent criteria for pc " + pc.getId() + ": " + e.getMessage());
			return returnString;
		}
		GameFactory gf = new GameFactory();
		Game game = null;
		try {
			game = gf.fetchGame(pc.getGame().getId());
		} catch (Exception e) {
			Logger.ErrorLog("AfriMenCriteria.displayFinalReckoning", "There was a problem fetching the game for pc " + pc.getId() + ": " + e.getMessage());
			return returnString;
		}
		Integer maxGameYear = game.getGameYear();
		Integer hearthId = 0;
		Double previousNet = 0.0;
		//Double firstNet = 0.0;
		//Double lastNet = 0.0;
		HearthFactory hearthFactory = new HearthFactory();
		Hearth hearth = null;
		for (Integer gameYear = 0; gameYear<maxGameYear; gameYear++){
			GradingCriterion cashCriterion = fetchGameYearCriterion(cashCriteria, gameYear);
			GradingCriterion assetCriterion = fetchGameYearCriterion(assetCriteria, gameYear);
			if(cashCriterion == null||assetCriterion == null){
				returnString += "The data for year " + gameYear + " is incomplete.\n";
			} else {
				if(!cashCriterion.getHearth().getId().equals(hearthId)){
					try {
						hearthId = cashCriterion.getHearth().getId();
						hearth = hearthFactory.fetchHearth(hearthId);
						previousNet = 0.0;
						returnString += "Data for membership of household " + hearth.getName() + ":\n";
					} catch (Exception e) {
						Logger.ErrorLog("AfriMenCriteria.displayFinalReckoning", 
								        "Issue fetching the hearth for pc " + pc.getId() + "in gameYear" + gameYear + ": " + e.getMessage());
					}
					returnString += padRight("Game Year", 12) + padRight("Cash Value", 13) + padRight("Asset Value", 13) + padRight("Total Net",12) + "Net Gain\n";
				}
				Double netValue = cashCriterion.getValue() + assetCriterion.getValue();
				Double gain = netValue - previousNet;
				returnString += padRight("   " + gameYear, 24) 
							+ padRight("   " + cashCriterion.getValue().intValue(), 22)  
							+ padRight("   " + assetCriterion.getValue().intValue(), 22)  
							+ padRight("   " + netValue.intValue(), 22) + "   " + gain.intValue() + " \n";
				previousNet = netValue;
			}
		}
		return returnString;
	}
	
}
