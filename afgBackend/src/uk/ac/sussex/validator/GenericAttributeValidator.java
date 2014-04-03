/**
 * 
 */
package uk.ac.sussex.validator;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;

import uk.ac.sussex.model.base.BaseObject;

/**
 * @author eam31
 *
 */
public class GenericAttributeValidator implements IClassAttributeValidator {
	private HashMap<String, String> errorList;
	private BaseObject baseObject;
	@SuppressWarnings("rawtypes")
	private Class clazz;
	
	public GenericAttributeValidator() {
		this.errorList = new HashMap<String, String>();
	}
	/* (non-Javadoc)
	 * @see uk.ac.sussex.validator.IClassAttributeValidator#validate(uk.ac.sussex.model.BaseObject)
	 */
//	@SuppressWarnings("rawtypes")
	@Override
	public void validate(BaseObject testObject)
			throws AttributeValidatorException {
		this.baseObject = testObject;
		this.clazz = baseObject.getClass(  );
        Method[] methods = clazz.getMethods(  );

        //cycle over all methods and call the getters!
        //Check if the getter result is null
        //if result is null throw AttributeValidatorException
        Iterator<Method> methodIter = Arrays.asList( methods ).iterator(  );
        Method method = null;
        String methodName = null;
        String paramName = null;
        
        while ( methodIter.hasNext(  ) )
        {
            method = (Method) methodIter.next(  );
            methodName = method.getName(  );
            if ( methodName.startsWith( "get" ))
            {
                Object methodResult = null;

                try
                {
                    methodResult = method.invoke( baseObject );
                }
                catch ( IllegalArgumentException e )
                {
                    throw new AttributeValidatorException( e.getMessage(  ) );
                }
                catch ( IllegalAccessException e )
                {
                    throw new AttributeValidatorException( e.getMessage(  ) );
                }
                catch ( InvocationTargetException e )
                {
                    throw new AttributeValidatorException( "Validation fail in " + methodName + ": " + e.getTargetException().getMessage() );
                }
                
                paramName = methodName.replaceFirst("^get", "");
                
                if (!(methodResult instanceof Collection )) {
                	//I don't want to validate the collections. I don't think they get saved anyway.
                	this.checkNull(paramName, methodResult);
                    this.checkString(paramName, methodResult);
                }
                

/*              if ( methodResult instanceof Collection )
                {
                    Collection col = (Collection) methodResult;
                    Iterator iter = col.iterator(  );
                    Object subParam = null;

                    while ( iter.hasNext(  ) )
                    {
                        subParam = iter.next(  );

                        if ( subParam instanceof BaseObject )
                        {
                            BaseObject abstractParam = ( BaseObject ) subParam;
                            abstractParam.validateWith( this );
                        }
                    }
                } 
*/
            }
        }
        if(this.errorList.size() > 0){
        	String outputMessage = "";
        	for(Object key: this.errorList.keySet()){
        		outputMessage += key+"|"+this.errorList.get(key)+"||";
        	}
        	throw new AttributeValidatorException(outputMessage);
        }
	}
	private void checkNull(String paramName, Object methodResult){
		if ( !baseObject.isOptionalMethod( paramName ) && methodResult == null )
        {
            String className = clazz.getName(  );
            className = className.substring( className.lastIndexOf( '.' ) + 1 );

            this.addToErrorList(className, paramName, "Null");
        }
	}
	/**
	 * Checks to see if the string result matches the regular expression as it ought to. 
	 * @param paramName
	 * @param methodResult
	 */
	private void checkString(String paramName, Object methodResult){
		//Don't worry about it if a null object is passed - a different check exists for that.
		if (baseObject.isStringParam(paramName)&&(methodResult != null)){
			String result = (String) methodResult;
			
			if(!result.matches(baseObject.fetchStringRegex(paramName))){
				String className = clazz.getName(  );
	            className = className.substring( className.lastIndexOf( '.' ) + 1 );
				this.addToErrorList(className, paramName, "RegexFail");
			}
		}
	}
	private void addToErrorList(String classname, String fieldname, String message){
		this.errorList.put(classname+"|"+fieldname, message);
	}

}
