package uk.ac.sussex.view {
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.interfaces.*;

	import flash.events.Event;

	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.view.components.DisplayMessagePanel;
	/**
	 * @author em97
	 */
	public class DisplayMessagePanelMediator extends Mediator implements IMediator {
		public static const NAME:String = "DisplayMessagePanelMediator";
		public function DisplayMessagePanelMediator(viewComponent : Object = null) {
			// constructor code
			super(NAME, viewComponent);
		}

		override public function listNotificationInterests():Array {
			//return [ApplicationFacade.DISPLAY_MESSAGE];
			return [];
		}
		
		override public function handleNotification (note:INotification):void {
			switch(note.getName()){
				case ApplicationFacade.DISPLAY_MESSAGE:
					var displayText:String = note.getBody() as String;
					if(displayText != null){
						displayMessagePanel.addEventListener(DisplayMessagePanel.CLOSE_BUTTON_CLICK, closeMe);
						displayMessagePanel.setDisplayText(note.getBody() as String);
						displayMessagePanel.x = 25;
						displayMessagePanel.y = 25;
						sendNotification(ApplicationFacade.ADD_TO_OVERLAY, displayMessagePanel);
					}					
					break;
			}
		}
		private function closeMe(e:Event):void{
			displayMessagePanel.removeEventListener(DisplayMessagePanel.CLOSE_BUTTON_CLICK, closeMe);
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, displayMessagePanel);
		}
		//Cast the viewComponent to the correct type.
		protected function get displayMessagePanel():DisplayMessagePanel {
			return viewComponent as DisplayMessagePanel;
		}
		
		override public function onRegister():void
		{
			viewComponent = new DisplayMessagePanel();
			
		}
		override public function onRemove():void
		{
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, displayMessagePanel);
		}
	}
}
