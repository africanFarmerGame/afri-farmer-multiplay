/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.FormProxy;
	import uk.ac.sussex.serverhandlers.MarketHandlers;
	import uk.ac.sussex.model.valueObjects.FormField;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * Frankly this is a little dirty. But expedient.
	 * 
	 * @author em97
	 */
	public class MarketHandleFormChangeCommand extends SimpleCommand {
			override public function execute(note:INotification):void {
			//Get the field that caused the event. 
			var field:FormField = note.getBody() as FormField;
			//Need to get hold of the form. 
			var formProxy:FormProxy = facade.retrieveProxy(field.getParent().getName()) as FormProxy;
			if(formProxy == null){ //This really shouldn't be possible if the field is not null. 
				throw new Error("The form proxy was null");
			}
			if(field==null){
				throw new Error("The form field was null.");
			}
			switch(field.getFieldName()){
				case MarketHandlers.BUY_SELL_QTY:
					var price:Number = Number(formProxy.retrieveFieldValue(MarketHandlers.BUY_SELL_PRICE));
					var quantity:Number = Number(field.getFieldValue());
					var total:Number = price * quantity;
					formProxy.updateFieldValue(MarketHandlers.BUY_SELL_TOTAL, total.toString());
					break;
				case MarketHandlers.BUY_SELL_OPTIONS:
					var option:String = formProxy.retrieveFieldValue(MarketHandlers.BUY_SELL_OPTIONS);
					if(option==null||option==""){
						formProxy.updateFieldValue(MarketHandlers.BUY_SELL_TOTAL, null);
					} else {
						var optionPrice:String = formProxy.retrieveFieldValue(MarketHandlers.BUY_SELL_PRICE);
						formProxy.updateFieldValue(MarketHandlers.BUY_SELL_TOTAL, optionPrice);
					}
					break;
					break;
				case MarketHandlers.BUY_SELL_HOUSEHOLD_PERSONAL:
					//Going to depend which form it's from.
					if(field.getParent().getName() == MarketHandlers.SELL_FORM){
						trace("MarketHandleFormChangeCommand sez: I need to change the display");
					}
					break;
			}
		}
	}
}
