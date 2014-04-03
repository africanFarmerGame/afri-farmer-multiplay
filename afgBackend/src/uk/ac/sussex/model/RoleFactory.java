/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

/**
 * 
 */
package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseFactory;

/**
 * @author em97
 *
 */
public class RoleFactory extends BaseFactory {

	/**
	 * @param factoryObject
	 */
	public RoleFactory() {
		super(new Role());
	}
	public Role fetchRole(String roleName) throws Exception{
		Role role = null;
		try {
			role = (Role) this.fetchSingleObject(roleName);
		} catch (Exception e) {
			String eMessage = e.getMessage();
			if(eMessage.contains("identifier")){
				throw new Exception ("No role found with that name.");
			} else {
				throw new Exception (eMessage);
			}
		}
		return role;
	}
	public Role fetchRandomRole() throws Exception {
		Role role;
		if(Math.random() > 0.5){
			role = (Role) this.fetchSingleObject("WOMAN");
		} else {
			role = (Role) this.fetchSingleObject("MAN");
		}
		return role;
	}
}
