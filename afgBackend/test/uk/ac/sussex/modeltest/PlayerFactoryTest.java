/**
 * 
 */
package uk.ac.sussex.modeltest;


import org.junit.Test;

import uk.ac.sussex.model.Player;
import uk.ac.sussex.model.PlayerFactory;
import static org.junit.Assert.*;

/**
 * @author em97
 *
 */
public class PlayerFactoryTest {
	
	
	public PlayerFactoryTest() {
	/**	DBConfig dbc = new DBConfig();
		dbc.driverName = "org.gjt.mm.mysql.Driver";
		dbc.connectionString = "jdbc:mysql://127.0.0.1:3306/gamedb";
		dbc.active = true;
		dbc.userName = "root";
		this.dbm = new SFSDBManager(dbc);**/
	}

	
	@Test
	public void testFetchSingle() {
		PlayerFactory pf = new PlayerFactory();
		Player player;
		try {
			player = pf.fetchPlayer("Fred");
			assertEquals("fred", player.getLoginName());
		} catch (Exception e) {
			e.printStackTrace();
			fail(e.getMessage());
		}
		try {
			player = pf.fetchPlayer("fred");
			assertEquals("fred", player.getLoginName());
			//assertNull(player);
		} catch (Exception e) {
			e.printStackTrace();
			fail(e.getMessage());
		}
		try {
			player = pf.fetchPlayer("Notbloodylikelytoexist");
			fail("Successfully retrieved player Notbloodylikelytoexist");
		} catch (Exception e) {
			e.printStackTrace();
			assertTrue(e.getMessage().contains("No player found with username"));
		}
	}
	
	@Test 
	public void testCreateSingle() {
		PlayerFactory pf = new PlayerFactory();
		//Test creating with no username and no password. Should return an error.
		try {
			@SuppressWarnings("unused")
			Player player = pf.createPlayer(null, null);
			assertTrue(false);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("The error message is " + e.getMessage());
			assertTrue(e.getMessage().equals("Cannot create player with null username"));
		}
		//Test creating with no username but valid password. Should return an error.
		try {
			@SuppressWarnings("unused")
			Player player = pf.createPlayer(null, "test1");
			assertTrue(false);
		} catch (Exception e) {
			e.printStackTrace();
			String message = e.getMessage();
			assertTrue(message.equals("Cannot create player with null username"));
		}
		//Try with unique username and no password. Should return an error.
		try {
			@SuppressWarnings("unused")
			Player player = pf.createPlayer("Barney", null);
			fail("The player Barney was created with no password, which ought to have thrown an error.");
		} catch (Exception e) {
			String message = e.getMessage();
			assertTrue(message.contains("LoginPassword") && !message.contains("LoginName") );
		}
		//Test creating with existing username. Should return an error.
		try {
			@SuppressWarnings("unused")
			Player player = pf.createPlayer("Fred", "test1");
			fail ("The player Fred was created when it ought to have generated an error.");
		} catch (Exception e) {
			e.printStackTrace();
			assertTrue(e.getMessage().contains("exists"));
		}
		//Test creating with unique username and proper password. Should succeed.
		 
	}

}
