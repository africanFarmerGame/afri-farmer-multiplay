/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view {
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import uk.ac.sussex.model.valueObjects.DietItem;
	import uk.ac.sussex.model.valueObjects.Diet;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.view.components.DietContentList;
	import uk.ac.sussex.model.DietListProxy;
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	/**
	 * @author em97
	 */
	public class DietContentListMediator extends Mediator implements IMediator {
		public static const NAME:String = "DietContentListMediator";
		
		private var dietListProxy:DietListProxy;
		
		public function DietContentListMediator() {
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
					var diet:Diet = dietListProxy.getCurrentDiet();
					if(diet!=null){
						this.displayContentList(diet);
					} else {
						dietContentList.updateContents("");
					}
					break;
				case HomeHandlers.DISPLAY_DIET:
					var display:Diet = note.getBody() as Diet;
					if(display!=null){
						this.displayContentList(display);
						sendNotification(ViewAreaMediator.ADD_VIEW_COMPONENT, dietContentList);
					} else {
						dietContentList.updateContents("");
						sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, dietContentList);
					}
					break;
			}
		}
		private function displayContentList(diet:Diet):void {
			var diarray:Array = diet.getDietItems();
			var contentList:String = "";
			for each (var di:DietItem in diarray){
				if(di.getAmount() > 0){
					var ga:GameAsset = di.getAsset();
					contentList = contentList.concat(di.getAmount() + "m ");
					contentList = contentList.concat(ga.getName() + "\n");
				}
			}
			dietContentList.updateContents(contentList);
		}
		protected function get dietContentList():DietContentList {
			return viewComponent as DietContentList;
		}
		override public function onRegister():void {
			
			viewComponent = new DietContentList();
			
			var submenuMediator:SubMenuMediator = facade.retrieveMediator(SubMenuMediator.NAME) as SubMenuMediator;
			dietContentList.x = submenuMediator.getSubmenuWidth() + 6;
			dietContentList.y = 65;
			sendNotification(ViewAreaMediator.ADD_VIEW_COMPONENT, dietContentList);
			
			dietListProxy = facade.retrieveProxy(DietListProxy.NAME) as DietListProxy;
			
		}
		override public function onRemove():void {
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, dietContentList);
		
		}
	}
}
