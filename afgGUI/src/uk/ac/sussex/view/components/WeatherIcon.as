/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
