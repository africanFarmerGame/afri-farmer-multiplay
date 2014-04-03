/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
