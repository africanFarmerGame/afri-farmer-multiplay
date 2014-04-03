/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import uk.ac.sussex.view.components.ListItem;

	/**
	 * @author em97
	 */
	public class BankGMOverviewListItem extends ListItem {
		private var household:GameTextField;
		private var cashValue:GameTextField;
		private var assetValue:GameTextField;
		private var totalValue:GameTextField;
		private var unpaidBills:GameTextField;
		
		private static const GAP_SIZE:Number = 2;
		private static const ITEM_Y_POS:uint = 0;
		private static const ITEM_HEIGHT:uint = 25;
		
		private static const HOUSEHOLD_WIDTH:Number = 150;
		private static const NUMERIC_WIDTH:Number = 100;
		
		public function BankGMOverviewListItem() {
			super();
			setup();
			this.mouseChildren = false;
		}
		public function setDetails(hearthId:int, hearthName:String, cash:Number, assets:Number, unpaid:int) :void {
			this.setItemID(hearthId.toString());
			household.text = hearthName;
			cashValue.text = cash.toString();
			assetValue.text = assets.toString();
			var total:Number = cash + assets;
			totalValue.text = total.toString();
			unpaidBills.text = unpaid.toString();
		}
		private function setup():void{
			household = new GameTextField;
			household.readonly = true;
			household.width = HOUSEHOLD_WIDTH;
			household.height = ITEM_HEIGHT;
			household.x = 10;
			household.y = ITEM_Y_POS;
			this.addChild(household);
			
			cashValue = new GameTextField();
			cashValue.readonly = true;
			cashValue.width = NUMERIC_WIDTH;
			cashValue.height = ITEM_HEIGHT;
			cashValue.y = ITEM_Y_POS;
			cashValue.x = household.x + household.width + GAP_SIZE;
			this.addChild(cashValue);
			
			assetValue = new GameTextField();
			assetValue.readonly = true;
			assetValue.width = NUMERIC_WIDTH;
			assetValue.height = ITEM_HEIGHT;
			assetValue.y = ITEM_Y_POS;
			assetValue.x = cashValue.x + cashValue.width + GAP_SIZE;
			this.addChild(assetValue);
			
			totalValue = new GameTextField();
			totalValue.readonly = true;
			totalValue.width = NUMERIC_WIDTH;
			totalValue.height = ITEM_HEIGHT;
			totalValue.y = ITEM_Y_POS;
			totalValue.x = assetValue.x + assetValue.width + GAP_SIZE;
			this.addChild(totalValue);
			
			unpaidBills = new GameTextField();
			unpaidBills.readonly = true;
			unpaidBills.width = NUMERIC_WIDTH;
			unpaidBills.height = ITEM_HEIGHT;
			unpaidBills.y = ITEM_Y_POS;
			unpaidBills.x = totalValue.x + totalValue.width + GAP_SIZE;
			this.addChild(unpaidBills);
		}
		public static function getColumnHeaders():Array {
			var headers:Array = new Array();
			
			headers.push(new Array("Household", HOUSEHOLD_WIDTH, 0));
			headers.push(new Array("Cash", NUMERIC_WIDTH, HOUSEHOLD_WIDTH + GAP_SIZE));
			headers.push(new Array("Assets", NUMERIC_WIDTH, HOUSEHOLD_WIDTH + 2*GAP_SIZE + NUMERIC_WIDTH));
			headers.push(new Array("Total", NUMERIC_WIDTH, HOUSEHOLD_WIDTH + 3*GAP_SIZE + 2*NUMERIC_WIDTH));
			headers.push(new Array("Unpaid Bills", NUMERIC_WIDTH, HOUSEHOLD_WIDTH + 4*GAP_SIZE + 3*NUMERIC_WIDTH));
			
			return headers;
		}
	}
}
