package uk.ac.sussex.model.grading;

import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.utilities.Logger;

public class CoreGameCriteria extends GradingCriteria {
	public CoreGameCriteria() {
		this.addCriterion(new CoreLivingHearthMembersCriterion()); 
	}
	@Override
	public String displayYearEndOutput(PlayerChar pc, Integer gameYear) {
		String returnString = "Game year " + gameYear;
		if(pc.getHearth()!=null){
			HearthFactory hf = new HearthFactory();
			Hearth hearth = null;
			try {
				hearth = hf.fetchHearth(pc.getHearth().getId());
				returnString += ", household " + hearth.getName() + ".\n";
				CoreLivingHearthMembersCriterion clhm = new CoreLivingHearthMembersCriterion();
				returnString += clhm.displayYearEndOutput(pc, gameYear);
				returnString += "\n";
			} catch (Exception e) {
				Logger.ErrorLog("AfriGameCriteria.displayYearEndOutput", "Problem fetching hearth for player " + pc.getId() + ": " + e.getMessage());
			}
		}
		return returnString;
	}
	@Override
	public String displayFinalReckoning(PlayerChar pc) {
		String returnString = "";
		CoreLivingHearthMembersCriterion clhmc = new CoreLivingHearthMembersCriterion();
		returnString += clhmc.displayFinalReckoning(pc) + "\n";
		
		return returnString;
	}
}
