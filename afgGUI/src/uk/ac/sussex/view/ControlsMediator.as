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

