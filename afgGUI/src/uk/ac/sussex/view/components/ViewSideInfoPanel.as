package uk.ac.sussex.view.components {
	//import flash.filters.DropShadowFilter;
	import flash.text.*;
	import flash.display.MovieClip;
	

	/**
	 * @author em97
	 */
	public class ViewSideInfoPanel extends MovieClip {
		private var scroller:ScrollingContainer;
		private var sideTxt:TextField = new TextField();
		private var sideFormatN:TextFormat = new TextFormat();
		private var sideFormatH:TextFormat = new TextFormat();
		private var sideFormatNbold:TextFormat = new TextFormat();
		private var sideFormatHbold:TextFormat = new TextFormat();
		//private var sideTxtShadow:DropShadowFilter = new DropShadowFilter(); 
		private var helpInfo:Boolean = false;
		private var cachedTxt:String;
		
		private static const BACKGROUND_COLOUR:uint = 0xFF9407;
		
		public function ViewSideInfoPanel() {
			this.setupSideText();
			//this.setupFilter();
			this.addChild(scroller);
		}
		public function newSideText (newTxt:String) :void {
			if(newTxt==null){
				sideTxt.text = "";
			} else {
				sideTxt.text = newTxt;
				var str:String = sideTxt.getLineText(0);
				sideTxt.setTextFormat(sideFormatNbold,0,str.length);
			}
			helpInfo = false;
			scroller.refreshContainer();
		}
		public function appendSideText (newTxt:String) : void {
			var str:String = sideTxt.text;
			sideTxt.text = str + newTxt;
			str = sideTxt.getLineText(0);
			sideTxt.setTextFormat(sideFormatNbold,0,str.length);
			helpInfo = false;
		}
		public function cacheText():void {
			if(cachedTxt == null){
				cachedTxt = sideTxt.text;
			}
		}
		public function revertText():void {
			if(cachedTxt!=null){
				sideTxt.text = cachedTxt;
				cachedTxt = null;
			}
		}
		// if help text is displayed, save current side text for re-display.
		public function newHelpText (newTxt:String) : void{
			
			if (helpInfo) { // help text currently displayed
				// reload cached data
				sideTxt.defaultTextFormat = sideFormatN;
				this.newSideText(cachedTxt);
				helpInfo = false;
			} else {	// other data currently displayed
				// save current data
				cachedTxt = sideTxt.text;
				sideTxt.text = newTxt;
				sideTxt.defaultTextFormat = sideFormatH;
				var str:String = sideTxt.getLineText(0);
				sideTxt.setTextFormat(sideFormatHbold,0,str.length);
				helpInfo = true;
				
				scroller.refreshContainer();
			}
		}
		public function clearPanel():void {
			//Clear the current cache and wipe the screen. 
			cachedTxt = null;
			sideTxt.text = "";
		}
		private function setupSideText():void {
			sideFormatN.font = "Calibri";
			sideFormatN.size = 15;
			sideFormatN.leftMargin = 6;
			sideFormatN.rightMargin = 6;
			sideFormatH.font = "Calibri";
			sideFormatH.size = 14;
			sideFormatHbold.leftMargin = 6;
			sideFormatHbold.size = 17;
			sideFormatHbold.bold = true;
			sideFormatNbold.bold = true;
			sideTxt.defaultTextFormat = sideFormatN;	
			sideTxt.background = true;
			sideTxt.backgroundColor = BACKGROUND_COLOUR;
			//sideTxt.border = true;
			//sideTxt.borderColor = 0x000000;
			sideTxt.wordWrap = true;
			sideTxt.width = 210;
			sideTxt.autoSize = "left";
			sideTxt.selectable = false;
			sideTxt.filters = [];
			sideTxt.text = "";
			scroller = new ScrollingContainer(sideTxt.width + 10, 321, ScrollingContainer.VERTICAL, false);
			scroller.addItemToContainer(sideTxt);
			scroller.showBackgroundFilter(false);
			scroller.setBorderColour(0xFF9407);
			scroller.setBackgroundColour(BACKGROUND_COLOUR);
			//scroller.filters = [sideTxtShadow];
		}
		/*private function setupFilter():void {
			sideTxtShadow.distance = 0;
			sideTxtShadow.angle = 225;
			sideTxtShadow.color = 0x333333;
			sideTxtShadow.alpha = 1;
			sideTxtShadow.blurX = 8;
			sideTxtShadow.blurY = 2;
			sideTxtShadow.strength = 1;
			sideTxtShadow.quality = 15;
			sideTxtShadow.inner = false;
			sideTxtShadow.knockout = false;
			sideTxtShadow.hideObject = false;
		}*/		
	}
}
