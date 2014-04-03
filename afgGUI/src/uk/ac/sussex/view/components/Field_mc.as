﻿/**This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	**/package uk.ac.sussex.view.components {		import flash.text.*;	import uk.ac.sussex.model.valueObjects.GameAsset;	import uk.ac.sussex.model.valueObjects.Field;	import flash.events.MouseEvent;	import flash.display.MovieClip;			public class Field_mc extends MovieClip {		private var field:Field;		private var cropIcon:AssetIcon;		private var cropMouseOver:MouseoverTextField;		private var fieldMouseoverText:MouseoverTextField;		private var hazardMouseoverText:MouseoverTextField;		private var fertiliserIcon:FertilizerIcon_mc;		private var hazardIcon:HazardIcon_mc;		private var fieldName:TextField;				public function Field_mc() {			// constructor code			var fieldMC:FieldMC = new FieldMC();			fieldMC.width = 210;			fieldMC.height = 136;			this.addChild(fieldMC);			cropMouseOver = new MouseoverTextField();			fieldMouseoverText = new MouseoverTextField();			hazardMouseoverText = new MouseoverTextField();			setupFieldCropIcon();			setupFertiliserIcon();			setupHazardIcon();			setupFieldName();			this.addEventListener(MouseEvent.MOUSE_OVER, fieldMouseOver);			this.addEventListener(MouseEvent.MOUSE_OUT, fieldMouseOut);		}		public function getFieldId():int {			return this.field.getId();		}		public function getField():Field {			return this.field;		}		public function setField(newField:Field):void {			this.field = newField;			fieldMouseoverText.text = field.getName();			updateCropIcon();			updateFertiliserIcon();			updateHazardIcon();			fieldName.text = field.getName();		}		public function destroy():void {			if(fieldMouseoverText!=null){					fieldMouseoverText.removeFromScreen();			}			if(hazardMouseoverText!=null){				hazardMouseoverText.removeFromScreen();			}			if(cropMouseOver!=null){				cropMouseOver.removeFromScreen();			}		}		private function updateCropIcon():void {			var crop:GameAsset = this.field.getCrop();			if(crop==null){				//Need to hide the crop icon, if it was ever added.				if(cropIcon.parent!=null){					cropIcon.parent.removeChild(cropIcon);				}				cropMouseOver.text = "";			} else {				cropIcon.setType(crop.getType(), crop.getSubtype());				this.addChild(cropIcon);				cropMouseOver.text = crop.getName();			}		}		private function updateFertiliserIcon():void {			var fertiliser:GameAsset = this.field.getFertiliser();			if(fertiliser==null){				if(fertiliserIcon.parent!=null){					fertiliserIcon.parent.removeChild(fertiliserIcon);				} 			} else {				this.addChild(fertiliserIcon);			}		}		private function updateHazardIcon():void {			var hazard:String = this.field.getHazard();			if(hazard==null){				if(hazardIcon.parent!= null){					hazardIcon.parent.removeChild(hazardIcon);				}			} else {				hazardMouseoverText.text = "Hazard: " + hazard;				this.addChild(hazardIcon);			}		}		private function setupFieldName() : void {			fieldName = new TextField();			fieldName.height = 18;			fieldName.textColor = 0x000000;			fieldName.y = 0;			fieldName.x = (this.width - fieldName.width)/2;			fieldName.autoSize = TextFieldAutoSize.CENTER;			var textFormat:TextFormat = new TextFormat();			textFormat.font = "Calibri";			textFormat.size = 12;			textFormat.leftMargin = 6;			textFormat.rightMargin = 6;			textFormat.font = "Calibri";			fieldName.defaultTextFormat = textFormat;			fieldName.text = "Field Name";			this.addChild(fieldName);		}		private function setupFieldCropIcon () : void{			cropIcon = new AssetIcon();			cropIcon.scaleX = 0.17;			cropIcon.scaleY = 0.17;			cropIcon.x = (this.width - cropIcon.width)/2;			cropIcon.y = (this.height - cropIcon.height)/2;		}		private function setupFertiliserIcon():void {			fertiliserIcon = new FertilizerIcon_mc();			fertiliserIcon.scaleX = 0.26;			fertiliserIcon.scaleY = 0.26;			fertiliserIcon.x = 3;			fertiliserIcon.y = 120 - fertiliserIcon.height - 3;		}		private function setupHazardIcon():void {			hazardIcon = new HazardIcon_mc();			hazardIcon.scaleX = 0.25;			hazardIcon.scaleY = 0.25;			hazardIcon.y = 120 - hazardIcon.height - 3;			hazardIcon.x = 3 + 22;		}		private function fieldMouseOver(e:MouseEvent):void {			if(e.target is Field_mc){				showMouseoverText(fieldMouseoverText);				hideMouseoverText(cropMouseOver);				hideMouseoverText(hazardMouseoverText);			} else if(e.target is AssetIcon) {				hideMouseoverText(fieldMouseoverText);				showMouseoverText(cropMouseOver);				hideMouseoverText(hazardMouseoverText);			} else if(e.target is HazardIcon_mc){				hideMouseoverText(fieldMouseoverText);				hideMouseoverText(cropMouseOver);				showMouseoverText(hazardMouseoverText);			}		}		private function fieldMouseOut(e:MouseEvent):void {			this.hideMouseoverText(fieldMouseoverText);			this.hideMouseoverText(cropMouseOver);		}		private function showMouseoverText(mouseoverText:MouseoverTextField):void {			mouseoverText.addToScreen(this, this.mouseX, this.mouseY);		}		private function hideMouseoverText(mouseoverText:MouseoverTextField):void {			mouseoverText.removeFromScreen();		}	}	}