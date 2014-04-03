/**
 * 
 */
package uk.ac.sussex.handlers;

/**
 * @author em97
 *
 */
public enum CommsMultiOption {
	TALK, 
	TICKER_ANNOUNCE, 
	CLEAR_TICKER, 
	FETCH_TICKER,  
	FETCH_ALL_MEMBERS,
	SEND_SMS_MESSAGE, 
	READ_SMS_MESSAGES,
	UPDATE_SMS_MESSAGE,
	FETCH_CALL_HISTORY,
	START_CALL,
	ANSWER_CALL,
	TALK_PHONE,
	END_CALL,
	FETCH_MESSAGES, 
	UPDATE_MESSAGE,
	NOVALUE;
	
	public static CommsMultiOption toOption(String input){
		try {
			return valueOf(input.toUpperCase());
		} catch (Exception e) {
			return NOVALUE;
		}
	}
}
