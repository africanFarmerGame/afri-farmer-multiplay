/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import uk.ac.sussex.model.GameAssetListProxy;
	import uk.ac.sussex.model.valueObjects.HearthAsset;
	import uk.ac.sussex.model.HearthAssetListProxy;
	import uk.ac.sussex.serverhandlers.MarketHandlers;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class MarketPlayerAssetDetailsReceived extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("MarketPlayerAssetDetailsReceived Sez: I was fired. ");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var playerAssets:Array = incomingData.getParamValue(MarketHandlers.PC_ASSET_DETAILS) as Array;
			var hearthAssets:Array = incomingData.getParamValue(MarketHandlers.HEARTH_ASSET_DETAILS) as Array;
			var gameAssetsLP:GameAssetListProxy = facade.retrieveProxy(GameAssetListProxy.NAME) as GameAssetListProxy;
			if(playerAssets!= null && playerAssets.length>0){
				var playerAssetsLP:HearthAssetListProxy = facade.retrieveProxy(HearthAsset.OWNER_PC + HearthAssetListProxy.NAME) as HearthAssetListProxy;
				if(playerAssetsLP == null) {
					playerAssetsLP = new HearthAssetListProxy(HearthAsset.OWNER_PC);
					facade.registerProxy(playerAssetsLP);
				}
				for each (var pcAsset:HearthAsset in playerAssets){
					var pcGA:GameAsset = gameAssetsLP.getGameAsset(pcAsset.getAsset().getId());
					pcAsset.setAsset(pcGA);
					playerAssetsLP.addHearthAsset(pcAsset);
				}
			}
			if(hearthAssets!=null && hearthAssets.length > 0) {
				var hearthAssetsLP:HearthAssetListProxy = facade.retrieveProxy(HearthAsset.OWNER_HEARTH + HearthAssetListProxy.NAME) as HearthAssetListProxy;
				if(hearthAssetsLP == null) {
					hearthAssetsLP = new HearthAssetListProxy(HearthAsset.OWNER_HEARTH);
					facade.registerProxy(hearthAssetsLP);
				}
				for each (var hAsset:HearthAsset in hearthAssets){
					var assetId:int = hAsset.getAsset().getId();
					var hearthGA:GameAsset = gameAssetsLP.getGameAsset(assetId);
					hAsset.setAsset(hearthGA);
					hearthAssetsLP.addHearthAsset(hAsset);
				}
			}
		}
	}
}
