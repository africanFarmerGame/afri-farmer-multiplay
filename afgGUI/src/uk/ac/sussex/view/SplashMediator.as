/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view {
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.view.components.SplashScreen;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.interfaces.IMediator;

	/**
	 * @author em97
	 */
	public class SplashMediator extends Mediator implements IMediator {
		public static const NAME:String = "SplashScreenMediator";
		
		public function SplashMediator() {
			// constructor code
			super(NAME, null);
		}
		//Cast the viewComponent to the correct type.
		protected function get splashScreen():SplashScreen {
			return viewComponent as SplashScreen;
		}
		override public function onRegister():void
		{
			viewComponent = new SplashScreen();
			
			sendNotification(ApplicationFacade.ADD_TO_SCREEN, splashScreen);
		}
		override public function onRemove():void
		{
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, splashScreen);
		}
	}
}
