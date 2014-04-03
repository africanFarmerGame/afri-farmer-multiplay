package uk.ac.sussex.controller {
	import flash.display.MovieClip;
	import uk.ac.sussex.view.ApplicationMediator;
	import uk.ac.sussex.view.OverlayDisplayPanelMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class DisplayOverlayFormCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var form:MovieClip = note.getBody() as MovieClip;
			trace("DisplayOverlayFormCommand sez: I was fired.");
			var overlayDisplayMediator:OverlayDisplayPanelMediator = facade.retrieveMediator(OverlayDisplayPanelMediator.NAME) as OverlayDisplayPanelMediator;
			var appMediator:ApplicationMediator = facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
			var maxWidth:Number = appMediator.getDisplayWidth() - 60;
			var maxHeight:Number = appMediator.getDisplayHeight() - 50;
						
			overlayDisplayMediator.resizePanel(maxWidth, maxHeight);
			overlayDisplayMediator.addToPanel(form, 0, 0);
			overlayDisplayMediator.displayPanel();
		}
	}
}
