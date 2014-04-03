/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
