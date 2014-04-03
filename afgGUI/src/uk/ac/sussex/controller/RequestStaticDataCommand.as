/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArrayGameAssetCrop;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArraySeasons;
	import uk.ac.sussex.serverhandlers.SeasonsHandlers;
	import uk.ac.sussex.model.SeasonsListProxy;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArrayGameAssetFood;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParamArrayGameAsset;
	import uk.ac.sussex.model.IncomingDataProxy;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.model.GameAssetListProxy;
	/**
	 * @author em97
	 */
	public class RequestStaticDataCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			//Send for the 'static' data. 
			var gameAssetListProxy:GameAssetListProxy = facade.retrieveProxy(GameAssetListProxy.NAME) as GameAssetListProxy;
			if(gameAssetListProxy == null){
				var gameAssetsRequest:RequestProxy = new RequestProxy(HomeHandlers.GET_GAME_ASSETS);
				facade.registerProxy(gameAssetsRequest);
				var incomingGameAssets:IncomingDataProxy = new IncomingDataProxy(HomeHandlers.GAME_ASSETS_LIST_RECEIVED, HomeHandlers.GAME_ASSETS_LIST_RECEIVED);
				incomingGameAssets.addDataParam(new DataParamArrayGameAsset("GameAssets"));
				incomingGameAssets.addDataParam(new DataParamArrayGameAssetFood("GameAssetsFood"));
				incomingGameAssets.addDataParam(new DataParamArrayGameAssetCrop("GameAssetsCrop"));
				facade.registerProxy(incomingGameAssets);
				facade.registerCommand(HomeHandlers.GAME_ASSETS_LIST_RECEIVED, GameAssetListReceivedCommand);
				gameAssetsRequest.sendRequest();
			}
			var seasonsListProxy:SeasonsListProxy =  facade.retrieveProxy(SeasonsListProxy.NAME) as SeasonsListProxy;
			if(seasonsListProxy == null){
				//Need to fetch the list of seasons.
				this.facade.registerCommand(SeasonsHandlers.SEASONS_LIST, SeasonsListReceived);
				seasonsListProxy = new SeasonsListProxy();
				facade.registerProxy(seasonsListProxy);
				var seasonsRequest:RequestProxy = new RequestProxy(SeasonsHandlers.GET_SEASONS);  
				this.facade.registerProxy(seasonsRequest);
				seasonsRequest.sendRequest();
			}
			var seasonsReceived:IncomingDataProxy = new IncomingDataProxy(SeasonsHandlers.SEASONS_LIST, SeasonsHandlers.SEASONS_LIST);
			seasonsReceived.addDataParam(new DataParamArraySeasons("AllSeasons"));
			this.facade.registerProxy(seasonsReceived);
		}
	}
}
