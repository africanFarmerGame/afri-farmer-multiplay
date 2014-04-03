package uk.ac.sussex.view.components {
	import flash.display.MovieClip;
	import uk.ac.sussex.model.valueObjects.Diet;
	import flash.text.*;

	/**
	 * @author em97
	 */
	public class DietListItem extends ListItem {
		private var assetIcon:AssetIcon;
		private var dietName:TextField;
		private var diet:Diet;
		private var background:MovieClip;
		
		private static const MAX_ASSET_WIDTH:Number = 45;
		private static const MAX_NAME_WIDTH:Number = 65;
		private static const MAX_NAME_HEIGHT:Number = 33;
		private static const BORDER_SIZE:Number = 2.5;
		
		public function DietListItem() {
			super();
			setup();
			setupTextField();
		}
		public function setDiet(newDiet:Diet):void {
			diet = newDiet;
			dietName.text = newDiet.getName();
			this.setItemID(newDiet.getId().toString());
			
		}
		public function getDiet():Diet {
			return diet;
		}
		public function getDragCopy():DietListItem{
			trace("DietListItem sez: I am preparing a dragcopy.");
			var returnIcon:DietListItem = new DietListItem();
			returnIcon.setDiet(this.getDiet());
			returnIcon.hideBackground();
			returnIcon.scaleX = returnIcon.scaleY = 0.16;
			return returnIcon;
		}
		private function hideBackground():void {
			if(dietName.parent!=null){
				dietName.parent.removeChild(this.dietName);
			}
			if(background.parent!=null){
				background.parent.removeChild(this.background);
			}
			assetIcon.scaleX = assetIcon.scaleY = 1;
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
			assetIcon.setType("DIET");
			assetIcon.x = 0.5 * (MAX_NAME_WIDTH - MAX_ASSET_WIDTH) + BORDER_SIZE;
			assetIcon.y = BORDER_SIZE;
			this.addChild(assetIcon);
		}
		private function setupTextField():void{
			var tf:TextFormat = new TextFormat();
			tf.color = 0x000000;
			tf.size = 12;
			tf.font = "Arial";
			tf.bold = false;
			tf.align = TextFormatAlign.CENTER;
			
			dietName = new TextField();
			dietName.defaultTextFormat = tf;
			//stockName.autoSize = TextFieldAutoSize.CENTER;
			dietName.width = MAX_NAME_WIDTH;
			dietName.height = MAX_NAME_HEIGHT;
			dietName.wordWrap = true;
			dietName.selectable = false;
			dietName.border = false;
			dietName.y = MAX_ASSET_WIDTH + BORDER_SIZE;
			dietName.x = BORDER_SIZE;
			this.addChild(dietName);
		}
		private function scaleAsset():void {
			var scaleX:Number = MAX_ASSET_WIDTH / assetIcon.width;
			var scaleY:Number = MAX_ASSET_WIDTH / assetIcon.height;
			
			assetIcon.scaleX = assetIcon.scaleY = (scaleX > scaleY?scaleY:scaleX);	
		}
	}
}
