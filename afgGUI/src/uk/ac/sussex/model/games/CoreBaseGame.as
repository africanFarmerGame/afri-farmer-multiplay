package uk.ac.sussex.model.games {
	import uk.ac.sussex.states.*;
	import uk.ac.sussex.view.ApplicationMediator;
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import uk.ac.sussex.model.games.BaseGame;

	/**
	 * @author em97
	 */
	public class CoreBaseGame extends BaseGame {
		public static const TYPE:String = "CORE-GAME";
		public function CoreBaseGame() {
			super();
			this.setGameType(TYPE);
		}
		override public function registerGameStates(facade:IFacade, appMediator:ApplicationMediator, banker:Boolean):void {
			appMediator.registerState(new JoinGameGameState(facade));
			appMediator.registerState(new VillageGameState(facade));
			appMediator.registerState(new BankGameState(facade));
			appMediator.registerState(new FinesGameState(facade));
			appMediator.registerState(new HomeGameState(facade));
			appMediator.registerState(new MarketGameState(facade));
			appMediator.registerState(new FarmGameState(facade));
			appMediator.registerState(new GameSettingsGameState(facade));
			appMediator.registerState(new FoodGameState(facade));
			appMediator.registerState(new DietGameState(facade));
			appMediator.registerState(new TaskGameState(facade));
			appMediator.registerState(new AllocationGameState(facade));
			//Register the game manager states only if this is a game manager.
			if(banker){
				appMediator.registerState(new BankManagerGameState(facade));
				appMediator.registerState(new MarketManagerGameState(facade));
				appMediator.registerState(new VillageManagerGameState(facade));
				appMediator.registerState(new HomeManagerGameState(facade));
				appMediator.registerState(new FarmManagerGameState(facade));
				appMediator.registerState(new FinesManagerGameState(facade));
			}
		}
	}
}
