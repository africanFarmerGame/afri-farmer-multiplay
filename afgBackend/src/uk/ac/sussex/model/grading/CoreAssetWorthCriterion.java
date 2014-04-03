/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.grading;

import java.util.Iterator;
import java.util.Set;

import uk.ac.sussex.model.Asset;
import uk.ac.sussex.model.AssetFactory;
import uk.ac.sussex.model.AssetOwner;
import uk.ac.sussex.model.AssetOwnerFactory;
import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.MarketAsset;
import uk.ac.sussex.model.MarketAssetFactory;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.utilities.Logger;

public class CoreAssetWorthCriterion extends GradingCriterion {
	public static String TYPE = "COREASSETWORTH";
	public CoreAssetWorthCriterion(){
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
		//I know this is weird, but am storing a new one rather than altering the values on the current.
		CoreAssetWorthCriterion cawc = new CoreAssetWorthCriterion();
		HearthFactory hf = new HearthFactory();
		AssetOwnerFactory aoFactory = new AssetOwnerFactory();
		MarketAssetFactory maFactory = new MarketAssetFactory();
		Set<MarketAsset> marketAssets = null;
		try {
			marketAssets = maFactory.fetchMarketAssets(pc.getGame());
		} catch (Exception e) {
			Logger.ErrorLog("CoreAssetWorthCriterion.calculateValue", "Problem getting the market assets for pc " + pc.getId() + ": " + e.getMessage());
			return;
		}
		
		cawc.setPc(pc);
		cawc.setGameYear(gameYear);
		
		Hearth pcHearth = pc.getHearth();
		if(pcHearth==null){
			//We are calculating the wealth of the pc. Should never happen. 
		} else {
			//Let's make sure we have all of the hearth details. 
			try{
				pcHearth = hf.fetchHearth(pcHearth.getId());
				Double cashValue = 0.0;
				Set<AssetOwner> hearthAssets = aoFactory.fetchHearthAssets(pcHearth);
				for(AssetOwner hearthAsset: hearthAssets){
					Integer assetId = hearthAsset.getAsset().getId();
					//This is a list of non-cash assets.
					if(!assetId.equals(Asset.CASH)){
						Iterator<MarketAsset> maIterator = marketAssets.iterator();
						Boolean notFound = true;
						MarketAsset ma = null;
						while(maIterator.hasNext()&&notFound){
							ma = maIterator.next();
							if(ma.getAsset().getId().equals(assetId)){
								notFound = false;
							}
						}
						if(!notFound){
							cashValue += ma.getBuyPrice() * hearthAsset.getAmount();
						}
					}
				}
				cawc.setHearth(pcHearth);
				cawc.setValue(cashValue);
			} catch (Exception e) {
				Logger.ErrorLog("CoreAssetWorthCriterion.calculateValue", "Problem calculating cash value for pc " + pc.getId() + "'s assets: " + e.getMessage());
			}
			try {
				cawc.save();
			} catch (Exception e) {
				Logger.ErrorLog("CoreAssetWorthCriterion.calculateValue", "Problem saving asset criterion for pc " + pc.getId() + ": " + e.getMessage());
			}
		}
	}
	/* (non-Javadoc)
	 * @see uk.ac.sussex.model.grading.ICriterion#displayYearEndOutput(uk.ac.sussex.model.PlayerChar, java.lang.Integer)
	 */
	@Override
	public String displayYearEndOutput(PlayerChar pc, Integer gameYear){
		
		GradingCriterionFactory gcf = new GradingCriterionFactory();
		String returnString = "";
		try {
			GradingCriterion gc = gcf.fetchSpecificAnnualCriterion(TYPE, pc, gameYear);
			AssetFactory af = new AssetFactory();
			Asset cash = af.fetchAsset(Asset.CASH);
			
			returnString = "Your household has " + gc.getValue().intValue() + " " + cash.getMeasurement() + " of non-cash assets. This value is generated from the price that the market would currently give you for each asset.";
		} catch (Exception e) {
			Logger.ErrorLog("AfriCashCriterion.displayYearEndOutput", "Problem getting the criterion for pc " + pc.getId() + ", year " + gameYear + ": " + e.getMessage());
		}
		
		return returnString;
		
	}
}
