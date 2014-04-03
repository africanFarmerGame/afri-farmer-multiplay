/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.serverhandlers.MarketHandlers;
	import uk.ac.sussex.view.SubMenuMediator;
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import uk.ac.sussex.model.GameAssetListProxy;
	import uk.ac.sussex.model.valueObjects.MarketAsset;
	import uk.ac.sussex.model.MarketAssetsListProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class DisplayPlayerMarketAssetsCommand extends SimpleCommand {
		override public function execute( note:INotification ):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var assets:Array = incomingData.getParamValue("AssetDetails") as Array;
			trace("DisplayPlayerMarketAssetsCommand sez: There are " + assets.length + " assets to display.");
			var marketAssetLP: MarketAssetsListProxy = facade.retrieveProxy(MarketAssetsListProxy.NAME) as MarketAssetsListProxy;
			if(marketAssetLP == null){
				marketAssetLP = new MarketAssetsListProxy();
				facade.registerProxy(marketAssetLP);
			}
			var gameAssetsLP:GameAssetListProxy = facade.retrieveProxy(GameAssetListProxy.NAME) as GameAssetListProxy;
			for each ( var ma:MarketAsset in assets){
				var ga:GameAsset = gameAssetsLP.getGameAsset(ma.getAsset().getId());
				ma.setAsset(ga);
				marketAssetLP.addAsset(ma);
			}
			var submenu:SubMenuMediator = facade.retrieveMediator(SubMenuMediator.NAME) as SubMenuMediator;
			var subMenuOption:String = submenu.getCurrentSelection();
			if(subMenuOption == MarketHandlers.SUB_MENU_STOCKS){
				sendNotification(ApplicationFacade.SWITCH_SUBMENU_ITEM, subMenuOption);
			}
		}
	}
}
