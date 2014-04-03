/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view {
	import flash.display.*;
	
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import uk.ac.sussex.general.ApplicationFacade;

	/**
	 * @author em97
	 */
	public class ControlsMediator extends Mediator implements IMediator {
		public static const NAME:String = "ControlsMediator";
		//private static const TOP_Y:Number = 0;
		//private static const BOTTOM_Y:Number = 350;
		//private static const CONTROL_MARGIN:Number = 10;
		//private var nextX:Number = 0;
		public function ControlsMediator(viewComponent : Object = null) {
			super(NAME, viewComponent);
		}
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.ADD_TO_CONTROLS, 
				ApplicationFacade.RESET_CONTROLS
					];
		}
		override public function handleNotification (note:INotification):void {
			switch ( note.getName() ) {
				//Could eventually split this into different locations (e.g. top strip of controls and bottom?)
				case ApplicationFacade.ADD_TO_CONTROLS:
					var child:Sprite = note.getBody() as Sprite;
					if(child != null){
						controlsLayer.addChild(child);
					}
					break;
				case ApplicationFacade.RESET_CONTROLS:
					//this.nextX = 0;
					break;
			}
		}
		
		//Cast the viewComponent to the correct type.
		protected function get controlsLayer():MovieClip {
			return viewComponent as MovieClip;
		}
		override public function onRegister():void
		{
			viewComponent = new MovieClip();
			sendNotification(ApplicationFacade.ADD_TO_BASE, controlsLayer);
		}
		override public function onRemove():void
		{
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, controlsLayer);
			//nextX = 0;
		}
	}
}

