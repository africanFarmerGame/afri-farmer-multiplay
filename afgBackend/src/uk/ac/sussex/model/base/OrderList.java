/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.base;

import java.util.ArrayList;

import org.hibernate.criterion.Order;

public class OrderList extends ArrayList<Order> {
	/**
	 * 
	 */
	private static final long serialVersionUID = 4627804547149468937L;

	public void addAscending(String propertyName){
		this.add(Order.asc(propertyName));
	}
	public void addDescending(String propertyName){
		this.add(Order.desc(propertyName));
	}
}
