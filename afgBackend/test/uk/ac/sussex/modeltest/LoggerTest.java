/**
 * Tests the Logger class. 
 */
package uk.ac.sussex.modeltest;

import org.junit.Test;

import uk.ac.sussex.utilities.Logger;


/**
 * @author eam31
 *
 */
public class LoggerTest {
	@Test 
	public void testLog(){
		Logger.Log("Me", "My first log message");
	}
}
