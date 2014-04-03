/**
 * 
 */
package uk.ac.sussex.model;


/**
 * @author em97
 *
 */
public enum RoomTypes {
	HOME, BANK, MARKET, VILLAGE, FARM, NOVALUE;
	
	public static RoomTypes toOption(String input){
		try {
			return valueOf(input.toUpperCase());
		} catch (Exception e) {
			return NOVALUE;
		}
	}
}
