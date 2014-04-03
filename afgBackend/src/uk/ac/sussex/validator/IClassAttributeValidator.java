package uk.ac.sussex.validator;

import uk.ac.sussex.model.base.BaseObject;

public interface IClassAttributeValidator {

	/**
	 * 
	 * @param baseObject
	 * @throws AttributeValidatorException
	 */
	void validate(BaseObject baseObject) throws AttributeValidatorException;

}
