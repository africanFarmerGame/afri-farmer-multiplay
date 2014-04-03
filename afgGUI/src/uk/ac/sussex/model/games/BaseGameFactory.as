package uk.ac.sussex.model.games {
	/**
	 * @author em97
	 */
	public class BaseGameFactory {
	
		public function getBaseGame(gameType:String):BaseGame {
			switch(gameType){
				case CoreBaseGame.TYPE:
					return new CoreBaseGame();
				case AfriBaseGame.TYPE:
					return new AfriBaseGame();
				default:
					throw new Error (gameType + " is not a supported game type.");
			}
		}
	}
}
