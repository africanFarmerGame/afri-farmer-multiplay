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
