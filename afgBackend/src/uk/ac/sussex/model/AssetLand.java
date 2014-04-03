/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.model.tasks.TaskOption;

public class AssetLand extends Asset {
	@Override
	public Double fetchAmountHearthOwn(Hearth hearth) throws Exception {
		FieldFactory ff = new FieldFactory();
		List<Field> fields = ff.getHearthFields(hearth);
		Double fieldCount = (double) fields.size();
		
		return fieldCount;
	}
	@Override
	public Double fetchAmountPlayerOwns(PlayerChar pc) throws Exception {
		FieldFactory ff = new FieldFactory();
		List<Field> fields = ff.getPCFields(pc);
		Double fieldCount = (double) fields.size();
		
		return fieldCount;
		
	}
	@Override
	public List<TaskOption> fetchHearthSellOptions(Hearth hearth) throws Exception {
		FieldFactory ff = new FieldFactory();
		List<TaskOption> options = new ArrayList<TaskOption>();
		List<Field> fields = ff.getHearthFields(hearth);
		Integer hearthId = hearth.getId();
		for (Field field: fields){
			//Need to check they own the field first. 
			
			if(field.getHearth().getId().equals(hearthId)){
				
				//Will need to check rental here eventually.
				TaskOption to = new TaskOption();
				to.setName(field.getName());
				to.setValue(field.getId());
				to.setType(field.getType());
				if(field.getCrop()!=null){
					to.setStatus(TaskOption.INVALID);
					to.setNotes("This field has a crop growing in it.");
				} else {
					to.setStatus(TaskOption.VALID);
				}
				options.add(to);
			}
		}
		return options;
	}
	@Override
	public Double buyAssetAmount(Hearth hearth, Double quantity) throws Exception{
		FieldFactory ff = new FieldFactory();
		List<Field> hearthFields = ff.getHearthFields(hearth);
		int fieldCount = hearthFields.size();
		GameFactory gameFactory = new GameFactory();
		Game game = gameFactory.fetchGame(hearth.getGame().getId());
		PlayerChar banker = game.fetchBanker();
		List<Field> gameFields = ff.getPCFields(banker);
		Double fieldsSold = 0.0;
		ListIterator<Field> gameFieldIterator = gameFields.listIterator(gameFields.size());
		
		while(fieldsSold<quantity&&gameFieldIterator.hasPrevious()){
			Field chosenField = null;
			fieldCount ++;
			while(chosenField==null&&gameFieldIterator.hasPrevious()){
				Field currentField = gameFieldIterator.previous();
				if(currentField.getCrop()==null){
					chosenField = currentField;
				}
			}
			chosenField.setHearth(hearth);
			chosenField.setName("Field " + fieldCount);
			chosenField.setOwner(null);
			chosenField.save();
			fieldsSold++;
		}
		
		MarketAsset ma = this.fetchMarketAsset(game);
		ma.setAmount(this.fetchAmountPlayerOwns(banker));
		ma.save();
		
		AssetOwner cashOwner = fetchCashAssetOwner(hearth);
		cashOwner.setAmount(cashOwner.getAmount() - ma.getSellPrice()*fieldsSold);
		cashOwner.save();
		
		return quantity;
	}
	@Override
	public Double sellAssetAmount(Hearth hearth, Double quantity) throws Exception{
		throw new Exception ("Selling a quantity of land is not supported. You must select a specific field to sell.");
	}
	@Override
	public Boolean sellSpecificAsset(Hearth hearth, Integer assetId) throws Exception {
		Boolean success = false;
		FieldFactory fieldFactory = new FieldFactory();
		Field field = fieldFactory.getFieldById(assetId);
		//Now check the ownership. 
		if(field.getHearth().getId().equals(hearth.getId())){
			Game game = null;
			try{
				GameFactory gameFactory = new GameFactory();
				game = gameFactory.fetchGame(hearth.getGame().getId());
				PlayerChar banker = game.fetchBanker();
				field.setOwner(banker);
				field.setHearth(null);
				field.save();
			} catch (Exception e) {
				throw new Exception("Unable to change field ownership: " + e.getMessage());
			}
			MarketAsset ma = null;
			try{
				ma = fetchMarketAsset(game);
				AssetOwner cashOwner = fetchCashAssetOwner(hearth);
				cashOwner.setAmount(cashOwner.getAmount() + ma.getBuyPrice());
				cashOwner.save();
			} catch(Exception e){
				throw new Exception("Unable to save cash: " + e.getMessage());
			}
			try{
				ma.setAmount(ma.getAmount()+1);
				ma.save();
			} catch (Exception e) {
				throw new Exception("Unable to change market amount: " + e.getMessage());
			}
			success = true;
		} else {
			throw new Exception("The field selected did not belong to the vendor.");
		}
		return success;
	}
	@Override
	public Double giveAssetAmount(Hearth giver, Hearth receiver, Double quantity) throws Exception{
		throw new Exception("Giving a quantity of land is not supported. You must select a specific field to give.");
	}
	@Override
	public Boolean giveSpecificAsset(Hearth giver, Hearth receiver, Integer optionId) throws Exception {
		Boolean success = false;
		FieldFactory fieldFactory = new FieldFactory();
		Field field = fieldFactory.getFieldById(optionId);
		//Now check the ownership. 
		if(field.getHearth().getId().equals(giver.getId())){
			try{
				field.setHearth(receiver);
				field.save();
			} catch (Exception e) {
				throw new Exception ("There was a problem transferring the field ownership: " + e.getMessage());
			}
			success = true;
		} else {
			throw new Exception("The selected field did not belong to the person giving it away.");
		}
		return success;
	}
	@Override
	public Double giveAssetAmountFromBanker(Hearth receiver, Double quantity) throws Exception{
		FieldFactory ff = new FieldFactory();
		List<Field> hearthFields = ff.getHearthFields(receiver);
		int fieldCount = hearthFields.size();
		GameFactory gameFactory = new GameFactory();
		Game game = gameFactory.fetchGame(receiver.getGame().getId());
		PlayerChar banker = game.fetchBanker();
		List<Field> gameFields = ff.getPCFields(banker);
		Double fieldsSold = 0.0;
		ListIterator<Field> gameFieldIterator = gameFields.listIterator(gameFields.size());
		
		while(fieldsSold<quantity&&gameFieldIterator.hasPrevious()){
			Field chosenField = null;
			fieldCount ++;
			while(chosenField==null&&gameFieldIterator.hasPrevious()){
				Field currentField = gameFieldIterator.previous();
				if(currentField.getCrop()==null){
					chosenField = currentField;
				}
			}
			chosenField.setHearth(receiver);
			chosenField.setName("Field " + fieldCount);
			chosenField.setOwner(null);
			chosenField.save();
			fieldsSold++;
		}
		
		MarketAsset ma = this.fetchMarketAsset(game);
		ma.setAmount(this.fetchAmountPlayerOwns(banker));
		ma.save();
		
		return fieldsSold;
	}
}
