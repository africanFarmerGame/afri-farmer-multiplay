/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import uk.ac.sussex.states.*;
	import uk.ac.sussex.model.valueObjects.ViewStatus;
	import flash.display.Sprite;
	import uk.ac.sussex.view.components.ListItem;

	/**
	 * @author em97
	 */
	public class GameStatusListItem extends ListItem {
		private var householdName:GameTextField;
		private var householdIndicator:Sprite;
		private var farmIndicator:Sprite;
		private var villageIndicator:Sprite;
		private var marketIndicator:Sprite;
		private var bankIndicator:Sprite;
		
		private var viewStatuses:Array;
		
		private static const HOUSEHOLD_WIDTH:Number = 150;
		private static const GAP_SIZE:Number = 2;
		private static const ITEM_Y_POS:uint = 0;
		private static const ITEM_HEIGHT:uint = 25;
		private static const INDICATOR_WIDTH:uint = 75;
		
		private static const GREEN:uint = 0x00695C;
		private static const AMBER:uint = 0xFF940A;
		private static const RED:uint = 0xF74D05;
		
		public function GameStatusListItem() {
			super();
			setup();
			this.mouseChildren = false;
		}
		public function setHouseholdName(newName:String ):void {
			householdName.text = newName;
		}
		public function setViewStatuses(newStatuses:Array):void {
			this.viewStatuses = newStatuses;
			for each (var status:ViewStatus in viewStatuses){
				switch (status.getViewName()){
					case HomeGameState.LOCATION_NAME:
						drawIndicator(householdIndicator, status.getStatus());
						break;
					case VillageGameState.LOCATION_NAME:
						drawIndicator(villageIndicator, status.getStatus());
						break;
					case FarmGameState.LOCATION_NAME:
						drawIndicator(farmIndicator, status.getStatus());
						break;
					case MarketGameState.LOCATION_NAME:
						drawIndicator(marketIndicator, status.getStatus());
						break;
					case BankGameState.LOCATION_NAME:
						drawIndicator(bankIndicator, status.getStatus());
						break;
					default:
						trace("GameStatusListItem sez: I am displaying " + status.getViewName());
						trace("GameStatusListItem sez: I can't find that.");
				}
			}
		}
		private function setup():void{
			householdName = new GameTextField;
			householdName.readonly = true;
			householdName.width = HOUSEHOLD_WIDTH;
			householdName.height = ITEM_HEIGHT;
			householdName.x = 10;
			householdName.y = ITEM_Y_POS;
			this.addChild(householdName);
			
			householdIndicator = new Sprite();
			drawIndicator(householdIndicator, 0);
			householdIndicator.x = householdName.x + householdName.width + GAP_SIZE;
			householdIndicator.y = ITEM_Y_POS;
			this.addChild(householdIndicator);
			
			farmIndicator = new Sprite();
			drawIndicator(farmIndicator, 0);
			farmIndicator.x = householdIndicator.x + householdIndicator.width + GAP_SIZE;
			farmIndicator.y = ITEM_Y_POS;
			this.addChild(farmIndicator);
			
			villageIndicator = new Sprite();
			drawIndicator(villageIndicator, 0);
			villageIndicator.x = farmIndicator.x + farmIndicator.width + GAP_SIZE;
			villageIndicator.y = ITEM_Y_POS;
			this.addChild(villageIndicator);
			
			marketIndicator = new Sprite();
			drawIndicator(marketIndicator, 0);
			marketIndicator.x = villageIndicator.x + villageIndicator.width + GAP_SIZE;
			marketIndicator.y = ITEM_Y_POS;
			this.addChild(marketIndicator);
			
			bankIndicator = new Sprite();
			drawIndicator(bankIndicator, 0);
			bankIndicator.x = marketIndicator.x + marketIndicator.width + GAP_SIZE;
			bankIndicator.y = ITEM_Y_POS;
			this.addChild(bankIndicator);
		}
		private function drawIndicator(indicator:Sprite, status:int):void {
			indicator.graphics.clear();
			switch (status){
				case 0:
					indicator.graphics.beginFill(GREEN);
					break;
				case 1:
					indicator.graphics.beginFill(AMBER);
					break;
				case 2: 
					indicator.graphics.beginFill(RED);
					break;
				default:
					indicator.graphics.beginFill(GREEN);
			}
			indicator.graphics.drawRect(0, 0, INDICATOR_WIDTH, ITEM_HEIGHT);
			indicator.graphics.endFill();
		}
		public static function getColumnHeaders():Array {
			var headers:Array = new Array();
			
			headers.push(new Array("Household", HOUSEHOLD_WIDTH, 0));
			headers.push(new Array("Home", INDICATOR_WIDTH, HOUSEHOLD_WIDTH + GAP_SIZE));
			headers.push(new Array("Farm", INDICATOR_WIDTH, HOUSEHOLD_WIDTH + 2*GAP_SIZE + INDICATOR_WIDTH));
			headers.push(new Array("Village", INDICATOR_WIDTH, HOUSEHOLD_WIDTH + 3*GAP_SIZE + 2* INDICATOR_WIDTH));
			headers.push(new Array("Market", INDICATOR_WIDTH, HOUSEHOLD_WIDTH + 4*GAP_SIZE + 3*INDICATOR_WIDTH));
			headers.push(new Array("Bank", INDICATOR_WIDTH, HOUSEHOLD_WIDTH + 5*GAP_SIZE + 4*INDICATOR_WIDTH));
			
			return headers;
		}
	}
}
