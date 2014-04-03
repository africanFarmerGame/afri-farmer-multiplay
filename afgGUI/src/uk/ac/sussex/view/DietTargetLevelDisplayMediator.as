/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view {
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.model.valueObjects.Diet;
	import uk.ac.sussex.model.DietListProxy;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.view.components.DietTargetLevelDisplay;
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	/**
	 * @author em97
	 */
	public class DietTargetLevelDisplayMediator extends Mediator implements IMediator {
		public static const NAME:String = "DietTargetLevelDisplayMediator";
		
		private var dietListProxy:DietListProxy;
		
		public function DietTargetLevelDisplayMediator() {
			super(NAME, null);
		}
		override public function listNotificationInterests():Array {
			return [ DietListProxy.CURRENT_DIET_CHANGED, 
					 DietListProxy.CURRENT_DIET_UPDATED, 
					 HomeHandlers.DISPLAY_DIET
					];
		}
		override public function handleNotification (note:INotification):void {
			switch ( note.getName() ) {
				case DietListProxy.CURRENT_DIET_CHANGED:
				case DietListProxy.CURRENT_DIET_UPDATED:
					var diet:Diet = dietListProxy.getCurrentDiet();
					if(diet==null){
						dietTargetLevelDisplay.reset();
					} else {
						setDetail(diet);
					}
					break;
				case HomeHandlers.DISPLAY_DIET:
					var displayDiet:Diet = note.getBody() as Diet;
					if(displayDiet == null){
						sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, dietTargetLevelDisplay);
					} else {
						setDetail(displayDiet);
						sendNotification(ViewAreaMediator.ADD_VIEW_COMPONENT, dietTargetLevelDisplay);
					}
			}
		}
		private function setDetail(diet:Diet):void {
			dietTargetLevelDisplay.setDietLevel(diet.getDietLevel());
			dietTargetLevelDisplay.setDietType(diet.getTarget());
		}
		//Cast the viewComponent to the correct type.
		protected function get dietTargetLevelDisplay():DietTargetLevelDisplay {
			return viewComponent as DietTargetLevelDisplay;
		}
		override public function onRegister():void
		{
			viewComponent = new DietTargetLevelDisplay();
			dietTargetLevelDisplay.x = 220;
			dietTargetLevelDisplay.y = 65;

			dietListProxy = facade.retrieveProxy(DietListProxy.NAME) as DietListProxy;

			sendNotification(ViewAreaMediator.ADD_VIEW_COMPONENT, dietTargetLevelDisplay);
		}
		override public function onRemove():void
		{
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, dietTargetLevelDisplay);
		}
	}
}
