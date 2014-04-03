/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.TalkMessage;
	import uk.ac.sussex.model.CallInProgressProxy;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class PhoneAnsweredCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var answered:Number = incomingData.getParamValue("Answered") as Number;
			
			var callInProgressProxy:CallInProgressProxy = facade.retrieveProxy(CallInProgressProxy.NAME) as CallInProgressProxy;
			if(callInProgressProxy!=null){
				callInProgressProxy.answerCall(answered);
				
				var callAnsweredMessage:TalkMessage = new TalkMessage();
				callAnsweredMessage.setAuthorId(-1);
				callAnsweredMessage.setAuthorName("System");
				callAnsweredMessage.setMessage("The call has been answered.");
				callInProgressProxy.addCallMessage(callAnsweredMessage);
			} else {
				//It really shouldn't be at this point...
				throw new Error("The callInProgressproxy was null!");
			}
			
			
		}
	}
}
