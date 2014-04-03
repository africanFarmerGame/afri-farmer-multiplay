/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.utilities;



public class Logger {
	/**
	 * Call this to add a log entry to the database. 
	 * @param generator - username of the person who generated the event.
	 * @param message - custom message to be logged. 
	 */
	public static void Log(String generator, String message){
		LogEntry entry = new LogEntry();
		entry.setGenerator(generator);
		entry.setMessage(message);
		try{
			entry.save();
		} catch (Exception e){
			e.printStackTrace();
		}
	}
	public static void ErrorLog(String functionName, String message){
		ErrorLogEntry entry = new ErrorLogEntry();
		entry.setFunction(functionName);
		entry.setMessage(message);
		try {
			entry.save();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
