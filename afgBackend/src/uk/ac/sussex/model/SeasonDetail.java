/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

/**
 * 
 */
package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;
import uk.ac.sussex.model.seasons.SeasonalWeatherCropEffect;
import uk.ac.sussex.model.seasons.WeatherList;

/**
 * @author em97
 *
 */
public class SeasonDetail extends BaseObject {
	private Integer id;
	private Game game;
	private String season;
	private String stage;
	private String weather;
	private SeasonDetail previousSD;
	private Integer gameYear;
	
	public SeasonDetail() {
		super();
		this.addOptionalParam("Id"); // Optional because generated on save. 
		this.addOptionalParam("Weather"); //Optional because set halfway through season. 
		this.addOptionalParam("PreviousSD"); //Optional because the first season will have no previous.
	}
	
	/**
	 * @param id the id to set
	 */
	public void setId(Integer id) {
		this.id = id;
	}
	/**
	 * @return the id
	 */
	public Integer getId() {
		return id;
	}
	/**
	 * @param game the game to set
	 */
	public void setGame(Game game) {
		this.game = game;
	}
	/**
	 * @return the game
	 */
	public Game getGame() {
		return game;
	}
	/**
	 * @param season the season to set
	 */
	public void setSeason(String season) {
		this.season = season;
	}
	/**
	 * @return the season
	 */
	public String getSeason() {
		return season;
	}
	/**
	 * 
	 * @param gameStage
	 */
	public void setGameStage(String gameStage) {
		this.stage = gameStage;
	}
	/**
	 * 
	 * @return
	 */
	public String getGameStage() {
		return this.stage;
	}
	/**
	 * @param weather the weather to set
	 */
	public void setWeather(String weather) {
		this.weather = weather;
	}
	/**
	 * @return the weather
	 */
	public String getWeather() {
		return weather;
	}
	/**
	 * @return the previousSD
	 */
	public SeasonDetail getPreviousSD() {
		return previousSD;
	}

	/**
	 * @param previousSD the previousSD to set
	 */
	public void setPreviousSD(SeasonDetail previousSD) {
		this.previousSD = previousSD;
	}

	/**
	 * @return the gameYear
	 */
	public Integer getGameYear() {
		return gameYear;
	}

	/**
	 * @param gameYear the gameYear to set
	 */
	public void setGameYear(Integer gameYear) {
		this.gameYear = gameYear;
	}

	public SeasonalWeatherCropEffect fetchCropEffect(Integer cropId, Integer plantingType) throws Exception{
		GameFactory gf = new GameFactory();
		Game fullGame;
		try {
			fullGame = gf.fetchGame(this.getGame().getId());
		} catch (Exception e) {
			throw new Exception ("Problem getting the game - " + e.getMessage());
		}
		WeatherList wl = fullGame.fetchWeatherList();
		return wl.fetchSeasonalWeatherCropEffect(this, cropId, plantingType);
	}
}
