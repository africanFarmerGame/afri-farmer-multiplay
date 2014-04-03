/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view {
	import uk.ac.sussex.states.VillageGameState;
	import uk.ac.sussex.states.HomeGameState;
	import uk.ac.sussex.view.components.BackgroundMC;
	import uk.ac.sussex.general.ApplicationFacade;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.interfaces.IMediator;

	/**
	 * @author em97
	 */
	public class BackgroundMediator extends Mediator implements IMediator {
		public static const NAME:String = "BackgroundMediator";
		
		private static const HOME_FRAME:String = "HOUSEHOLD";
		private static const VILLAGE_FRAME:String = "VILLAGE";
		private static const DEFAULT_FRAME:String = "DEFAULT";
		
		public function BackgroundMediator() {
			super(NAME, viewComponent);
		}
		override public function listNotificationInterests():Array {
			return [];
		}
		override public function handleNotification (note:INotification):void {
			switch(note.getName()){
			}
		}
		public function setBackground(viewName:String):void {
			switch(viewName){
				case HomeGameState.NAME:
					background.gotoAndStop(HOME_FRAME);
					break;
				case VillageGameState.NAME:
					background.gotoAndStop(VILLAGE_FRAME);
					break;
				default:
					background.gotoAndStop(DEFAULT_FRAME);
			}
		}
		override public function onRegister():void
		{
			viewComponent = new BackgroundMC();
			var appMediator:ApplicationMediator = facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
			var scaleX:Number = appMediator.getDisplayWidth() / background.width;
			
			background.scaleX = background.scaleY = scaleX;
			
			setBackground("");	
			sendNotification(ApplicationFacade.ADD_TO_BASE, background);
		}
		override public function onRemove():void
		{
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, background);
		}
		protected function get background():BackgroundMC {
			return viewComponent as BackgroundMC;
		}
	}
}
