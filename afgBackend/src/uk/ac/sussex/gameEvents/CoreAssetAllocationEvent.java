package uk.ac.sussex.gameEvents;

import java.util.Iterator;
import java.util.List;
import java.util.Set;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.village.Village;
import uk.ac.sussex.model.village.VillageFarm;
import uk.ac.sussex.model.village.VillageFarms;

public class CoreAssetAllocationEvent extends GameEvent {

	public CoreAssetAllocationEvent(Game game) {
		super(game);
	}

	@Override
	public void fireEvent() throws Exception {
		//Set up the market assets. 
		MarketAssetFactory maf = new MarketAssetFactory();
		AssetFactory af = new AssetFactory();
		
		maf.createGameMarketAssets(game);
		
		//Assign fields
		try {
			this.createGameFields();
		} catch (Exception e){
			throw new Exception ("Problem allocating fields: " + e.getMessage());
		}
		try {
			this.createGMFields();
		} catch (Exception e) {
			throw new Exception ("Problem creating the GM fields: " + e.getMessage());
		}
		//Let's just update the land asset. 
		Asset land = af.fetchAsset("Land");
		MarketAsset landMarket = maf.fetchMarketAssetbyAsset(land, game);
		PlayerChar banker = game.fetchBanker();
		
		Double numFields = land.fetchAmountPlayerOwns(banker);
		landMarket.setAmount(numFields);
		landMarket.save();
		
		HearthFactory hf = new HearthFactory();
		AssetOwnerFactory aof = new AssetOwnerFactory();
		try {
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
		}catch (Exception e){
			throw new Exception ("Problem allocating assets: " + e.getMessage());
		}
		
	}

	@Override
	public void generateNotifications() throws Exception {
		SeasonNotificationFactory snf = new SeasonNotificationFactory();
		//For the players
		HearthFactory hf = new HearthFactory();
		AssetFactory af = new AssetFactory();
		Asset cash = af.fetchAsset(Asset.CASH);
		String cashMeasurement = cash.getMeasurement();
		Set<Hearth> hearths = hf.fetchGameHearths(game);
		for (Hearth hearth: hearths){
			//Ok, it's fields and it's Afris.
			Double cashAmount = cash.fetchAmountHearthOwn(hearth);
			String hearthMessage = "Assets:\nYour hearth has is starting out with " + cashAmount.toString() + cashMeasurement + "s. ";
			hearthMessage += "You also own " + hearth.fetchFieldCount().toString() + " fields.";
			Set<PlayerChar> playerChars = hearth.getCharacters();
			snf.updateSeasonNotifications(hearthMessage, playerChars);
		}
		//For the GM.
		PlayerChar banker = game.fetchBanker();
		FieldFactory ff = new FieldFactory();
		List<Field> fields = ff.getPCFields(banker);
		String gmMessage = "Assets:\nYou have " + fields.size() + " fields to sell or rent.";
		snf.updateBankerNotifications(gmMessage, game);
	}
	private void createGameFields() throws Exception {
		Set<Hearth> hearths = game.fetchHearths();
		Village village = game.fetchVillageType();
		
		Integer numberOfFarms = hearths.size();
		if(numberOfFarms < village.getMinFamilies()){
			throw new Exception("There are not enough hearths in this game: " + numberOfFarms);
		} else if (numberOfFarms > village.getMaxFamilies()) {
			throw new Exception("There are too many hearths in this game: " + numberOfFarms);
		}
		
		VillageFarms farms = village.getFarms(numberOfFarms);
		Iterator<VillageFarm> itFarms = farms.getIterator();
		Iterator<Hearth> itHearth = hearths.iterator();
		FieldFactory fieldFactory = new FieldFactory();
		
		while(itHearth.hasNext() && itFarms.hasNext()){
			Hearth hearth = itHearth.next();
			VillageFarm farm = itFarms.next();
			int farmSize = farm.getFarmSize();
			fieldFactory.createFields(farmSize, hearth);
		}
	}
	private void createGMFields() throws Exception {
		PlayerChar banker = game.fetchBanker();
		Village village = game.fetchVillageType();
		
		Set<Hearth> hearths = game.fetchHearths();
		int numberOfFarms = hearths.size();
		
		int totalFields = village.calculateGMFields(numberOfFarms);
		FieldFactory fieldFactory = new FieldFactory();
		fieldFactory.createFields(totalFields, banker);
	}
}
