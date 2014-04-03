/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.serverhandlers.VillageHandlers;
	import uk.ac.sussex.view.SubMenuMediator;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import uk.ac.sussex.model.VillageOverviewProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class VillageDisplayOverviewCommand extends SimpleCommand {
		override public function execute( note:INotification ):void {
			trace("VillageDisplayOverview sez: I got triggered.");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			/**var villageTitle:String = incomingData.getParamValue("VillageName") + " Village";
			var households:String = "Number of households: " + incomingData.getParamValue("NumberHearths");
			var adults:String = "Number of adults: " + incomingData.getParamValue("NumberAdults");
			var children:String = "Number of children: " + incomingData.getParamValue("NumberChildren");
			
			var totalText:String = villageTitle + "\n\n" + households + "\n" + adults + "\n" + children;
			
			sendNotification(ApplicationFacade.DISPLAY_INFO_TEXT, totalText);
			**/
			
			var villageName:String = incomingData.getParamValue("VillageName") as String;
			var households:int = incomingData.getParamValue("NumberHearths") as int;
			var adults:int = incomingData.getParamValue("NumberAdults") as int;
			var children:int = incomingData.getParamValue("NumberChildren") as int;
			
			var villageOverviewProxy:VillageOverviewProxy = facade.retrieveProxy(VillageOverviewProxy.NAME) as VillageOverviewProxy;
			if(villageOverviewProxy==null){
			  villageOverviewProxy = new VillageOverviewProxy();
			  facade.registerProxy(villageOverviewProxy);
			}
			villageOverviewProxy.storeData(villageName, adults, children, households);
			var submenuMediator:SubMenuMediator = facade.retrieveMediator(SubMenuMediator.NAME) as SubMenuMediator;
			if(submenuMediator != null){
				//Just in case really. 
				var currentSelection:String = submenuMediator.getCurrentSelection();
				if(currentSelection == VillageHandlers.SUB_MENU_OVERVIEW){
					sendNotification(ApplicationFacade.SWITCH_SUBMENU_ITEM, VillageHandlers.SUB_MENU_OVERVIEW);
				}
			}
		}
	}
}
