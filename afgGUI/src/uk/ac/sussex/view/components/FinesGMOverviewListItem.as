/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import uk.ac.sussex.model.valueObjects.Hearth;
	import uk.ac.sussex.view.components.ListItem;

	/**
	 * @author em97
	 */
	public class FinesGMOverviewListItem extends ListItem {
		private var household:GameTextField;
		private var paidFines:GameTextField;
		private var unpaidFines:GameTextField;
		private var totalFines:GameTextField;
		
		private static const GAP_SIZE:Number = 2;
		private static const ITEM_Y_POS:uint = 0;
		private static const ITEM_HEIGHT:uint = 25;
		
		private static const HOUSEHOLD_WIDTH:Number = 150;
		private static const NUMERIC_WIDTH:Number = 100;
		
		public function FinesGMOverviewListItem() {
			super();
			setup();
			this.mouseChildren = false;
		}
		public function setDetails(hearth:Hearth, paid:int, unpaid:int, total:int) :void {
			this.setItemID(hearth.getId().toString());
			household.text = hearth.getHearthName();
			paidFines.text = paid.toString();
			unpaidFines.text = unpaid.toString();
			totalFines.text = total.toString();
		}
		private function setup():void{
			household = new GameTextField;
			household.readonly = true;
			household.width = HOUSEHOLD_WIDTH;
			household.height = ITEM_HEIGHT;
			household.x = 10;
			household.y = ITEM_Y_POS;
			this.addChild(household);
			
			paidFines = new GameTextField();
			paidFines.readonly = true;
			paidFines.width = NUMERIC_WIDTH;
			paidFines.height = ITEM_HEIGHT;
			paidFines.y = ITEM_Y_POS;
			paidFines.x = household.x + household.width + GAP_SIZE;
			this.addChild(paidFines);
			
			unpaidFines = new GameTextField();
			unpaidFines.readonly = true;
			unpaidFines.width = NUMERIC_WIDTH;
			unpaidFines.height = ITEM_HEIGHT;
			unpaidFines.y = ITEM_Y_POS;
			unpaidFines.x = paidFines.x + paidFines.width + GAP_SIZE;
			this.addChild(unpaidFines);
			
			totalFines = new GameTextField();
			totalFines.readonly = true;
			totalFines.width = NUMERIC_WIDTH;
			totalFines.height = ITEM_HEIGHT;
			totalFines.y = ITEM_Y_POS;
			totalFines.x = unpaidFines.x + unpaidFines.width + GAP_SIZE;
			this.addChild(totalFines);
		}
		public static function getColumnHeaders():Array {
			var headers:Array = new Array();
			
			headers.push(new Array("Household", HOUSEHOLD_WIDTH, 0));
			headers.push(new Array("Paid", NUMERIC_WIDTH, HOUSEHOLD_WIDTH + GAP_SIZE));
			headers.push(new Array("Unpaid", NUMERIC_WIDTH, HOUSEHOLD_WIDTH + 2*GAP_SIZE + NUMERIC_WIDTH));
			headers.push(new Array("Total", NUMERIC_WIDTH, HOUSEHOLD_WIDTH + 3*GAP_SIZE + 2*NUMERIC_WIDTH));
			
			return headers;
		}
	}
}
