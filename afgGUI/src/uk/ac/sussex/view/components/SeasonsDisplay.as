/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import uk.ac.sussex.model.valueObjects.Season;
	import flash.text.*;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class SeasonsDisplay extends MovieClip {
		private var seasonLabels:Array;
		private var seasonFormat:TextFormat;
		private var highlightFormat:TextFormat;
		private var seasonHighlight:MRseasonBg;
		private var stageLabel:SeasonStageMC;
		private var weatherIcons:Array;
		
		private static const LABEL_YPOS:uint = 5;
		private static const LABEL_ALPHA:Number = 0.7;
		//private static const STAGE_BASE_X:Number = 20;
		private static const STAGE_BASE_Y:Number = 71;
		private static const WEATHER_Y:Number = 30;
		
		public function SeasonsDisplay(width:Number, height:Number) {
			//this.graphics.lineStyle(1, 0x000000);
			this.graphics.beginFill(0xddddff, 0);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
			
			seasonLabels = new Array();
			weatherIcons = new Array();
			stageLabel = new SeasonStageMC();
			
			seasonFormat = new TextFormat();
			seasonFormat.font = "Arial";
			seasonFormat.size = 12;
			seasonFormat.color = 0x09063A;
			seasonFormat.align = TextFormatAlign.CENTER;
			
			highlightFormat = new TextFormat();
			highlightFormat.font = "Arial";
			highlightFormat.size = 12;
			highlightFormat.color = 0x09063A;
			highlightFormat.align = TextFormatAlign.CENTER;
			highlightFormat.bold = true;
			
			this.mouseChildren = false;
		}
		public function addSeasonLabels(seasonList:Array):void{
			var maxSeasons:int = seasonList.length;
			if(maxSeasons > 0 ){
				var labelWidth:Number = this.width / maxSeasons;
				
				for each (var season:Season in seasonList){
					var seasonLabel:TextField = this.configureSeasonLabel();
					seasonLabel.width = labelWidth;
					seasonLabel.text = season.getName();
					seasonLabel.x = labelWidth * (season.getDisplayOrder() - 1); //- labelWidth/2;
					seasonLabel.y = LABEL_YPOS;
					this.addChild(seasonLabel);
					seasonLabels[season.getDisplayOrder()] = seasonLabel; 
					var weatherIcon:WeatherIcon = new WeatherIcon();
					weatherIcon.y = WEATHER_Y;
					weatherIcon.x = seasonLabel.x + seasonLabel.width/2 - weatherIcon.width/2;
					weatherIcons[season.getDisplayOrder()] = weatherIcon;
				}
				
				seasonHighlight = new MRseasonBg();
				var newHeight:Number = seasonHighlight.height * (labelWidth/seasonHighlight.width);
				seasonHighlight.width = labelWidth;
				seasonHighlight.height = newHeight;
			}
		}
		public function highlightSeason(displayNumber:uint):void {
			/**for each (var label:TextField in seasonLabels){
				label.filters = [];
				label.alpha = LABEL_ALPHA;
			}
			var currentLabel:TextField = seasonLabels[displayNumber] as TextField;
			currentLabel.filters = [seasonHighlight];
			currentLabel.alpha = 1;**/
			var currentLabel:TextField = seasonLabels[displayNumber] as TextField;
			if(currentLabel!=null){
				var currentText:String = currentLabel.text;
				currentLabel.defaultTextFormat = highlightFormat;
				currentLabel.text = currentText;
			}
			seasonHighlight.x = (displayNumber - 1) * seasonHighlight.width;
			this.addChild(seasonHighlight);
		}
		public function displayStage(stageName:String, displayPos:int):void {
			//Need to clear any previous stage label. 
			//Need to create a stage label. 
			//stageLabel:SeasonStageMC = new SeasonStageMC();
			stageLabel.label = stageName;
			var currentLabel:TextField = seasonLabels[displayPos] as TextField;
			var xPos:Number = currentLabel.x + (currentLabel.width/2);
			stageLabel.x = xPos - (stageLabel.width/2);
			stageLabel.y = STAGE_BASE_Y;
			this.addChild(stageLabel);
		}
		public function showWeather(weather:String, weatherSeason:int):void{
			trace("SeasonsDisplay sez: we should be showing weather " + weather + " for season " + weatherSeason);
			var weatherIcon:WeatherIcon = weatherIcons[weatherSeason] as WeatherIcon;
			weatherIcon.setWeather(weather);
			this.addChild(weatherIcon);
		}
		public function hideWeather():void {
			for each (var weatherIcon:WeatherIcon in weatherIcons){
				if(weatherIcon.parent != null){
					weatherIcon.parent.removeChild(weatherIcon);
				}
			}
		}
		public function destroy():void {
			for each (var weatherIcon:WeatherIcon in weatherIcons){
				weatherIcon.destroy();
			}
		}
		private function configureSeasonLabel():TextField{
			var seasonLabel:TextField = new TextField();
			seasonLabel.defaultTextFormat = seasonFormat;
			seasonLabel.alpha = LABEL_ALPHA;
			return seasonLabel;
		}
	}
}
