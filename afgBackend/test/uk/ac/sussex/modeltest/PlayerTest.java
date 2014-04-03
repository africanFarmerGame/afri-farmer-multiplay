/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

/**
 * 
 */
package uk.ac.sussex.modeltest;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.junit.Test;
import static org.junit.Assert.*;
import uk.ac.sussex.general.SessionFactoryHelper;
//import uk.ac.sussex.model.Game;
import uk.ac.sussex.model.Player;
import uk.ac.sussex.validator.AttributeValidatorException;
import uk.ac.sussex.validator.GenericAttributeValidator;

/**
 * @author em97
 *
 */
public class PlayerTest {
	
	@Test
	public void TestHibernateCreation() {
		@SuppressWarnings("deprecation")
		SessionFactory sessionFactory = new Configuration().configure() .buildSessionFactory();
		Session session = sessionFactory.getCurrentSession();
		@SuppressWarnings("unused")
		Transaction tx = session.beginTransaction();
		Player player;
		player = (Player) session.get(Player.class, "fred");
		assertNotNull(player);
		assertEquals("fred", player.getLoginName());
	}
	
/**	@Test
	public void TestUsername(){
		Player player = new Player();
		String testUsername = "Fred";
		player.setUsername(testUsername);
		assertEquals(testUsername, player.getUsername());
	}
	**/
	@Test
	public void testPlayerSave() {
		
		String testName = "TestPlayer1";
		String newPassword = "test1";
		
		Player player1 = new Player();
		player1.setLoginName(testName);
		player1.setLoginPassword(newPassword);
		try {
			player1.save();
		}catch (Exception e){
			e.printStackTrace();
			fail("Unexpected error: " + e.getMessage());
		}
		
		SessionFactory sessionFactory = SessionFactoryHelper.getSessionFactory();
		Session session = sessionFactory.getCurrentSession();
		@SuppressWarnings("unused")
		Transaction tx = session.beginTransaction();
		
		Player player2 = (Player) session.get(Player.class, testName);
		
		assertEquals(player1.toString(), player2.toString());
	}
	/*@Test
	public void testGetCurrentGame() {
		// need 2 players, one with a null current game, one with a proper one. 
		SessionFactory sessionFactory = SessionFactoryHelper.getSessionFactory();
		Session session = sessionFactory.getCurrentSession();
		@SuppressWarnings("unused")
		Transaction tx = session.beginTransaction();
		
		Player player = (Player) session.get(Player.class, "Fred");
		assertTrue(player.getCurrentGame() == null);
		player = (Player) session.get(Player.class, "TestUser2");
		assertFalse(player.getCurrentGame() == null);
		assertTrue(player.getCurrentGame() instanceof Game);
		assertTrue(player.getCurrentGame().getGameName().equals("game1"));
	}*/
	@Test
	public void testValidation() {
		//Test that a username of more than 50 characters fails validation.
		GenericAttributeValidator validator = new GenericAttributeValidator();
		Player player1 = new Player();
		player1.setLoginPassword("fres");
		
		player1.setLoginName("valid");
		try {
			player1.validateWith(validator);
			assertTrue(true);
		} catch(AttributeValidatorException e){
			fail ("Unexpected problem in testValidation: "+e.getMessage());
		}
		
		//player1.setLoginName("fred");
		player1.setLoginName("thisisaloginnamewithmorethanfiftylittlecharacterswhichoughttofailthevalidationforthisclass");
		player1.setLoginPassword("fres");
		try {
			player1.validateWith(validator);
			assertTrue(false);
		} catch(AttributeValidatorException e){
			assertTrue(e.getMessage().contains("LoginName|RegexFail"));
		}
		
	
		
	}
}
