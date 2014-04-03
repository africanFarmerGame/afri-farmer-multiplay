/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.general;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

 
@SuppressWarnings("deprecation")
public class SessionFactoryHelper {
	private static final SessionFactory sessionFactory;
	
	static {
		try {            
			/*
			 * Build a SessionFactory object from session-factory configuration 
			 * defined in the hibernate.cfg.xml file. In this file we register 
			 * the JDBC connection information, connection pool, the hibernate 
			 * dialect that we used and the mapping to our hbm.xml file for each 
			 * POJO (Plain Old Java Object).
			 * 
			 */
			sessionFactory = new Configuration().configure().buildSessionFactory();
			
		} catch (Throwable e) {
			e.printStackTrace();
			System.err.println("Error in creating SessionFactory object."
					+ e.getMessage());
			throw new ExceptionInInitializerError(e);
		}
	}
	/*
	 * A static method for other application to get SessionFactory object 
	 * initialized in this helper class.
	 * 
	 */
	public static SessionFactory getSessionFactory() {
		return sessionFactory;
	}
}
