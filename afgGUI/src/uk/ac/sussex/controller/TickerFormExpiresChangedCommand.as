/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.Form;
	import uk.ac.sussex.model.FormProxy;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.model.valueObjects.FormField;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class TickerFormExpiresChangedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var expiresField:FormField = note.getBody() as FormField;
			if(expiresField==null){
				throw new Error("TickerFormExpiresChangedCommand ERROR: The note body was null");
			}
			var tickerFormProxy:FormProxy = facade.retrieveProxy(HomeHandlers.SEND_TICKER_FORM) as FormProxy;
			var tickerForm:Form = tickerFormProxy.getForm();
			var enabled:Boolean = (expiresField.getFieldValue()!="0");
			tickerForm.setFieldEnabled(HomeHandlers.TICKER_DURATION, enabled);
			tickerForm.setFieldEnabled(HomeHandlers.TICKER_DURATION_UNIT, enabled);
		}
	}
}
