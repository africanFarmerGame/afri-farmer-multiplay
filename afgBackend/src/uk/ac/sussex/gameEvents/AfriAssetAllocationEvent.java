/**
Copyright 2014 Future Agricultures Consortium

This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.gameEvents;

import java.util.Iterator;
import java.util.Set;

import uk.ac.sussex.model.Asset;
import uk.ac.sussex.model.AssetFactory;
import uk.ac.sussex.model.AssetOwnerFactory;
import uk.ac.sussex.model.FieldFactory;
import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.MarketAssetFactory;
import uk.ac.sussex.model.PlayerChar;
import uk.ac.sussex.model.PlayerCharFactory;
import uk.ac.sussex.model.Role;
import uk.ac.sussex.model.SeasonNotificationFactory;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.village.Village;
import uk.ac.sussex.model.village.VillageFarm;
import uk.ac.sussex.model.village.VillageFarms;
import uk.ac.sussex.utilities.Logger;

public class AfriAssetAllocationEvent extends GameEvent {

	public AfriAssetAllocationEvent(Game game) {
		super(game);
	}

	/**
	 * In this game, the men get the fields, the women have the hearths. 
	 * Therefore need to assign the fields to the male pcs, and afris to hearths and men. 
	 */
	@Override
	public void fireEvent() throws Exception {
		//Set up the market assets. 
		
		try {
			this.setUpMarketAssets();
		} catch (Exception e) {
			throw new Exception ("Problem setting up the market assets: " + e.getMessage());
		}
		
		//Assign fields
		try {
			this.assignFields();
		} catch (Exception e){
			throw new Exception ("Problem allocating fields: " + e.getMessage());
		}
		
		//Assign assets to the hearths. 
		try {
			this.assignWealth();
		}catch (Exception e){
			throw new Exception ("Problem allocating assets: " + e.getMessage());
		}
		
	}

	@Override
	public void generateNotifications() throws Exception {
		PlayerCharFactory pcf = new PlayerCharFactory();
		Set<PlayerChar> pcs = pcf.fetchGamePCs(game);
		SeasonNotificationFactory snf = new SeasonNotificationFactory();
		
		String noteHeader = "Asset allocation:\n";
		String bankerNote = noteHeader + "The men in your village have been allocated fields and 30 Afris. The women have children and 30 Afris per adult in the household.";
		snf.updateBankerNotifications(bankerNote, game);
		for (PlayerChar pc: pcs){
			String messageNote = noteHeader;
			if(pc.getRole().getId().equals(Role.MAN)){
				messageNote += "You have been allocated 30 Afris and " + pc.getFieldCount() + " fields.";
			} else {
				messageNote += "Your household has been allocated 30 Afris per adult.";
			}
			snf.updateSeasonNotifications(messageNote, pc);
		}
		
	}
	
	private void setUpMarketAssets() throws Exception {
		MarketAssetFactory maf = new MarketAssetFactory();
		maf.createGameMarketAssets(game);
	}
	private void assignFields() throws Exception {
		Set<Hearth> hearths = game.fetchHearths();
		Village village = game.fetchVillageType();
		PlayerCharFactory pcf = new PlayerCharFactory();
		Set<PlayerChar> men = pcf.fetchMen(game);
		
		Integer numberOfFarms = hearths.size();
		if(numberOfFarms < village.getMinFamilies()){
			throw new Exception("There are not enough hearths in this game: " + numberOfFarms);
		} else if (numberOfFarms > village.getMaxFamilies()) {
			throw new Exception("There are too many hearths in this game: " + numberOfFarms);
		}
		Logger.ErrorLog("AfriAssetAllocation.assignFields", "We have " + numberOfFarms + " farms to create.");
		VillageFarms farms = village.getFarms(numberOfFarms);
		Iterator<VillageFarm> itFarms = farms.getIterator();
		Iterator<PlayerChar> itMen = men.iterator();
		FieldFactory fieldFactory = new FieldFactory();
		Boolean ignoreSmallest = true;
		int smallestFarm = farms.smallestFarmSize();
		
		while(itMen.hasNext() && itFarms.hasNext()){
			PlayerChar man = itMen.next();
			VillageFarm farm = itFarms.next();
			//This is a little hacky. Basically I want the all-female household left with the smallest farm.
			if(farm.getFarmSize()==smallestFarm && ignoreSmallest){
				farm = itFarms.next();
				ignoreSmallest = false;
			}
			int farmSize = farm.getFarmSize();
			fieldFactory.createFields(farmSize, man);
		}
	}
	private void assignWealth() throws Exception{
		AssetFactory af = new AssetFactory();
		HearthFactory hf = new HearthFactory();
		AssetOwnerFactory aof = new AssetOwnerFactory();
		Set<Asset> assets = af.fetchAssets();
		Set<Hearth> hearths = hf.fetchGameHearths(game);
		for (Hearth hearth: hearths){
			//Assign 30 Afris per adult.
			Integer familyAfris = hearth.fetchNumberOfAdults() * 30;
			for (Asset asset: assets) {
				if(asset.getId().equals(Asset.CASH)){
					aof.assignOwnership(hearth, asset, (double) familyAfris);
				} else {
					aof.assignOwnership(hearth, asset, (double) 0);
				}
			}
			
		}
		
		PlayerCharFactory pcf = new PlayerCharFactory();
		Set<PlayerChar> men = pcf.fetchMen(game);
		for(PlayerChar man : men){
			//Assign 30 Afris per man.
			Integer manAfris = 30;
			for (Asset asset: assets) {
				if(asset.getId().equals(Asset.CASH)){
					aof.assignOwnership(man, asset, (double) manAfris);
				} else {
					aof.assignOwnership(man, asset, (double) 0);
				}
			}
		}
	}
	
}
