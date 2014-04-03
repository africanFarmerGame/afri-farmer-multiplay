package uk.ac.sussex.view.components {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class PhoneBtn extends MovieClip {
		private var phoneBtn:PhoneBtnMC = new PhoneBtnMC();
		private var flashing:Boolean = false;
		private var timer:Timer;
		
		private static const UP:String = "UP";
		private static const OVER:String = "OVER";
		private static const DOWN:String = "DOWN";
		private static const TIMER_DURATION:uint = 300;
		
		public function PhoneBtn() {
			timer = new Timer(TIMER_DURATION);
			timer.addEventListener(TimerEvent.TIMER, timerEvent);
			
			phoneBtn.gotoAndStop(UP);
			this.addChild(phoneBtn);
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
		}
		public function setFlashing(flashing:Boolean):void {
			this.flashing = flashing;
			if(flashing){
				flash();
			} else {
				stopFlashing();
			}
		}
		private function flash():void {
			timer.start();
		}
		private function stopFlashing():void {
			timer.stop();
			phoneBtn.gotoAndStop(UP);
		}
		private function mouseOver(e:MouseEvent):void{
			if(flashing){
				stopFlashing();
			}
			phoneBtn.gotoAndStop(OVER);
		}
		private function mouseOut(e:MouseEvent):void {
			if(flashing){
				flash();
			} else {
				phoneBtn.gotoAndStop(UP);
			}
		}
		private function mouseDown(e:MouseEvent):void {
			if(flashing){
				stopFlashing();
			}
			phoneBtn.gotoAndStop(DOWN);
		}
		private function timerEvent(e:TimerEvent):void {
			var currentLabel:String = phoneBtn.currentFrameLabel;
			if(currentLabel==UP){
				phoneBtn.gotoAndStop(OVER);
			} else {
				phoneBtn.gotoAndStop(UP);
			}
		}
	}
}
