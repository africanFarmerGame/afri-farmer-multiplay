package uk.ac.sussex.view.components {
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class AssetIconBorder extends MovieClip {
		private var assetIcon:AssetIcon;
		public function AssetIconBorder() {
			super();
			this.graphics.lineStyle(3, 0, 1);
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0, 0, 200, 200);
			this.graphics.endFill();
			assetIcon = new AssetIcon();
			this.addChild(assetIcon);
		}
		public function setType(type:String, name:String):void {
			assetIcon.setType(type, name);
		}
	}
}
