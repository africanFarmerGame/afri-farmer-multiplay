package uk.ac.sussex.view.components {
	
	/**
	 * @author em97
	 */
	public class ScrollingTwoColList extends ScrollingList {
		public function ScrollingTwoColList(totalWidth : Number, maskHeight : Number) {
			super(totalWidth, maskHeight);
		}
		public function setInitialYPos(newInitialYPos:Number):void {
			this.initialYPos = newInitialYPos;
			if(this.allListItems.length == 0){
				this.nextYPos = initialYPos;
			}
		}
		override public function addItem(newItem:ListItem):void {
			//I need to calculate the offset to centre the items. I think I'm going to assume matching width items.
			if (this.allListItems.length == 0){
				this.initialXPos = 0.5*this.maskWidth - newItem.width;
				this.nextXPos = this.initialXPos;
			}
			super.addItem(newItem);
		}
		override protected function calculateNextItemPos(newItem:ListItem, itemPos:int):void {
			var x_offset:Number = 0.5*this.maskWidth - newItem.width;
			var remainder:int = (itemPos+ 1) % 2;
			
			nextYPos = nextYPos + (remainder) * newItem.height;
			nextXPos = x_offset - (remainder - 1) * newItem.width; 			
		}
	}
}
