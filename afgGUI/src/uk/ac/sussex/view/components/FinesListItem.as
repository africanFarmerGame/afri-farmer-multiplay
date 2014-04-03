/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import uk.ac.sussex.model.valueObjects.Fine;
	import uk.ac.sussex.view.components.ListItem;

	/**
	 * @author em97
	 */
	public class FinesListItem extends ListItem {
		private var fine:Fine;
		private var fineDescription:GameTextField;
		private var fineEarlyRate:GameTextField;
		private var fineLateRate:GameTextField;
		private var fineStatus:GameTextField;
		
		private static const GAP_SIZE:Number = 2;
		private static const ITEM_Y_POS:uint = 0;
		private static const ITEM_HEIGHT:uint = 25;
		
		public function FinesListItem() {
			super();
			setup();
			this.mouseChildren = false;
		}
		public function setFine(newFine:Fine):void {
			fine = newFine;
			this.setItemID(newFine.getId().toString());
			fineDescription.text = newFine.getDescription();
			fineEarlyRate.text = newFine.getEarlyRate().toString();
			fineLateRate.text = newFine.getLateRate().toString();
			if(newFine.getPaid()){
				fineStatus.text = "PAID";
				this.enabled = false;
				this.alpha = 0.5;
			} else {
				fineStatus.text = "UNPAID";
				this.enabled = true;
				this.alpha = 1;
			}
		}
		private function setup():void{
			fineDescription = new GameTextField;
			fineDescription.readonly = true;
			fineDescription.width = 300;
			fineDescription.height = ITEM_HEIGHT;
			fineDescription.x = 10;
			fineDescription.y = ITEM_Y_POS;
			this.addChild(fineDescription);
			
			fineEarlyRate = new GameTextField();
			fineEarlyRate.readonly = true;
			fineEarlyRate.width = 50;
			fineEarlyRate.height = ITEM_HEIGHT;
			fineEarlyRate.y = ITEM_Y_POS;
			fineEarlyRate.x = fineDescription.x + fineDescription.width + GAP_SIZE;
			this.addChild(fineEarlyRate);
			
			fineLateRate = new GameTextField();
			fineLateRate.readonly = true;
			fineLateRate.width = 50;
			fineLateRate.height = ITEM_HEIGHT;
			fineLateRate.y = ITEM_Y_POS;
			fineLateRate.x = fineEarlyRate.x + fineEarlyRate.width + GAP_SIZE;
			this.addChild(fineLateRate);
			
			fineStatus = new GameTextField();
			fineStatus.readonly = true;
			fineStatus.width = 100;
			fineStatus.height = ITEM_HEIGHT;
			fineStatus.y = ITEM_Y_POS;
			fineStatus.x = fineLateRate.x + fineLateRate.width + GAP_SIZE;
			this.addChild(fineStatus);
		}
	}
}
