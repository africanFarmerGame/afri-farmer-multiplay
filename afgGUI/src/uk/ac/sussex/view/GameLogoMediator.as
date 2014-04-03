/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view {
	import flash.events.Event;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.view.components.GameLogo;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.interfaces.IMediator;

	/**
	 * @author em97
	 */
	public class GameLogoMediator extends Mediator implements IMediator {
		public static const NAME:String = "GameLogoMediator";
		private static const EDGE_BUFFER:int = 5;
		public function GameLogoMediator() {
			super(NAME, null);
		}
		private function gameLogoPressed(e:Event):void {
			sendNotification(ApplicationFacade.DISPLAY_GAME_INFO);
		}
		
		//Cast the viewComponent to the correct type.
		protected function get gameLogo():GameLogo {
			return viewComponent as GameLogo;
		}
		override public function onRegister():void
		{
			viewComponent = new GameLogo();
			gameLogo.addEventListener(GameLogo.GAME_LOGO_PRESSED, gameLogoPressed);
			var gameMediator:ApplicationMediator = facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
			var xpos:Number = gameMediator.getLeftWidth() + gameMediator.getRightWidth() - gameLogo.width - EDGE_BUFFER;
			gameLogo.x = xpos;
			gameLogo.y = EDGE_BUFFER +1;
			
			sendNotification(ApplicationFacade.ADD_TO_SCREEN, gameLogo);
		}
		override public function onRemove():void
		{
			gameLogo.removeEventListener(GameLogo.GAME_LOGO_PRESSED, gameLogoPressed);
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, gameLogo);
		}
	}
}
