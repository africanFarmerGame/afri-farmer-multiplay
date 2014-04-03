package uk.ac.sussex.model.grading;

import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.Role;
import uk.ac.sussex.utilities.Logger;

public class AfriGameCriteria extends GradingCriteria {
	public AfriGameCriteria() {
		this.addCriterion(new CoreLivingHearthMembersCriterion());
		this.addCriterion(new AfriMenCriteria());
		this.addCriterion(new AfriDietCriteria());
	}
	/* (non-Javadoc)
	 * @see uk.ac.sussex.model.grading.ICriterion#displayOutput(uk.ac.sussex.model.PlayerChar)
	 */
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
		
		if(pc.getRole().getId().equals(Role.MAN)){
			AfriMenCriteria amc = new AfriMenCriteria();
			returnString += amc.displayYearEndOutput(pc, gameYear);
		} else if (pc.getRole().getId().equals(Role.WOMAN)) {
			AfriDietCriteria adc = new AfriDietCriteria();
			returnString += adc.displayYearEndOutput(pc, gameYear);
		}
		return returnString;
	}
	
	@Override
	public String displayFinalReckoning(PlayerChar pc) {
		String returnString = "";
		if(pc.getRole().getId().equals(Role.MAN)){
			AfriMenCriteria amc = new AfriMenCriteria();
			returnString += amc.displayFinalReckoning(pc);
		} else if (pc.getRole().getId().equals(Role.WOMAN)) {
			AfriDietCriteria adc = new AfriDietCriteria();
			CoreLivingHearthMembersCriterion clhmc = new CoreLivingHearthMembersCriterion();
			returnString += clhmc.displayFinalReckoning(pc) + "\n";
			returnString += adc.displayFinalReckoning(pc);
		}
		return returnString;
	}
}
