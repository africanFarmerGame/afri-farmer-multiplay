package uk.ac.sussex.view {
	import uk.ac.sussex.view.components.ViewSideInfoPanel;
	import uk.ac.sussex.view.components.ViewTitleText;
	import uk.ac.sussex.general.ApplicationFacade;
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	/**
	 * This class controls the display of the view title and view side panel. 
	 * @author em97
	 */
	public class ViewTextDisplayMediator extends Mediator implements IMediator {
		public static const NAME:String = "ViewTextDisplayMediator";
		
		private static const INFO_SIDEPANEL_X:Number = 740;
		private static const INFO_SIDEPANEL_Y:Number = 139;
		private var viewSideInfoPanel:ViewSideInfoPanel;
		
		
		public function ViewTextDisplayMediator(viewComponent : Object) {
			super(NAME, viewComponent);
		}
		override public function listNotificationInterests():Array {
			return [ApplicationFacade.DISPLAY_INFO_TEXT, 
					ApplicationFacade.DISPLAY_TEMP_INFO_TEXT, 
					ApplicationFacade.REVERT_TEMP_INFO_TEXT, 
					ApplicationFacade.CLEAR_INFO_TEXT];
		}
		override public function handleNotification (note:INotification):void {
			switch(note.getName()){
				case ApplicationFacade.DISPLAY_INFO_TEXT:
					var displayText:String = note.getBody() as String;
					this.displayViewInfoText(displayText);
					break;
				case ApplicationFacade.DISPLAY_TEMP_INFO_TEXT:
					var tempText:String = note.getBody() as String;
					this.displayTempInfoText(tempText);
					break;
				case ApplicationFacade.REVERT_TEMP_INFO_TEXT:
					viewSideInfoPanel.revertText();
					break;
				case ApplicationFacade.CLEAR_INFO_TEXT:
					this.clearText();
					break;
			}
		}
		public function displayViewTitle(viewTitle:String):void {
			if(viewTitleText == null){
				viewComponent = new ViewTitleText();
			}
			viewTitleText.newTitleText(viewTitle);
		}
		private function clearText():void {
			viewSideInfoPanel.clearPanel();
		}
		private function displayTempInfoText(tempInfoText:String):void {
			//Save current text.
			viewSideInfoPanel.cacheText();
			//Display new text.
			viewSideInfoPanel.newSideText(tempInfoText);
		}
		private function displayViewInfoText(viewInfoText:String):void {
			if(viewSideInfoPanel == null){
				setupSideInfoPanel();
			}
			viewSideInfoPanel.newSideText(viewInfoText);
		}
		private function setupSideInfoPanel():void {
			viewSideInfoPanel = new ViewSideInfoPanel();
			viewSideInfoPanel.x = INFO_SIDEPANEL_X;
			viewSideInfoPanel.y = INFO_SIDEPANEL_Y;
		}
		override public function onRegister():void
		{
			viewComponent = new ViewTitleText();
			if(viewSideInfoPanel == null){
				setupSideInfoPanel();
			}
			
			var appMediator:ApplicationMediator = facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
			
			viewTitleText.x = 10; 
			viewTitleText.y = appMediator.getTopHeight() - viewTitleText.height;
			
			sendNotification(ApplicationFacade.ADD_TO_CONTROLS, viewTitleText);
			sendNotification(ApplicationFacade.ADD_TO_CONTROLS, viewSideInfoPanel);
		}
		override public function onRemove():void
		{
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, viewTitleText);
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, viewSideInfoPanel);
		}
		protected function get viewTitleText():ViewTitleText {
			return viewComponent as ViewTitleText;
		}
	}
}
