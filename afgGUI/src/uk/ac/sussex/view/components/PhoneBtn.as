/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
