/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.base;

import java.util.HashMap;

import org.hibernate.Session;
import org.hibernate.SessionFactory;

import uk.ac.sussex.general.SessionFactoryHelper;
import uk.ac.sussex.validator.AttributeValidatorException;
import uk.ac.sussex.validator.GenericAttributeValidator;
import uk.ac.sussex.validator.IClassAttributeValidator;
import uk.ac.sussex.validator.IValidateable;

abstract public class BaseObject implements IValidateable {
	protected HashMap<String, String> optionalParams = new HashMap<String, String>();
	protected HashMap<String, String> stringParams = new HashMap<String, String>();
	
	public void save() throws Exception {
		this.validateWith(new GenericAttributeValidator());
		
		SessionFactory sf = SessionFactoryHelper.getSessionFactory();
		
		Session session = sf.getCurrentSession();
		
		try {	
			session.getTransaction().begin();
			
			session.saveOrUpdate(this);
			
			session.getTransaction().commit();
			
		} catch (Exception e) {
			session.getTransaction().rollback();
			e.printStackTrace();
			String errorMessage = e.getMessage();
			String classname = this.getClass().getName();
			if(errorMessage.contains("same identifier")||errorMessage.contains("Could not execute JDBC batch update")){
				throw new Exception("Error saving " + classname + ": Duplicate identifier" + errorMessage);
			} else {
				throw new Exception(errorMessage);		
			}
		}
	}
	
	@Override
	public void validateWith(IClassAttributeValidator validator)
	 	throws AttributeValidatorException
    {
        validator.validate( this );
    }
	
	/**
     * Checks if the name of the method is entered as optional
     *
     * @param methodName The name of the method
     *
     * @return <code>true</code> if the method is optional
     */
    public boolean isOptionalMethod( String methodName )
    {
        return this.optionalParams.containsKey( methodName );
    }
    /**
     * Add a parameter to the list of optional methods
     *
     * @param paramName The name of the method
     */
    protected void addOptionalParam( String paramName )
    {
        this.optionalParams.put( paramName, paramName );
    }
    /**
     * Clears out the optional parameters for this object. 
     */
    protected void clearOptionalParams() {
    	this.optionalParams.clear();
    }
    /**
     * Checks if the name of the method is entered as optional
     *
     * @param paramName The name of the parameter (capital first letter)
     *
     * @return <code>true</code> if the parameter is a string with validation.
     */
    public boolean isStringParam( String paramName )
    {
        return this.stringParams.containsKey( paramName );
    }
    /**
     * Add a parameter to the list of optional methods
     *
     * @param paramName The name of the method (capital first letter)
     */
    protected void addStringParam( String paramName, String regExp )
    {
        this.stringParams.put( paramName, regExp );
    }
    /**
     * Fetches the relevant regular expression to evaluate the string against. 
     * @param paramName
     * @return
     */
    public String fetchStringRegex(String paramName){
    	return this.stringParams.get(paramName);
    }
    /**
     * Clears out the optional parameters for this object. 
     */
    protected void clearStringParams() {
    	this.stringParams.clear();
    }
    
    public void delete() throws Exception {
    	SessionFactory sf = SessionFactoryHelper.getSessionFactory();
		
		Session session = sf.getCurrentSession();
		
		try {	
			session.getTransaction().begin();
			
			session.delete(this);
			
			session.getTransaction().commit();
			
		} catch (Exception e) {
			session.getTransaction().rollback();
			String errorMessage = e.getMessage();
			throw new Exception(errorMessage);		
		}
    }
}
