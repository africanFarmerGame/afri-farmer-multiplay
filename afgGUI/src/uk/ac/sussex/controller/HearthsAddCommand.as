/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.AnyChar;
	import uk.ac.sussex.general.ApplicationFacade;
	import uk.ac.sussex.model.PlayerCharProxy;
	import uk.ac.sussex.view.HearthMediator;
	import uk.ac.sussex.model.valueObjects.Hearth;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class HearthsAddCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			trace("HearthsAddCommand sez: We're adding a hearth mediator.");
			var hearth:Hearth = note.getBody() as Hearth;
			var myPCProxy:PlayerCharProxy = facade.retrieveProxy(ApplicationFacade.MY_CHAR) as PlayerCharProxy;
			var banker:Boolean = myPCProxy.isBanker();
			var hearthMediator:HearthMediator = facade.retrieveMediator(HearthMediator.NAME + hearth.getId()) as HearthMediator;
			if(hearthMediator == null){
				//All is well, we can continue. 
				hearthMediator = new HearthMediator(hearth.getId());
				facade.registerMediator(hearthMediator);
				
				if(banker){
					hearthMediator.showDoor();
				}
				hearthMediator.displayHearthName(hearth.getHearthName());
				sizePosHouseIcon(hearthMediator, hearth.getHouseNumber()); 
				
				
				if(hearth.getId() == myPCProxy.getPCHearthId()){
					hearthMediator.displayOccupantsRelationship(AnyChar.ME);
				}
			}
		}
				// Scale & position house and door objects
		private function sizePosHouseIcon(hearthMediator:HearthMediator, houseNumber:int):void {
			//EAM this now works by placing the house within a big grid of 5x3, then within that box picking a
			//smaller grid of 3x2. That is calculated off the housenumber, scatters quite nicely.
			// this array give x & y co-ods of houses

			/**var houseXY:Array = [[180,20], [120,100], [160,190],
				[360,35], [310,120], [280,215], [490,20],
				[520,122], [430,190], [80, 180], [550, 215], [120, 215]];
			
			hearthMediator.setPosition(houseXY[houseNumber][0], houseXY[houseNumber][1]);
			**/
			var maxWidth:Number = 500;
			var maxHeight:Number = 240; 
			var minX:Number = 110;
			var minY:Number = 20;
			
			//I think the max rows is 3. Start from that position. Assuming 5 columns. Only deals with 15, not 17, but 
			//ok for now. 
			var maxRows:int = 3; 
			var numColumns:int = 5;
			var rowHeight:Number = maxHeight/maxRows;
			var miniHeight:Number = rowHeight/3;
			var columnWidth:Number = maxWidth/numColumns;
			var miniWidth:Number = columnWidth/3;
			var miniBoxPos:int = houseNumber%6;
			
			var houseX:Number = minX + (houseNumber%numColumns) * columnWidth + (miniBoxPos%3)*miniWidth;
			var houseY:Number = minY + (houseNumber%maxRows) * rowHeight + (miniBoxPos%2) * miniHeight;
			hearthMediator.setPosition(houseX, houseY);
		}
	}
}
