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
