package uk.ac.sussex.view {
	import uk.ac.sussex.view.components.ScrollingTextBox;
	import uk.ac.sussex.view.components.OverlayDisplayPanel;
	import flash.display.Sprite;
	import uk.ac.sussex.general.ApplicationFacade;
	import flash.events.Event;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	/**
	 * @author em97
	 */
	public class OverlayDisplayPanelMediator extends Mediator implements IMediator {
		public static const NAME:String = "OverlayDisplayPanelMediator";
		public function OverlayDisplayPanelMediator(viewComponent : Object = null) {
			super(NAME, viewComponent);
		}
		override public function listNotificationInterests():Array {
			return [	 
						ApplicationFacade.DISPLAY_ERROR_MESSAGE, 
						ApplicationFacade.DISPLAY_MESSAGE
					];
		}
		
		override public function handleNotification (note:INotification):void {
			switch ( note.getName() ) {
				
				case ApplicationFacade.DISPLAY_ERROR_MESSAGE:
					var errorMessage:String = note.getBody() as String;
					this.displayMessage(errorMessage, true);
					break;
				case ApplicationFacade.DISPLAY_MESSAGE:
					var message:String = note.getBody() as String;
					this.displayMessage(message, false);
					break;
			}
		}
		public function displayPanel():void {
			trace("OverlayDisplayPanelMediator sez: My x, y are " + overlayDisplayPanel.x + ", " + overlayDisplayPanel.y);
			sendNotification(ApplicationFacade.ADD_TO_OVERLAY, overlayDisplayPanel);
		}
		public function addToPanel(thing:Sprite, xPos:Number, yPos:Number):void{
			trace("OverlayDisplayPanelMediator sez: We are adding to the overlay");
			thing.x = xPos;
			thing.y = yPos;
			overlayDisplayPanel.resizeForThing(thing.width, thing.height);
			overlayDisplayPanel.addToDisplay(thing);
		}
		public function resizePanel(newWidth:Number, newHeight:Number):void{
			trace("OverlayDisplayPanelMediator sez: I am adjusting my size to " + newWidth + "x" + newHeight);
			overlayDisplayPanel.resizeMe(newWidth, newHeight);
		}
		private function closeMe(e:Event):void{
			overlayDisplayPanel.clearMe();
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, overlayDisplayPanel);
		}
		private function displayMessage(message:String, error:Boolean):void {
			trace("OverlayDisplayPanelMediator sez: I am displaying a message that is an error " + error);
			var appMediator:ApplicationMediator = facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
			var maxWidth:Number = appMediator.getDisplayWidth() - 150;
			var maxHeight:Number = appMediator.getDisplayHeight() - 150;

			this.resizePanel(maxWidth, maxHeight);
			
			trace("OverlayDisplayPanel sez: my new display height is " + overlayDisplayPanel.getDisplayHeight());
			trace("OverlayDisplayPanel sez: my new display width is " + overlayDisplayPanel.getDisplayWidth());
			
			var textBox:ScrollingTextBox = new ScrollingTextBox(overlayDisplayPanel.getDisplayWidth(), 
																overlayDisplayPanel.getDisplayHeight());
			trace("OverlayDisplayPanel sez: before updating the text content the height is " + textBox.height);
			if(error){
				textBox.setBorderColour(0xFF0000);
			} else {
				textBox.setBorderColour(0x000000);
			}
			textBox.showBackgroundFilter(false);
			textBox.setText(message);
			trace("OverlayDisplayPanel sez: after updating the text content the height is " + textBox.height);
			
			overlayDisplayPanel.addToDisplay(textBox);
			this.displayPanel();
		}
		//Cast the viewComponent to the correct type.
		protected function get overlayDisplayPanel():OverlayDisplayPanel {
			return viewComponent as OverlayDisplayPanel;
		}
		
		override public function onRegister():void
		{
			trace("OverlayDisplayPanelMediator sez: I has been registered");
			viewComponent = new OverlayDisplayPanel();
			overlayDisplayPanel.addEventListener(OverlayDisplayPanel.CLOSE_ME, closeMe);
		}
		override public function onRemove():void
		{
			trace("OverlayDisplayPanelMediator sez: I has been unregistered");
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, overlayDisplayPanel);
		}
	}
}
