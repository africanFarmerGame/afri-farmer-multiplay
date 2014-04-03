/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view {
	import flash.display.MovieClip;
	
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import uk.ac.sussex.general.ApplicationFacade;

	/**
	 * @author em97
	 */
	public class ScreenMediator extends Mediator implements IMediator {
		public static const NAME:String = "ScreenMediator";
		public function ScreenMediator(viewComponent : Object = null) {
			super(NAME, viewComponent);
		}
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.ADD_TO_SCREEN
					];
		}
		override public function handleNotification (note:INotification):void {
			switch ( note.getName() ) {
				case ApplicationFacade.ADD_TO_SCREEN:
				
					var child:MovieClip = note.getBody() as MovieClip;
					if(child != null){
						trace("got a movieClip?");
						screenLayer.addChild(child);
					}
			}
		}
		//Cast the viewComponent to the correct type.
		protected function get screenLayer():MovieClip {
			return viewComponent as MovieClip;
		}
		override public function onRegister():void
		{
			viewComponent = new MovieClip();

			sendNotification(ApplicationFacade.ADD_TO_BASE, screenLayer);
		}
		override public function onRemove():void
		{
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, screenLayer);
		}
	}
}

