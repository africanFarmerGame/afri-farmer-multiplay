/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

/**
 * 
 */
package uk.ac.sussex.model.base;

import java.util.ArrayList;

import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Restrictions;

/**
 * @author em97
 *
 */
@SuppressWarnings("serial")
public class RestrictionList extends ArrayList<Criterion> {
	/**
	 * The attribute must be equal to the object.
	 * @param attributeName
	 * @param value
	 */
	public void addEqual(String attributeName, Object value){
		this.add(Restrictions.eq(attributeName, value));
	}
	/**
	 * Attribute 1 must be greater than attribute 2.
	 * @param attributeName1
	 * @param attributeName2
	 */
	public void addGTProperty(String attributeName1, String attributeName2){
		this.add(Restrictions.gtProperty(attributeName1, attributeName2));
	}
	/**
	 * Attribute must be greater than integer value.
	 * @param attributeName
	 * @param value
	 */
	public void addGTDouble(String attributeName, Double value){
		this.add(Restrictions.gt(attributeName, value));
	}
	
	public void addGTInt(String attributeName, Integer value){
		this.add(Restrictions.gt(attributeName, value));
	}
	
	public void addNotEqual(String attributeName, Object value){
		this.add(Restrictions.ne(attributeName, value));
	}
}
