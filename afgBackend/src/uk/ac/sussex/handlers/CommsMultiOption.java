/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
