/**
 * 
 */
package uk.ac.sussex.validator;

/**
 * @author eam31
 *
 */
@SuppressWarnings("serial")
public class AttributeValidatorException extends Exception {
	/**
     * Creates a new AttributeValidatorException object.
     *
     * @param msg The error message of the thrown AttributeValidatorException
     */
    public AttributeValidatorException( String msg )
    {
        super( msg );
    }
}
