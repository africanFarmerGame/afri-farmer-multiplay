/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;

public class CallHistory extends BaseObject {
	private Integer id;
	private PlayerChar callFrom;
	private PlayerChar callTo;
	private Long started;
	private Long answered;
	private Long finished;
		
	public CallHistory(){
		super();
		this.addOptionalParam("Id");
		this.addOptionalParam("Answered");
		this.addOptionalParam("Finished");
		this.setStarted(System.currentTimeMillis() / 1000);
	}

	/**
	 * @return the id
	 */
	public Integer getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(Integer id) {
		this.id = id;
	}

	/**
	 * @return the callFrom
	 */
	public PlayerChar getCallFrom() {
		return callFrom;
	}

	/**
	 * @param callFrom the callFrom to set
	 */
	public void setCallFrom(PlayerChar callFrom) {
		this.callFrom = callFrom;
	}

	/**
	 * @return the callTo
	 */
	public PlayerChar getCallTo() {
		return callTo;
	}

	/**
	 * @param callTo the callTo to set
	 */
	public void setCallTo(PlayerChar callTo) {
		this.callTo = callTo;
	}

	/**
	 * @return the started
	 */
	public Long getStarted() {
		return started;
	}

	/**
	 * @param started the started to set
	 */
	public void setStarted(Long started) {
		this.started = started;
	}

	/**
	 * @return the answered
	 */
	public Long getAnswered() {
		return answered;
	}

	/**
	 * @param answered the answered to set
	 */
	public void setAnswered(Long answered) {
		this.answered = answered;
	}

	/**
	 * @return the finished
	 */
	public Long getFinished() {
		return finished;
	}

	/**
	 * @param finished the finished to set
	 */
	public void setFinished(Long finished) {
		this.finished = finished;
	}
}
