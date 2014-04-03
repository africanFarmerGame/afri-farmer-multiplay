/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view {
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	import uk.ac.sussex.states.PlayerRoomState;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import uk.ac.sussex.view.components.PlayerCharDetailPanel;
	import uk.ac.sussex.general.ApplicationFacade;
	/**
	 * @author em97
	 */
	public class PlayerCharDetailPanelMediator extends Mediator implements IMediator {
		public static const NAME:String = "PlayerCharDetailPanelMediator";
		public function PlayerCharDetailPanelMediator(viewComponent : Object = null) {
			super(NAME, viewComponent);
		}
		override public function listNotificationInterests():Array {
			return [
					PlayerRoomState.DISPLAY_PC_DETAIL
					];
		}
		
		override public function handleNotification (note:INotification):void {
			switch ( note.getName() ) {
				case PlayerRoomState.DISPLAY_PC_DETAIL:
					var data:IncomingData = note.getBody() as IncomingData;
					var pcName:String = data.getParamValue("charName" ) as String;
					var gameName:String = data.getParamValue("gameName") as String;
					var roleID:String = data.getParamValue("roleID") as String;
					trace("roleID = "+roleID);
					pcDetailPanel.displayPCName(pcName);
					pcDetailPanel.displayGameName(gameName);
					if(roleID!= null){
						pcDetailPanel.displayRole(roleID);
					}
					break;
			}
		}
		//Cast the viewComponent to the correct type.
		protected function get pcDetailPanel():PlayerCharDetailPanel{
			return viewComponent as PlayerCharDetailPanel;
		}
		override public function onRegister():void
		{
			if(pcDetailPanel == null) {
				viewComponent = new PlayerCharDetailPanel();
				sendNotification(ApplicationFacade.ADD_TO_CONTROLS, pcDetailPanel);
			}
		}
		override public function onRemove():void
		{
			sendNotification(ApplicationFacade.REMOVE_FROM_SCREEN, pcDetailPanel);
		}
	}
}
