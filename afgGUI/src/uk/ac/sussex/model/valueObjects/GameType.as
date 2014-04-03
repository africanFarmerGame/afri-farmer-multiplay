package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class GameType {
		private var gameType:String;
		private var gameTypeDisplay:String;
		public function GameType():void {
			
		}
		public function getGameType():String {
			return gameType;
		}
		public function setGameType(newGameType:String):void {
			this.gameType = newGameType;
		}
		public function getGameTypeDisplay():String {
			return this.gameTypeDisplay;
		}
		public function setGameTypeDisplay(newGameTypeDisplay:String):void {
			this.gameTypeDisplay = newGameTypeDisplay;
		}
	}
}
