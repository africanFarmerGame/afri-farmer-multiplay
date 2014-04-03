/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.RequestProxy;
	import uk.ac.sussex.serverhandlers.MarketHandlers;
	import uk.ac.sussex.model.valueObjects.Form;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class SubmitSellFormCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var sellForm:Form = note.getBody() as Form;
			if(sellForm==null){
				throw new Error("The form was null");
			}
			if(sellForm.getName()==MarketHandlers.SELL_FORM){
				var quantity:String = sellForm.getFieldValue(MarketHandlers.BUY_SELL_QTY);
				var asset:String = sellForm.getFieldValue(MarketHandlers.BUY_SELL_ASSETID);
				var option:String = sellForm.getFieldValue(MarketHandlers.BUY_SELL_OPTIONS);
				if(asset==null||asset==""){
					sendNotification(ApplicationFacade.DISPLAY_ERROR_MESSAGE, "You have not selected an asset to sell.");
				} else if((quantity==null||quantity=="")&&(option==null||option=="")){
					sendNotification(ApplicationFacade.DISPLAY_ERROR_MESSAGE, "You have not set what you are to sell.");
				} else {
					var request:RequestProxy = facade.retrieveProxy(MarketHandlers.SUBMIT_SELL_REQUEST + RequestProxy.NAME) as RequestProxy;
					request.setParamValue("AssetId", asset);
					request.setParamValue("Quantity", quantity);
					var owner:String = sellForm.getFieldValue(MarketHandlers.BUY_SELL_HOUSEHOLD_PERSONAL);
					if(owner==null){
						owner = "H";
					}
					request.setParamValue("Owner", owner);
					request.setParamValue("Option", option);
					request.sendRequest();
					sellForm.resetForm();
					sendNotification(ApplicationFacade.SWITCH_SUBMENU_ITEM, MarketHandlers.SUB_MENU_STOCKS);
					sendNotification(ApplicationFacade.DISPLAY_MESSAGE, "Your sale request has been submitted.");
				}
			}
		}
	}
}
