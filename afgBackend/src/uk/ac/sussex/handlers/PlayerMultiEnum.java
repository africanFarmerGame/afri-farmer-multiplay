/**
 * 
 */
package uk.ac.sussex.handlers;

/**
 * @author em97
 *
 */
public enum PlayerMultiEnum {
	CREATE, CHAR_DETAIL, NOVALUE;
	
	/**
	 * Basically this is to allow me to do different things depending on which 
	 * method is called to the multihandler. Stupid switch not supporting strings. Pah.
	 * @param input
	 * @return
	 */
	public static PlayerMultiEnum toOption(String input){
		try {
			return valueOf(input.toUpperCase());
		} catch (Exception e) {
			return NOVALUE;
		}
	}
}
