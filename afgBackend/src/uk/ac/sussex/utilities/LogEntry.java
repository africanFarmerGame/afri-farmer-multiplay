/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

/**
 * 
 */
package uk.ac.sussex.utilities;

import uk.ac.sussex.model.base.BaseObject;

/**
 * @author eam31
 *
 */
public class LogEntry extends BaseObject {
	private Integer id;
	private String message;
	private String generator;
	private Long timestamp;
	
	public LogEntry() {
		super();
		this.setTimestamp(System.currentTimeMillis() / 1000);
		this.addOptionalParam("Id");
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getId() {
		return id;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getMessage() {
		return message;
	}
	public void setGenerator(String generator) {
		this.generator = generator;
	}
	public String getGenerator() {
		return generator;
	}
	public void setTimestamp(Long timestamp) {
		this.timestamp = timestamp;
	}
	public Long getTimestamp() {
		return timestamp;
	}
}
