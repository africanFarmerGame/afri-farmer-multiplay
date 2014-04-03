/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view {
	import flash.display.MovieClip;
	import uk.ac.sussex.view.components.ViewArea;
	import uk.ac.sussex.general.ApplicationFacade;
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	/**
	 * @author em97
	 */
	public class ViewAreaMediator extends Mediator implements IMediator {
		public static const NAME:String = "ViewAreaMediator";
		public static const ADD_VIEW_COMPONENT:String = "AddViewComponent";
		public static const REFRESH_VIEW_COMPONENT:String = "RefreshViewComponent";
		
		public function ViewAreaMediator( viewComponent : Object = null) {
			super(NAME, viewComponent);
		}
		override public function listNotificationInterests():Array {
			return [ ADD_VIEW_COMPONENT, 
					 REFRESH_VIEW_COMPONENT 
					];
		}
		
		override public function handleNotification (note:INotification):void {
			switch(note.getName()){
				case ADD_VIEW_COMPONENT:
					var newChild:MovieClip = note.getBody() as MovieClip;
					if(newChild != null){
						viewArea.addToContainer(newChild);
					}
					break;
				case REFRESH_VIEW_COMPONENT:
					viewArea.refreshContainer();
					break;
			}
		}
		/*public function resizeComponent(newWidth:Number, newHeight:Number):void{
			if (viewArea == null){
				viewComponent = new ViewArea();
			}
			viewArea.resizeArea(newWidth, newHeight);
		}*/
		public function setPosition(x:Number, y:Number):void {
			viewArea.x = x;
			viewArea.y = y;
		}
		//Cast the viewComponent to the correct type.
		protected function get viewArea():ViewArea {
			return viewComponent as ViewArea;
		}
		override public function onRegister():void
		{
			if (viewArea == null){
				var appMediator:ApplicationMediator = facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
				viewComponent = new ViewArea(appMediator.getLeftWidth(), appMediator.getCentreHeight());
			}
			
			sendNotification(ApplicationFacade.ADD_TO_SCREEN, viewArea);
		}
		override public function onRemove():void
		{
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, viewArea);
		}
		
	}
}
