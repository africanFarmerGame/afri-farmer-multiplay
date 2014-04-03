/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view {
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import flash.display.MovieClip;
	import uk.ac.sussex.general.ApplicationFacade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.interfaces.IMediator;

	/**
	 * @author em97
	 */
	public class DragLayerMediator extends Mediator implements IMediator {
		public static const NAME:String = "DragMediator";
		public static const DRAG_STOPPED:String = "DragLayerStopDrag";
		
		private var dragItem:MovieClip;
		
		public function DragLayerMediator(mediatorName : String = null, viewComponent : Object = null) {
			super(mediatorName, viewComponent);
		}
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.ADD_TO_DRAGLAYER, 
				ApplicationFacade.CLEAR_DRAGLAYER,
				ApplicationFacade.FLOAT_UI_ITEM
					];
		}
		override public function handleNotification (note:INotification):void {
			switch ( note.getName() ) {
				case ApplicationFacade.ADD_TO_DRAGLAYER:
				trace("DragLayerMediator sez: I'm trying to addtoDRaglayer");
					sendNotification(ApplicationFacade.ADD_TO_BASE, dragLayer);
					var child:MovieClip = note.getBody() as MovieClip;
					if(child != null){
						child.x = dragLayer.mouseX - 0.5*child.width;
						child.y = dragLayer.mouseY - 0.5*child.height;
						dragItem = child;
						child.startDrag();
						dragLayer.addEventListener(MouseEvent.MOUSE_UP, stopDrag);
						//dragLayer.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
						dragLayer.addChild(child);
					}
					break;
				case ApplicationFacade.CLEAR_DRAGLAYER:
					clearLayer();
					break;
				case ApplicationFacade.FLOAT_UI_ITEM:
					sendNotification(ApplicationFacade.ADD_TO_BASE, dragLayer);
					var floater:MovieClip = note.getBody() as MovieClip;
					if(floater==null){
						throw new Error("Object to float is null.");
					}
					floatItem(floater);
					break;
			}
		}
		private function stopDrag(e:MouseEvent):void {
			//This should clear everything from the draglayer I thnk. 
			//clearLayer();
			dragItem.stopDrag();
			sendNotification(DRAG_STOPPED, dragItem );
			clearLayer();
		}
		private function floatItem(item:MovieClip):void{
			trace("DragLayerMediator sez: I should be floating something");
			trace("DragLayerMediator sez: I think my item should currently be at " + item.x + ", " + item.y);
			var globalPoint:Point = item.localToGlobal(new Point(0,0));
			item.x = globalPoint.x;
			item.y = globalPoint.y;
			trace("DragLayerMediator sez: I think my item should be at " + globalPoint.x + ", " + globalPoint.y);
			dragLayer.addChild(item);
		}
		/*
		private function mouseOut(e:MouseEvent):void {
			trace("DragLayerMediator sez: I think I've had a mouseout event");
			clearLayer();
		}*/
		private function clearLayer():void {
			//Remove all children from this layer. 
			var childCounter:int = dragLayer.numChildren - 1;
			for(childCounter;childCounter >= 0; childCounter --){
				dragLayer.removeChildAt(childCounter);
			}
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, dragLayer);
		}
		//Cast the viewComponent to the correct type.
		protected function get dragLayer():MovieClip {
			return viewComponent as MovieClip;
		}
		override public function onRegister():void
		{
			viewComponent = new MovieClip();
			var appMediator:ApplicationMediator = facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
			dragLayer.graphics.beginFill(0x000000, 0);
			dragLayer.graphics.drawRect(0, 0, appMediator.getDisplayWidth(), appMediator.getDisplayHeight());
			dragLayer.graphics.endFill();
		}
		override public function onRemove():void
		{
			clearLayer();
			dragLayer.removeEventListener(MouseEvent.MOUSE_UP, stopDrag);
			//dragLayer.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, dragLayer);
		}
	}
}
