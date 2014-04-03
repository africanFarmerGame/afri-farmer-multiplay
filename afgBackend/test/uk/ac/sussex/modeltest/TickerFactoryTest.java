package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import java.util.Set;

import org.junit.Test;

import uk.ac.sussex.model.*;
import uk.ac.sussex.model.game.Game;
import uk.ac.sussex.model.game.GameFactory;

public class TickerFactoryTest {

	@Test
	public void testFetchCurrentTicker() {
		TickerFactory tf = new TickerFactory();
		GameFactory gf = new GameFactory();
		//Need to test no current ticker
		Game noTicker = null;
		try{
			noTicker = gf.fetchGame(1);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching noTicker game: " + e.getMessage());
		}
		Ticker ticker = null;
		try{
			ticker = tf.fetchCurrentTicker(noTicker);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching current ticker (noTicker): " + e.getMessage());
		}
		assertNull(ticker);
		
		//Need to test a single current ticker
		Game singleTicker = null;
		try{
			singleTicker = gf.fetchGame(1);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching singleTicker game: " + e.getMessage());
		}
		try {
			ticker = tf.fetchCurrentTicker(singleTicker);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching current ticker (singleTicker): " + e.getMessage());
		}
		assertNotNull(ticker);
		assertEquals(ticker.getMessage(), "This is a single test message");
		
		//Need to test a single active ticker (some not active stored).
		ticker = null;
		Game multiTicker = null;
		try{
			multiTicker = gf.fetchGame(1);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching multiTicker game: " + e.getMessage());
		}
		try {
			ticker = tf.fetchCurrentTicker(multiTicker);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching current ticker (multiTicker): " + e.getMessage());
		}
		assertNotNull(ticker);
		assertEquals(ticker.getMessage(), "Early message");
		//Need to test for multiple current tickers
		ticker = null;
		Game multiActiveTicker = null;
		try{
			multiActiveTicker = gf.fetchGame(1);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching multiActiveTicker game: " + e.getMessage());
		}
		try {
			ticker = tf.fetchCurrentTicker(multiActiveTicker);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem fetching current ticker (multiActiveTicker): " + e.getMessage());
		}
		assertNotNull(ticker);
		assertEquals("Latest message", ticker.getMessage());
	}
	
	@Test
	public void testFetchActive() {
		TickerFactory tf = new TickerFactory();
		Set<Ticker> tickers = null;
		try {
			tickers = tf.fetchActiveTickers();
		} catch (Exception e){
			e.printStackTrace();
			fail("Problem getting the active tickers: " + e.getMessage());
		}
		assertNotNull(tickers);
		assertEquals(5, tickers.size());
	}
	
	@Test
	public void testCreateTicker() {
		TickerFactory tf = new TickerFactory();
		PlayerCharFactory pcf = new PlayerCharFactory();
		PlayerChar pc = new PlayerChar();
		try {
			pc = pcf.fetchPlayerChar(1);
		} catch (Exception e) {
			e.printStackTrace();
			fail("There was a problem with the player char.");
		}
		
		try {
			Ticker ticker = tf.createTicker(pc, "this is a test", (double) 60);
			assertNotNull(ticker);
			assertNotSame(0, ticker.getId());
		} catch (Exception e) {
			e.printStackTrace();
			fail ("There was a problem creating the thingummy.");
		}
	}

}
