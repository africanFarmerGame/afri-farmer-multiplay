/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view {
	import uk.ac.sussex.serverhandlers.SeasonsHandlers;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.view.components.GameYearDisplay;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.interfaces.IMediator;

	/**
	 * @author em97
	 */
	public class GameYearMediator extends Mediator implements IMediator {
		public static const NAME:String = "GameYearMediator";
		
		public function GameYearMediator() {
			super(NAME, null);
		}
		override public function listNotificationInterests():Array {
			return [SeasonsHandlers.UPDATE_GAME_YEAR];
		}
		override public function handleNotification (note:INotification):void {
			switch (note.getName()){
				case SeasonsHandlers.UPDATE_GAME_YEAR:
					var gameYear:int = note.getBody() as int;
					gameYearDisplay.setGameYearNumber(gameYear);
					break;
			}
		}
		//Cast the viewComponent to the correct type.
		protected function get gameYearDisplay():GameYearDisplay {
			return viewComponent as GameYearDisplay;
		}
		override public function onRegister():void
		{
			viewComponent = new GameYearDisplay();
			var gameMediator:ApplicationMediator = facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
			var xpos:Number = gameMediator.getLeftWidth(); //+ gameMediator.getRightWidth() - logoutButton.width - 23;
			
			gameYearDisplay.x = xpos + 16;
			gameYearDisplay.y = 2;
			
			sendNotification(ApplicationFacade.ADD_TO_CONTROLS, gameYearDisplay);
		}
		override public function onRemove():void
		{
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, gameYearDisplay);
		}
	}
}
