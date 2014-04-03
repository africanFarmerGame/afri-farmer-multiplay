/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.AnyChar;
	import uk.ac.sussex.view.HearthMemberListMediator;
	import uk.ac.sussex.model.HearthMembersListProxy;
	import uk.ac.sussex.serverhandlers.HomeHandlers;
	import uk.ac.sussex.model.valueObjects.IncomingData;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class HearthMemberChangedHearthCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("HearthMemberChangedHearthCommand sez: fired");
			var incomingData:IncomingData = note.getBody() as IncomingData;
			var charId:int = incomingData.getParamValue(HomeHandlers.HMHC_CHAR) as int;
			var hearthId:int = incomingData.getParamValue(HomeHandlers.HMHC_HEARTH) as int;
			trace("HearthMemberChangedHearthCommand sez: I'm changing char " + charId + " to hearth " + hearthId);
			
			var hmlp:HearthMembersListProxy = facade.retrieveProxy(HearthMemberListMediator.NAME) as HearthMembersListProxy;
			var updatedMember:AnyChar = hmlp.getMember(charId);
			
			updatedMember.setHearthId(hearthId);
			//Now I need to update that in the list. 
			hmlp.updateMember(updatedMember);
			trace("HearthMemberChangedHearthCommand sez: I believe I am done now. ");
			
		}
	}
}
