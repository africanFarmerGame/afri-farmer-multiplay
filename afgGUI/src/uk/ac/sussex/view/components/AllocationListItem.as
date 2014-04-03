package uk.ac.sussex.view.components {
	import flash.filters.DropShadowFilter;
	import flash.display.MovieClip;
	import uk.ac.sussex.model.valueObjects.Allocation;
	import flash.text.*;
	import uk.ac.sussex.view.components.ListItem;

	/**
	 * @author em97
	 */
	public class AllocationListItem extends ListItem {
		private var assetIcon:AssetIcon;
		private var allocationName:TextField;
		private var allocation:Allocation;
		private var background:MovieClip;
		private var selectedFilter:DropShadowFilter;
		
		private static const MAX_ASSET_WIDTH:Number = 45;
		private static const MAX_NAME_WIDTH:Number = 65;
		private static const MAX_NAME_HEIGHT:Number = 33;
		private static const BORDER_SIZE:Number = 2.5;
		
		public function AllocationListItem() {
			super();
			setup();
			setupTextField();
			setupFilter();
		}
		public function setAllocation(newAllocation:Allocation):void {
			allocation = newAllocation;
			allocationName.text = newAllocation.getName();
			this.setItemID(newAllocation.getId().toString());
			this.setAllocationSelected();
		}
		public function getAllocation():Allocation {
			return allocation;
		}
		public function setAllocationSelected():void{
			if(allocation.getSelected()){
				assetIcon.filters = [selectedFilter];
			} else {
				assetIcon.filters = [];
			}
		}
		private function setup():void {
			background = new MovieClip;
			background.graphics.lineStyle(3, 0x999999); 
			background.graphics.beginFill(0xFFFFFF);
			background.graphics.drawRect(0, 0, MAX_NAME_WIDTH + 2* BORDER_SIZE, 2*BORDER_SIZE + MAX_ASSET_WIDTH + MAX_NAME_HEIGHT);
			background.graphics.endFill();
			this.addChild(background);
			
			this.assetIcon = new AssetIcon();
			scaleAsset();
			assetIcon.setType("ALLOCATION");
			assetIcon.x = 0.5 * (MAX_NAME_WIDTH - MAX_ASSET_WIDTH) + BORDER_SIZE;
			assetIcon.y = BORDER_SIZE;
			this.addChild(assetIcon);
		}
		private function setupFilter():void {
			selectedFilter = new DropShadowFilter();
			selectedFilter.distance = 0;
			selectedFilter.angle = 0;
			selectedFilter.color = 0xFF0000;
			selectedFilter.alpha = 0.9;
			selectedFilter.blurX = 9;
			selectedFilter.blurY = 6;
			selectedFilter.strength = 1;
			selectedFilter.quality = 15;
			selectedFilter.inner = false;
			selectedFilter.knockout = false;
			selectedFilter.hideObject = false;
		}
		private function setupTextField():void{
			var tf:TextFormat = new TextFormat();
			tf.color = 0x000000;
			tf.size = 12;
			tf.font = "Arial";
			tf.bold = false;
			tf.align = TextFormatAlign.CENTER;
			
			allocationName = new TextField();
			allocationName.defaultTextFormat = tf;
			//stockName.autoSize = TextFieldAutoSize.CENTER;
			allocationName.width = MAX_NAME_WIDTH;
			allocationName.height = MAX_NAME_HEIGHT;
			allocationName.wordWrap = true;
			allocationName.selectable = false;
			allocationName.border = false;
			allocationName.y = MAX_ASSET_WIDTH + BORDER_SIZE;
			allocationName.x = BORDER_SIZE;
			this.addChild(allocationName);
		}
		private function scaleAsset():void {
			var scaleX:Number = MAX_ASSET_WIDTH / assetIcon.width;
			var scaleY:Number = MAX_ASSET_WIDTH / assetIcon.height;
			
			assetIcon.scaleX = assetIcon.scaleY = (scaleX > scaleY?scaleY:scaleX);	
		}
	}
}
