package uk.ac.sussex.validator;

public interface IValidateable {
	/**
	 * This should be implemented by any objects that have parameters that need validation.
	 * @param validator
	 * @throws Exception
	 */
	public void validateWith( IClassAttributeValidator validator ) throws Exception;
}
