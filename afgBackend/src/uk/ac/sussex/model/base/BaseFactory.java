/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

/**
 * 
 */
package uk.ac.sussex.model.base;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Order;

import uk.ac.sussex.general.SessionFactoryHelper;

/**
 * @author em97
 *
 */
public class BaseFactory {
	private BaseObject factoryObject = null;
	
	public BaseFactory(BaseObject factoryObject){
		this.factoryObject = factoryObject;
	}
	
	public BaseObject fetchSingleObject(String identifier) throws Exception{
		BaseObject object = null;
		SessionFactory sessionFactory = SessionFactoryHelper.getSessionFactory();
		Session session = sessionFactory.getCurrentSession(); 
		try {
			session.getTransaction().begin();
			
			object = (BaseObject) session.get(factoryObject.getClass(), identifier);
			session.getTransaction().commit();
		} catch (HibernateException e) {
			e.printStackTrace();
			session.getTransaction().rollback();
			throw (new Exception("hibernate problem! "+e.getMessage()));
		}
		if(object == null){
			throw (new Exception("No object with that identifier: "+identifier));
		}
		return object;
	}
	public BaseObject fetchSingleObject(Integer identifier) throws Exception{
		BaseObject object = null;
		SessionFactory sessionFactory = SessionFactoryHelper.getSessionFactory();
		Session session = sessionFactory.getCurrentSession(); 
		
		try {
			
			session.getTransaction().begin();
			
			object = (BaseObject) session.get(factoryObject.getClass(), identifier);
			session.getTransaction().commit();
		} catch (HibernateException e) {
			session.getTransaction().rollback();
			throw (new Exception("hibernate problem! "+e.getMessage()));
		}
		if(object == null){
			throw (new Exception("No object with that identifier"));
		}
		return object;
	}
	
	public BaseObject fetchSingleObjectByRestrictions(RestrictionList restrictions) throws Exception {
		SessionFactory sessionFactory = SessionFactoryHelper.getSessionFactory();
		Session session = sessionFactory.getCurrentSession();
		BaseObject object = null;
		try{
			session.getTransaction().begin();
			
			Criteria crit = session.createCriteria(factoryObject.getClass());
			for (Criterion c: restrictions) {
				crit.add(c);
			}
			object = (BaseObject) crit.uniqueResult();
			session.getTransaction().commit();
		} catch (Exception e){
			session.getTransaction().rollback();
			throw e;
		}
		return object;
	}
	
	@SuppressWarnings("unchecked")
	public List<BaseObject> fetchManyObjects(RestrictionList restrictions) throws Exception {
		List<BaseObject> objects = null;
		SessionFactory sessionFactory = SessionFactoryHelper.getSessionFactory();
		Session session = sessionFactory.getCurrentSession(); 
		
		session.getTransaction().begin();
		Criteria crit = session.createCriteria(factoryObject.getClass());
		for (Criterion c: restrictions){
			crit.add(c);
		}
		try {
			objects = crit.list();
			session.getTransaction().commit();
		} catch (Exception e) {
			session.getTransaction().rollback();
			throw (e);
		}
		return objects;
	}
	@SuppressWarnings("unchecked")
	public List<BaseObject> fetchManyObjects(RestrictionList restrictions, OrderList orders) throws Exception {
		List<BaseObject> objects = null;
		SessionFactory sessionFactory = SessionFactoryHelper.getSessionFactory();
		Session session = sessionFactory.getCurrentSession(); 
		
		try {
			
			session.getTransaction().begin();
			Criteria crit = session.createCriteria(factoryObject.getClass());
			for (Criterion c: restrictions){
				crit.add(c);
			}
			for (Order order: orders) {
				crit.addOrder(order);
			}
			objects = crit.list();
			session.getTransaction().commit();
		} catch (Exception e) {
			session.getTransaction().rollback();
			throw (e);
		}
		return objects;
	}

	@SuppressWarnings("unchecked")
	public List<BaseObject> fetchManySubclassObjects(BaseObject subclassObject, RestrictionList restrictions) throws Exception {
		List<BaseObject> objects = null;

		SessionFactory sessionFactory = SessionFactoryHelper.getSessionFactory();
		Session session = sessionFactory.getCurrentSession(); 
		try{
			session.getTransaction().begin();
			Criteria crit = session.createCriteria(subclassObject.getClass());
			for (Criterion c: restrictions){
				crit.add(c);
			}
			objects = crit.list();
			session.getTransaction().commit();
		} catch (Exception e) {
			session.getTransaction().rollback();
			throw e;
		}
		return objects;
		
	}
	@SuppressWarnings("unchecked")
	public List<BaseObject> fetchManySubclassObjects(BaseObject subclassObject, RestrictionList restrictions, OrderList orders) throws Exception{
		List<BaseObject> objects = null;

		SessionFactory sessionFactory = SessionFactoryHelper.getSessionFactory();
		Session session = sessionFactory.getCurrentSession(); 
		try{
			session.getTransaction().begin();
			Criteria crit = session.createCriteria(subclassObject.getClass());
			for (Criterion c: restrictions){
				crit.add(c);
			}
			for (Order order: orders) {
				crit.addOrder(order);
			}
			objects = crit.list();
			session.getTransaction().commit();
		} catch (Exception e) {
			session.getTransaction().rollback();
			throw e;
		}
		return objects;
	}
	public List<BaseObject> fetchManyByQuery(String query) throws Exception {
		List<BaseObject> objects = null;

		SessionFactory sessionFactory = SessionFactoryHelper.getSessionFactory();
		Session session = sessionFactory.getCurrentSession(); 
			
		try {
			session.getTransaction().begin();
			@SuppressWarnings("rawtypes")
			Iterator results = session.createQuery(query).iterate();
			if(results != null){
				objects = new ArrayList<BaseObject>();
				while(results.hasNext()){
					objects.add((BaseObject)results.next());
				}
			}
			session.getTransaction().commit();

		} catch (Exception e) {
			session.getTransaction().rollback();
			throw (e);
		}
		return objects;
	}
	public BaseObject fetchSingleSubclassObjectByRestrictions(BaseObject subclassObject, RestrictionList restrictions) throws Exception {
		SessionFactory sessionFactory = SessionFactoryHelper.getSessionFactory();
		Session session = sessionFactory.getCurrentSession();
		BaseObject object = null;
		try{
			session.getTransaction().begin();
			Criteria crit = session.createCriteria(subclassObject.getClass());
			for (Criterion c: restrictions) {
				crit.add(c);
			}
			object = (BaseObject) crit.uniqueResult();
			session.getTransaction().commit();
		} catch (Exception e) {
			session.getTransaction().rollback();
			throw e;
		}
		return object;
	}

}
