/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view {
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.model.valueObjects.Diet;
	import uk.ac.sussex.view.components.NutritionGraph;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.DietListProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.interfaces.IMediator;

	/**
	 * @author em97
	 */
	public class NutritionGraphMediator extends Mediator implements IMediator {
		public static const NAME:String = "NutritionGraphMediator";
		
		private var dietListProxy:DietListProxy;
		
		public function NutritionGraphMediator() {
			trace("NutritionGraphMediator sez: I am created now");
			super(NAME, null);
		}
		override public function listNotificationInterests():Array {
			return [DietListProxy.CURRENT_DIET_CHANGED,
					DietListProxy.CURRENT_DIET_UPDATED,
					HomeHandlers.DISPLAY_DIET 
					];
		}
		override public function handleNotification (note:INotification):void {
			switch (note.getName()){
				case DietListProxy.CURRENT_DIET_CHANGED:
				case DietListProxy.CURRENT_DIET_UPDATED:
					var currentDiet:Diet = dietListProxy.getCurrentDiet();
					if(currentDiet==null){
						nutritionGraph.reset();
					} else {
						updateNutritionGraph(currentDiet);
					}
					break;
				case HomeHandlers.DISPLAY_DIET:
					var displayDiet:Diet = note.getBody() as Diet;
					if(displayDiet == null){
						nutritionGraph.reset();
						sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, nutritionGraph);
					} else {
						updateNutritionGraph(displayDiet);
						sendNotification(ViewAreaMediator.ADD_VIEW_COMPONENT, nutritionGraph);
					}
					break;
			}
		}
		private function updateNutritionGraph(diet:Diet):void{
			nutritionGraph.updateCarbBar(diet.getCarbLevel(), diet.getCarbDelta());
			nutritionGraph.updateNutrientBar(diet.getNutrientLevel(), diet.getNutrientDelta());
			nutritionGraph.updateProteinBar(diet.getProteinLevel(), diet.getProteinDelta());
		}
		protected function get nutritionGraph():NutritionGraph {
			return viewComponent as NutritionGraph;
		}
		override public function onRegister():void {
			viewComponent = new NutritionGraph();
			var submenuMediator:SubMenuMediator = facade.retrieveMediator(SubMenuMediator.NAME) as SubMenuMediator;
			nutritionGraph.x = submenuMediator.getSubmenuWidth();
			nutritionGraph.y = 192;
			sendNotification(ViewAreaMediator.ADD_VIEW_COMPONENT, nutritionGraph);
			
			dietListProxy = facade.retrieveProxy(DietListProxy.NAME) as DietListProxy;
			
		}
		override public function onRemove():void {
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, nutritionGraph);
		}
	}
}
