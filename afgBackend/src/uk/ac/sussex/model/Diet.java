/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;

public class Diet extends BaseObject {
	private Integer id;
	private String name;
	private Hearth household;
	private Integer target;	//This is the type of diet e.g. Child, Adult male, Baby etc. I'll add constants. 
	private Integer deleted = 0;
	
	public Diet(){
		super();
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
	 * @param name the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}
	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}
	/**
	 * @param household the household to set
	 */
	public void setHousehold(Hearth household) {
		this.household = household;
	}
	/**
	 * @return the household
	 */
	public Hearth getHousehold() {
		return household;
	}
	/**
	 * @param target the target to set
	 */
	public void setTarget(Integer target) {
		this.target = target;
	}
	/**
	 * @return the target
	 */
	public Integer getTarget() {
		return target;
	}
	/**
	 * @return the deleted
	 */
	public Integer getDeleted() {
		return deleted;
	}
	/**
	 * @param deleted the deleted to set
	 */
	public void setDeleted(Integer deleted) {
		this.deleted = deleted;
	}
	
}
