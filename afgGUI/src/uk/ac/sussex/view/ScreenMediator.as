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

