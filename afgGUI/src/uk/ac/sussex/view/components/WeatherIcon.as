package uk.ac.sussex.view.components {
	import flash.events.MouseEvent;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class WeatherIcon extends MovieClip {
		private var weatherMC:WeatherMC;
		private var weatherMO:MouseoverTextField;
		
		public function WeatherIcon() {
			weatherMC = new WeatherMC();
			weatherMC.scaleX = 0.25;
			weatherMC.scaleY = 0.25;
			weatherMC.addEventListener(MouseEvent.MOUSE_OVER, weatherMouseover);
			weatherMC.addEventListener(MouseEvent.MOUSE_OUT, weatherMouseout);
			this.addChild(weatherMC); 
			weatherMO = new MouseoverTextField();		
		}
		public function setWeather(weather:String):void {
			trace("WeatherIcon sez: The weather was " + weather);
			weatherMC.gotoAndStop(weather);
			weatherMO.text = weather;
		}
		public function destroy():void {
			if(weatherMO!=null){
				weatherMO.removeFromScreen();
			}
		}
		private function weatherMouseover(e:MouseEvent):void {
			var newX:Number = this.mouseX + 5;
			var newY:Number = this.mouseY - 5;
			weatherMO.addToScreen(weatherMC, newX, newY);
		}
		private function weatherMouseout(e:MouseEvent):void {
			weatherMO.removeFromScreen();
		}
	}
}
