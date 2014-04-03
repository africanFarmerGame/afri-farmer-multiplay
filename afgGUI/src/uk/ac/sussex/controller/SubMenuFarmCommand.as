/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.HearthAsset;
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import uk.ac.sussex.model.HearthAssetListProxy;
	import uk.ac.sussex.states.TaskGameState;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.serverhandlers.FarmHandlers;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SubMenuFarmCommand extends SimpleCommand {
		override public function execute( note:INotification ):void {
			
			var subMenuItem:String = note.getBody() as String;
			trace("SubMenuFarmCommand sez: Trying to fire off " + subMenuItem);
			switch(subMenuItem){
				case FarmHandlers.SUB_MENU_STOCKS:
					listStocks();
					break;
				case FarmHandlers.SUB_MENU_SUMMARY:
					sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, "Farm:\nHere you can monitor the health of your crops and access the task menu to assign and review tasks.");
					break;
				case FarmHandlers.SUB_MENU_TASKS:
					sendNotification(ApplicationFacade.CHANGE_STATE, TaskGameState.NAME);
					break;
			}
			
		}
		
		private function listStocks():void{
			var output:String = "Stocks:\n\n";
			var hearthAssetsLP:HearthAssetListProxy = facade.retrieveProxy(HearthAsset.OWNER_HEARTH + HearthAssetListProxy.NAME) as HearthAssetListProxy;
			if(hearthAssetsLP!=null){
				var hearthAssets:Array = hearthAssetsLP.fetchHearthAssets();
				for each (var asset:HearthAsset in hearthAssets){
					var gameAsset:GameAsset = asset.getAsset();
					output += asset.getAmount() + " " + gameAsset.getMeasurement() + "(s) " + gameAsset.getName() + "\n";
				}
			} else {
				throw new Error("Hearth assets list proxy was null.");
			}
			sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, output);
		}
	}
}