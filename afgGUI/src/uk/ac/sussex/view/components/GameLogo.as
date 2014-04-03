package uk.ac.sussex.view.components {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class GameLogo extends MovieClip {
		private var logo:Logo_mc;
		private static const BORDER_GAP:int = 3;
		private static const BORDER_WIDTH:int = 2;
		private static const BORDER_COLOUR:Number = 0x09063A;
		
		public static const GAME_LOGO_PRESSED:String = "GameLogoPressed";
		
		public function GameLogo() {
			logo = new Logo_mc();
			
			var backgroundWidth:Number = 2*BORDER_GAP + logo.width + 2* BORDER_WIDTH;
			var backgroundHeight:Number = 2*BORDER_GAP + logo.height + 2*BORDER_WIDTH;
			var background:MovieClip = new MovieClip();
			background.graphics.moveTo(0, 0);
			background.graphics.lineStyle(BORDER_WIDTH, BORDER_COLOUR);
			background.graphics.lineTo(backgroundWidth, 0);
			background.graphics.lineTo(backgroundWidth, backgroundHeight);
			background.graphics.lineTo(0, backgroundHeight);
			background.graphics.lineTo(0, 0);
			this.addChild(background);
			
			logo.x = BORDER_WIDTH + BORDER_GAP;
			logo.y = BORDER_WIDTH + BORDER_GAP;
			logo.buttonMode = true;
			logo.addEventListener(MouseEvent.CLICK, logoClicked);
			this.addChild(logo);
		}
		private function logoClicked (event:MouseEvent):void {
			trace("GameLogo sez: More info please?");
			dispatchEvent(new Event(GAME_LOGO_PRESSED));
		}
	}
}
