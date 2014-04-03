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
