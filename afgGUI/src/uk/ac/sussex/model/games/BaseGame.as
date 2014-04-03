package uk.ac.sussex.model.games {
	import uk.ac.sussex.view.ApplicationMediator;
	import org.puremvc.as3.multicore.interfaces.IFacade;
	/**
	 * @author em97
	 */
	public class BaseGame {
		private var gameType:String;
		
		public function BaseGame() {		
			
		}
		protected function setGameType(gameType:String):void {
			this.gameType = gameType;
		}
		public function getGameType():String {
			return this.gameType;
		}
		public function registerGameStates(facade:IFacade, appMediator:ApplicationMediator, banker:Boolean):void {
		
		}
		
	}
}
