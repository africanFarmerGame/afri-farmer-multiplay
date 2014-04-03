/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.IncomingDataProxy;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.model.GameAssetListProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class GameAssetListReceivedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("GameAssetListReceivedCommand sez: I was fired.");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var gameAssets:Array = incomingData.getParamValue("GameAssets") as Array;
			var gameAssetsFood:Array = incomingData.getParamValue("GameAssetsFood") as Array;
			var gameAssetsCrop:Array = incomingData.getParamValue("GameAssetsCrop") as Array;
			var gameAssetListProxy:GameAssetListProxy = facade.retrieveProxy(GameAssetListProxy.NAME) as GameAssetListProxy;
			if(gameAssetListProxy == null){
				gameAssetListProxy = new GameAssetListProxy();
				facade.registerProxy(gameAssetListProxy);
			}
			gameAssetListProxy.addGameAssets(gameAssets);
			gameAssetListProxy.addFoodAssets(gameAssetsFood);
			gameAssetListProxy.addCropAssets(gameAssetsCrop);
			facade.removeProxy(HomeHandlers.GET_GAME_ASSETS + RequestProxy.NAME);
			facade.removeProxy(HomeHandlers.GAME_ASSETS_LIST_RECEIVED + IncomingDataProxy.NAME);
			facade.removeCommand(HomeHandlers.GAME_ASSETS_LIST_RECEIVED);
		}
	}
}
