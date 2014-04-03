/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components  {
	import uk.ac.sussex.model.valueObjects.Diet;
	/*
	NutritionGraph generates a graph showing the carb, protein and nutrient contents of a diet to household members
	 */
	 
	import flash.display.*;
	import flash.text.*; 
	import flash.geom.ColorTransform;
	
	public class NutritionGraph extends MovieClip {
	
		private var axis:MovieClip;
		private var graphBg:MovieClip;
		private var axisLabel:TextField;
		private var axisLevelA:TextField = new TextField();
		private var axisLevelB:TextField = new TextField();
		private var axisLevelC:TextField = new TextField();
		private var proteinSS:TextField = new TextField();
		private var nutrientSS:TextField = new TextField();
		private var dietType:int = 0; // 0 = man, 1 = woman, 2= child, 3 = baby
		private var carbBar:MovieClip;
		private var proteinBar:MovieClip;
		private var nutrientBar:MovieClip;	

		private static const AXIS_ZERO_X:Number = 43;
		private static const AXIS_ZERO_Y:Number = 5;
		private static const BAR_SCALE_FACTOR:Number = 1.40;
		private static const LEVEL_A_COLOUR:Number = 0x99e033;
		private static const LEVEL_B_COLOUR:Number = 0xffd51e;
		private static const LEVEL_C_COLOUR:Number = 0xd53500;
		private static const LEVEL_X_COLOUR:Number = 0x000000;
		
		public function NutritionGraph() {	
			
			axisLabel = new TextField();
			axisLabel.width = NutritionGraph.AXIS_ZERO_X;
			displayNutritionGraph();
			setupGraph();
			this.setupAxisLabel(axisLabel,AXIS_ZERO_X - 60, AXIS_ZERO_Y + 11);
			this.setupAxisLevel(axisLevelA, AXIS_ZERO_X + 110, AXIS_ZERO_Y + 80);
			this.setupAxisLevel(axisLevelB, AXIS_ZERO_X + 68, AXIS_ZERO_Y + 80);
			this.setupAxisLevel(axisLevelC, AXIS_ZERO_X + 26, AXIS_ZERO_Y + 80);
			this.setupAxisLevel(proteinSS, AXIS_ZERO_X + 79, AXIS_ZERO_Y + 37);
			this.setupAxisLevel(nutrientSS, AXIS_ZERO_X + 79 ,AXIS_ZERO_Y + 57);
			axisLabel.text = "Carb\nProt\nNutr";
			axisLevelA.text = "A";
			axisLevelB.text = "B";
			axisLevelC.text = "C";
			proteinSS.text = "S";
			nutrientSS.text = "S";
		}
		private function displayNutritionGraph():void {
			axis = new	Axis_mc();
			axis.scaleX = 0.26;
			axis.scaleY = 0.26;
			axis.x = AXIS_ZERO_X;
			axis.y = AXIS_ZERO_Y;
			graphBg = new MovieClip();
			graphBg.graphics.beginFill(0x000000, 0.15);
			graphBg.graphics.drawRect(0, 0, axis.width + 52, axis.height + 10);
			graphBg.graphics.endFill();
			this.addChild(graphBg);
			graphBg.addChild(axis);
			graphBg.addChild(axisLabel);
			graphBg.addChild(axisLevelA);
			graphBg.addChild(axisLevelB);
			graphBg.addChild(axisLevelC);
		}
		private function setupAxisLabel(tField:TextField,xPos:int,yPos:int):void {	
			var tFormat:TextFormat = new TextFormat();
			tFormat.font = "Calibri";
			tFormat.size = 13;
			tFormat.bold = false;
			tFormat.align = TextFormatAlign.RIGHT;
			tFormat.leading = 6;
			tField.defaultTextFormat = tFormat;	
			tField.textColor = 0xffffff;
			tField.background = false;
			tField.border = false;
			tField.wordWrap = false;
			tField.x = xPos;
			tField.y = yPos;
			tField.selectable = false;
			tField.width = 56;
		} 
		private function setupAxisLevel(tField:TextField,xPos:int,yPos:int):void {	
			var tFormat:TextFormat = new TextFormat();
			tFormat.font = "Calibri";
			tFormat.size = 13;
			tFormat.bold = false;
			tFormat.align = TextFormatAlign.RIGHT;
			tFormat.leading = 0;
			tField.defaultTextFormat = tFormat;	
			tField.textColor = 0xffffff;
			tField.background = false;
			tField.border = false;
			tField.wordWrap = false;
			tField.x = xPos;
			tField.y = yPos;
			tField.selectable = false;
			tField.width = 15;
		}
		public function reset():void {
			this.updateCarbBar(Diet.DIET_LEVEL_X, 0);
			this.updateNutrientBar(Diet.DIET_LEVEL_X, 0);
			this.updateProteinBar(Diet.DIET_LEVEL_X, 0);
		}
		public function setDType(dietType:int):void {
			this.dietType = dietType;
		}
		private function setupGraph():void {
			var barHeight:int = 9;
			var baseX:int = 4;
			var baseY:int = 17;
			var barGap:int = 13;
			var barLength:Number = 0.1;
				
			carbBar = new MovieClip();
			carbBar.graphics.beginFill(0xffffff);
			carbBar.graphics.drawRect(0, 0, barLength, barHeight);
			carbBar.graphics.endFill();
			carbBar.x = AXIS_ZERO_X + baseX;
			carbBar.y = AXIS_ZERO_Y + baseY;	
	
			proteinBar = new MovieClip();
			proteinBar.graphics.beginFill(0xffffff);
			proteinBar.graphics.drawRect(0, 0, barLength, barHeight);
			proteinBar.graphics.endFill();
			proteinBar.x = AXIS_ZERO_X + baseX;
			proteinBar.y = carbBar.y + carbBar.height + barGap;		
			
			nutrientBar = new MovieClip();
			nutrientBar.graphics.beginFill(0xffffff);
			nutrientBar.graphics.drawRect(0, 0, barLength, barHeight);
			nutrientBar.graphics.endFill();
			nutrientBar.x = AXIS_ZERO_X + baseX;
			nutrientBar.y = proteinBar.y + proteinBar.height + barGap;			
			addChild(carbBar);
			addChild(proteinBar);
			addChild(nutrientBar);			
		}
		public function updateCarbBar(carbLevel:String, carbDelta:Number):void {
			this.updateGraph(carbBar, carbLevel, carbDelta);
		}
		public function updateProteinBar(proteinLevel:String, proteinDelta:Number):void {
			this.updateGraph(proteinBar, proteinLevel, proteinDelta);
		}
		public function updateNutrientBar(nutrientLevel:String, nutrientDelta:Number):void {
			this.updateGraph(nutrientBar, nutrientLevel, nutrientDelta);
		}
		private function updateGraph(bar:MovieClip, level:String, delta:Number):void {
			var colourTransform:ColorTransform = new ColorTransform();
			var barLength:Number = 0;
			switch (level) {
				case Diet.DIET_LEVEL_A:
					colourTransform.color = LEVEL_A_COLOUR;
					if (delta > 1.2) {
						barLength = 100;
					} else if (delta > 0) {
						barLength = 95;
					} else {
						barLength = 90;
					}
					break;
				case Diet.DIET_LEVEL_B:
					colourTransform.color = LEVEL_B_COLOUR;
					barLength += 60 + 30*delta;
					break;
				case Diet.DIET_LEVEL_C:
					colourTransform.color = LEVEL_C_COLOUR;
					barLength = 30;
					barLength +=  30*delta;
					break;	
				case Diet.DIET_LEVEL_X:
					colourTransform.color = LEVEL_X_COLOUR;
					barLength = 0;
					barLength +=  30*delta;
					break;	
			}
			bar.width = barLength*BAR_SCALE_FACTOR;
			bar.transform.colorTransform = colourTransform;
			
		}
	}
}