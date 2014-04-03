package uk.ac.sussex.view.components {
	import flash.events.Event;
	import flash.events.MouseEvent;
	//import flash.filters.DropShadowFilter;
	import flash.display.MovieClip;
	import uk.ac.sussex.model.valueObjects.GameAsset;
	import flash.text.*;

	/**
	 * @author em97
	 */
	public class InStockAssetListItem extends ListItem {
		private var assetIcon:AssetIcon;
		private var stockName:TextField;
		private var asset:GameAsset;
		private var background:MovieClip;
		//private var errorFilter:DropShadowFilter;
		private var mouseover:MouseoverTextField;
		
		//private static const STOCK_NAME_YPOS:Number = 52;
		private static const MAX_ASSET_WIDTH:Number = 53;
		private static const MAX_NAME_WIDTH:Number = 73;
		private static const MAX_NAME_HEIGHT:Number = 33;
		private static const BORDER_SIZE:Number = 2;
		
		private static const TILE_LINE_COLOUR:uint = 0x000000;
		private static const TILE_BACKGROUND_COLOUR:uint = 0xF4EFA4;
		//private static const HIGHLIGHT_BACKGROUND_COLOUR:uint = 0x006A5D;
		//private static const HIGHLIGHT_LINE_COLOUR:uint = 0x006A5D;
		
		public static const ASSET_MOUSE_DOWN:String = "InStockAssetListItemMouseDown";
		
		public function InStockAssetListItem() {
			super();
			background = new MovieClip;
			background.graphics.lineStyle(2, TILE_LINE_COLOUR); 
			background.graphics.beginFill(TILE_BACKGROUND_COLOUR);
			background.graphics.drawRect(0, 0, MAX_NAME_WIDTH + 2* BORDER_SIZE, 2*BORDER_SIZE + MAX_ASSET_WIDTH + MAX_NAME_HEIGHT);
			background.graphics.endFill();
			this.addChild(background);
			//this.setupFilter();
			mouseover = new MouseoverTextField();
			this.addEventListener(MouseEvent.MOUSE_OVER, displayMouseover);
			this.addEventListener(MouseEvent.MOUSE_OUT, removeMouseover);
		}
		public function setAsset(asset:GameAsset):void {
			trace("InStockAssetListItem sez: I'm setting my Asset to " + asset.getName());
			this.asset = asset;
			assetIcon = new AssetIcon();
			assetIcon.setType(asset.getType(), asset.getSubtype());
			scaleAsset();
			assetIcon.x = 0.5 * (MAX_NAME_WIDTH - MAX_ASSET_WIDTH) + BORDER_SIZE;
			assetIcon.y = BORDER_SIZE;
			this.addChild(assetIcon);
			this.setupTextField();
			stockName.text = asset.getName();
			
			this.setItemID(asset.getId().toString());
		}
		public function itemError(error:Boolean):void {
			if(error){
				//assetIcon.filters = [errorFilter];
			} else {
				assetIcon.filters = [];
			}
		}
		public function setMouseoverText(newText:String):void {
			mouseover.text = newText;
		}
		public function getAsset():GameAsset{
			return this.asset;
		}
		public function getDragCopy():InStockAssetListItem{
			var returnIcon:InStockAssetListItem = new InStockAssetListItem();
			returnIcon.setAsset(this.getAsset());
			returnIcon.hideBackground();
			returnIcon.allowDrag(true);
			returnIcon.scaleX = returnIcon.scaleY = 0.16;
			return returnIcon;
		}
		public function allowDrag(allow:Boolean):void {
			if(allow){
				this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			} else {
				this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			}
		}
		override public function destroy():void {
			if(mouseover!=null){
				mouseover.removeFromScreen();
			}
		}
		protected function hideBackground():void {
			if(stockName.parent!=null){
				stockName.parent.removeChild(this.stockName);
			}
			if(background.parent!=null){
				background.parent.removeChild(this.background);
			}
			assetIcon.scaleX = assetIcon.scaleY = 1;
		}
		private function setupTextField():void{
			var tf:TextFormat = new TextFormat();
			tf.color = 0x000000;
			tf.size = 12;
			tf.font = "Arial";
			tf.bold = false;
			tf.align = TextFormatAlign.CENTER;
			
			stockName = new TextField();
			stockName.defaultTextFormat = tf;
			//stockName.autoSize = TextFieldAutoSize.CENTER;
			stockName.width = MAX_NAME_WIDTH;
			stockName.height = MAX_NAME_HEIGHT;
			stockName.wordWrap = true;
			stockName.selectable = false;
			stockName.border = false;
			stockName.y = MAX_ASSET_WIDTH + BORDER_SIZE;
			stockName.x = BORDER_SIZE;
			this.addChild(stockName);
		}
		private function scaleAsset():void {
			var scaleX:Number = InStockAssetListItem.MAX_ASSET_WIDTH / assetIcon.width;
			var scaleY:Number = MAX_ASSET_WIDTH / assetIcon.height;
			
			assetIcon.scaleX = assetIcon.scaleY = (scaleX > scaleY?scaleY:scaleX);	
		}
		private function displayMouseover(e:MouseEvent):void {
			if(mouseover.text != null && mouseover.text != ""){
				mouseover.addToScreen(this, mouseX + 5, mouseY - mouseover.height);
			}
		}
		private function removeMouseover(e:MouseEvent):void {
			mouseover.removeFromScreen();
		}
		private function mouseDown(e:MouseEvent):void {
			dispatchEvent(new Event(InStockAssetListItem.ASSET_MOUSE_DOWN, true));
		}
	}
}
