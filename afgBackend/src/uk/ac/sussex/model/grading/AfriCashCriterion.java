/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.grading;

import uk.ac.sussex.model.*;
import uk.ac.sussex.utilities.Logger;

public class AfriCashCriterion extends GradingCriterion {
	public static String TYPE = "AFRICASH";
	public AfriCashCriterion(){
		super();
		this.setType(TYPE);
		this.addOptionalParam("Hearth");
	}
	/* (non-Javadoc)
	 * @see uk.ac.sussex.model.grading.ICriterion#calculateValue(uk.ac.sussex.model.PlayerChar)
	 * This criterion stores the amount of cash in the household coffers for a given year. 
	 */
	@Override
	public void calculateValue(PlayerChar pc, Integer gameYear) {
		AfriCashCriterion acc = new AfriCashCriterion(); //Yes, this feels weird, but it's to avoid re-saving the same one over and over. 
		HearthFactory hf = new HearthFactory();
		AssetFactory assetFactory = new AssetFactory();
		AssetOwnerFactory aoFactory = new AssetOwnerFactory();
		Asset cash = null;
		try {
			cash = assetFactory.fetchAsset(Asset.CASH);
		} catch (Exception e) {
			Logger.ErrorLog("AfriCashCriterion.calculateValue", "Problem getting the cash asset for pc " + pc.getId() + ": " + e.getMessage());
			return;
		}
		
		acc.setPc(pc);
		acc.setGameYear(gameYear);
		
		Hearth pcHearth = pc.getHearth();
		if(pcHearth==null){
			//We are calculating the wealth of the pc. Should never happen. 
		} else {
			//Let's make sure we have all of the hearth details. 
			try{
				pcHearth = hf.fetchHearth(pcHearth.getId());
				AssetOwner cashOwner = aoFactory.fetchSpecificAsset(pcHearth, cash);
				acc.setHearth(pcHearth);
				acc.setValue(cashOwner.getAmount());
			} catch (Exception e) {
				Logger.ErrorLog("AfriCashCriterion.calculateValue", "Problem calculating cash value for pc " + pc.getId() + ": " + e.getMessage());
			}
			try {
				acc.save();
			} catch (Exception e) {
				Logger.ErrorLog("AfriCashCriterion.calculateValue", "Problem saving cash criterion for pc " + pc.getId() + ": " + e.getMessage());
			}
		}
	}

	/* (non-Javadoc)
	 * @see uk.ac.sussex.model.grading.ICriterion#displayOutput(uk.ac.sussex.model.PlayerChar)
	 */
	@Override
	public String displayYearEndOutput(PlayerChar pc, Integer gameYear) {
		GradingCriterionFactory gcf = new GradingCriterionFactory();
		String returnString = "";
		try {
			GradingCriterion gc = gcf.fetchSpecificAnnualCriterion(TYPE, pc, gameYear);
			AssetFactory af = new AssetFactory();
			Asset cash = af.fetchAsset(Asset.CASH);
			
			returnString = "Your household has " + gc.getValue().intValue() + " " + cash.getMeasurement() + " in cash.";
		} catch (Exception e) {
			Logger.ErrorLog("AfriCashCriterion.displayYearEndOutput", "Problem getting the criterion for pc " + pc.getId() + ", year " + gameYear + ": " + e.getMessage());
		}
		
		return returnString;
	}

}
