/**
 * 
 */
package uk.ac.sussex.model;

import java.util.ArrayList;
import java.util.List;

import uk.ac.sussex.model.base.BaseFactory;
import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.base.RestrictionList;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.gameStage.GameStage;
import uk.ac.sussex.model.seasons.Season;
import uk.ac.sussex.model.seasons.SeasonList;

/**
 * @author em97
 *
 */
public class SeasonDetailFactory extends BaseFactory {
	
	/**
	 * The Base Factory object needs to know what kind of base object we're initialising. 
	 */
	public SeasonDetailFactory() {
		super(new SeasonDetail());
	}
	/**
	 * Special function, returns a 'pre-game' season to get us started. 
	 * @return
	 */
	public SeasonDetail getFirstSeason(Game game) throws Exception {
		
		try {
			Season preSeason = game.fetchSeasonList().fetchFirstSeason();
			
			SeasonDetail preGame = new SeasonDetail();
			preGame.setGame(game);
			preGame.setSeason(preSeason.getId());
			
			preGame.save();
			return preGame;
		} catch (Exception e) {
			throw new Exception ("Problem generating pre-game season detail: " + e.getMessage());
		}
	}
	public SeasonDetail fetchSeasonDetail(Integer seasonDetailId) throws Exception{
		return (SeasonDetail)this.fetchSingleObject(seasonDetailId);
	}
	/**
	 * This function gets back the detail for the next game season, using the 
	 * Season Factory to get the next season. The weather is not set until the END of the season.
	 * Now we have different stages, I need to keep the same season detail through all of them. 
	 * 
	 * @param game
	 * @return
	 * @throws Exception
	 */
	public SeasonDetail generateNewSeasonDetail(Game game) throws Exception {

		SeasonDetail currentSd = this.fetchCurrentSeasonDetail(game);
		
		SeasonList sl = game.fetchSeasonList();
		Season nextSeason = sl.getCurrentSeason();
		GameStage nextStage = sl.getCurrentStage();
		if (currentSd==null || !nextSeason.getId().equals(currentSd.getSeason())){
			SeasonDetail newSD = new SeasonDetail();
			newSD.setGame(game);
			newSD.setSeason(nextSeason.getId());
			newSD.setGameStage(nextStage.getName());
			newSD.setPreviousSD(currentSd);
			newSD.setGameYear(game.getGameYear());
			//Save this item. 
			newSD.save();
			return newSD;
		} else {
			currentSd.setGameStage(nextStage.getName());
			currentSd.save();
			return currentSd;
		}
	}
	public SeasonDetail fetchCurrentSeasonDetail(Game game) throws Exception {
		SeasonDetail sdId = game.getCurrentSeasonDetail();
		SeasonDetail sd = null;
		if(sdId != null){
			sd = (SeasonDetail) this.fetchSingleObject(sdId.getId());
		}
		return sd;
	}
	public SeasonDetail fetchPreviousSeasonDetail(Game game) throws Exception {
		SeasonDetail currentSD = this.fetchCurrentSeasonDetail(game);
		SeasonDetail previousSD = currentSD.getPreviousSD();
		if(previousSD!=null){
			previousSD = (SeasonDetail) this.fetchSingleObject(previousSD.getId());
		}
		return previousSD;
	}
	public List<SeasonDetail> fetchYearSeasonDetails(Game game) throws Exception {
		Integer year = game.getGameYear();
		RestrictionList restrictions = new RestrictionList();
		restrictions.addEqual("game", game);
		restrictions.addEqual("gameYear", year);
		List<BaseObject> objects = this.fetchManyObjects(restrictions);
		List<SeasonDetail> seasons = new ArrayList<SeasonDetail>();
		for (BaseObject object : objects ) {
			seasons.add((SeasonDetail) object);
		}
		return seasons;
	}
}
