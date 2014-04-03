/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;
import uk.ac.sussex.model.game.Game;

public class Ticker extends BaseObject {
	private Integer id;
	private PlayerChar sender;
	private SeasonDetail seasonDetail;
	private String message;
	private Double duration;
	private Integer active;
	private Game game;
	private Long timestamp;
	
	public Ticker(){
		super();
		this.setTimestamp(System.currentTimeMillis() / 1000);
		this.addOptionalParam("Id");
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
	 * @param sender the sender to set
	 */
	public void setSender(PlayerChar sender) {
		this.sender = sender;
	}
	/**
	 * @return the sender
	 */
	public PlayerChar getSender() {
		return sender;
	}
	/**
	 * @param seasonDetail the seasonDetail to set
	 */
	public void setSeasonDetail(SeasonDetail seasonDetail) {
		this.seasonDetail = seasonDetail;
	}
	/**
	 * @return the seasonDetail
	 */
	public SeasonDetail getSeasonDetail() {
		return seasonDetail;
	}
	/**
	 * @param message the message to set
	 */
	public void setMessage(String message) {
		this.message = message;
	}
	/**
	 * @return the message
	 */
	public String getMessage() {
		return message;
	}
	/**
	 * @param duration the duration to set
	 */
	public void setDuration(Double duration) {
		this.duration = duration;
	}
	/**
	 * @return the duration
	 */
	public Double getDuration() {
		return duration;
	}
	/**
	 * @param active the active to set
	 */
	public void setActive(Integer active) {
		this.active = active;
	}
	/**
	 * @return the active
	 */
	public Integer getActive() {
		return active;
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
	 * @param timestamp the timestamp to set
	 */
	public void setTimestamp(Long timestamp) {
		this.timestamp = timestamp;
	}
	/**
	 * @return the timestamp
	 */
	public Long getTimestamp() {
		return timestamp;
	}
}
