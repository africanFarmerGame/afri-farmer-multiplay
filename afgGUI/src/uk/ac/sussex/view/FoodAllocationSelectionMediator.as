/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view {
	import uk.ac.sussex.view.components.FoodAllocationSelection;
	import uk.ac.sussex.general.ApplicationFacade;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	/**
	 * @author em97
	 */
	public class FoodAllocationSelectionMediator extends Mediator implements IMediator {
		public static const NAME:String = "TableTopDisplayMediator";
		
		
		
		public function FoodAllocationSelectionMediator() {
			super(NAME, new FoodAllocationSelection());
		}
		protected function get foodAllocationSelection():FoodAllocationSelection  {
			return viewComponent as FoodAllocationSelection;
		}
		override public function onRegister():void {
			var submenuMediator:SubMenuMediator = facade.retrieveMediator(SubMenuMediator.NAME) as SubMenuMediator;
			
			foodAllocationSelection.x = submenuMediator.getSubmenuWidth();
			foodAllocationSelection.y = 10;
			
			sendNotification(ViewAreaMediator.ADD_VIEW_COMPONENT, foodAllocationSelection);
		}
		override public function onRemove():void {
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, foodAllocationSelection);
		}
	}
}
