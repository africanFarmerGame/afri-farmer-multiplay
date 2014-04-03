package uk.ac.sussex.handlers;

public enum MarketMultiEnum {
	MANAGE_MARKET_ASSETS, PLAYER_MARKET_ASSETS, UPDATE_MARKET_ASSET, PLAYER_CURRENT_ASSETS,SUBMIT_BUY_REQUEST, SUBMIT_SELL_REQUEST, NOVALUE, ;
	
	/**
	 * Basically this is to allow me to do different things depending on which 
	 * method is called to the multihandler. Stupid switch not supporting strings. Pah.
	 * @param input
	 * @return
	 */
	public static MarketMultiEnum toOption(String input){
		try {
			return valueOf(input.toUpperCase());
		} catch (Exception e) {
			return NOVALUE;
		}
	}
}
