/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {

	/*
	LayoutMgr scales and positions objects for display
	 */
	 
	import flash.display.*;
	
	public class LayoutMgr extends Sprite {
	
		static var fieldPos:Array = new Array(); // array with co-ods for up to 8 fields.
		static var avatarX:int = 100; // tracks x-postion of family view avatars
		static var publicAvatarX:int = 680; // tracks x-postion of other player icons for each view.

		function LayoutMgr() {
		}	

		/******************************************************************/
		/*               Family View                                      */
		/******************************************************************/
		
		// Scale and position family avatars
		function sizePosAvatar(avatar:MovieClip, avatarName:String):void {
			
			var gapX:int = 5;
			var baseY:int = 420;
			
			switch (avatarName) {	
				case "man1":
				case "man2":
					avatar.scaleX = 0.31;
					avatar.scaleY = 0.31;
					break;		
				case "man3":
					avatar.scaleX = 0.46;
					avatar.scaleY = 0.46;
					break;	
				case "man5":
					avatar.scaleX = 0.5;
					avatar.scaleY = 0.5;		
					break;
				case "man4":
				case "man6":
					avatar.scaleX = 0.6;
					avatar.scaleY = 0.6;
					break;	
				case "woman1":
					avatar.scaleX = 0.39;
					avatar.scaleY = 0.37;
					break;
				case "woman2":
					avatar.scaleX = 0.32;
					avatar.scaleY = 0.32;
					break;
				case "woman3":
				case "woman4":
					avatar.scaleX = 0.5;
					avatar.scaleY = 0.5;
					break;
				case "boy1":
					avatar.scaleX = 0.31;
					avatar.scaleY = 0.3;
					break;
				case "girl1":
					avatar.scaleX = 0.34;
					avatar.scaleY = 0.32;
					break;
				case "girl2":
					avatar.scaleX = 0.38;
					avatar.scaleY = 0.35;
					break;
			}
			avatar.x = avatarX + gapX;
			avatarX += (avatar.width + gapX);
			avatar.y = baseY - avatar.height;

		}		
		/******************************************************************/
		/*               Farm View                                        */
		/******************************************************************/
		
		// calculate co-ods for up to 8 fields and load in fieldPos array
		function setFieldCoordinates():void {
			
			// Field_mc dim = 180 x 120
			
			var xBase:int = 330; // co-ods of field 1
			var yBase:int = 180;
			var xOffset:int = 180;
			var yOffset:int = 120;
			for (var i:int = 0; i < 9;i++) {
				fieldPos.push([xBase, yBase + (i*yOffset)]);
				fieldPos.push([xBase + xOffset, yBase +(i*yOffset)]);
			}
		}
		// postion field graphics
		function positionFieldGraphic(fieldGraphic:DisplayObject, fieldNumber:int):void {
				
			fieldGraphic.x = fieldPos[fieldNumber - 1][0];
			fieldGraphic.y = fieldPos[fieldNumber - 1][1];
		}
		// Scale field status icons (fertilizer, labour etc.)
		function scaleFieldStatusIcon(grObj:MovieClip,iconName:String):void {
			
			switch (iconName) {
				case "Labour":
					grObj.scaleX = 0.11;
					grObj.scaleY = 0.11;
					break;
				case "Irrigation":
					grObj.scaleX = 0.21;
					grObj.scaleY = 0.21;
					break;
				case "Fertilizer":
					grObj.scaleX = 0.68;
					grObj.scaleY = 0.68;				
					break;
				case "Pesticide":
					grObj.scaleX = 0.19;
					grObj.scaleY = 0.19;				
					break;
				case "Hazard":
					grObj.scaleX = 0.08;
					grObj.scaleY = 0.08;
					break;
			}
		}
		// position field status icons (fertilizer, labour etc.) on field graphic
		function positionFieldStatusIcon(grObj:DisplayObject, fieldNumber:int, pos:int):void {
			
			/* Field_mc dim = 180 x 120
			   pos = position of icon in sequence
			   Add 3 pixel offset from edges of fields
			*/
			
			var xOffset:int = 3 + 22*(pos - 1); 
			var yOffset:int = 120 - grObj.height - 3; // field height - icon height - offset
			
			grObj.x = fieldPos[fieldNumber - 1][0] + xOffset;
			grObj.y = fieldPos[fieldNumber - 1][1] + yOffset;

		}
		// Scale & position (planted) crop icons on field graphics 
		function sizePosFieldCropIcon(grObj:DisplayObject, assetName:String, fieldNumber:int):void {
		
			switch (assetName) {
				case "Maize":
					grObj.scaleX = 0.56;
					grObj.scaleY = 0.56;
					break;
				case "HYV Maize":
					grObj.scaleX = 0.56;
					grObj.scaleY = 0.56;
					break;
				case "Beans":
					grObj.scaleX = 0.65;
					grObj.scaleY = 0.65;
					break;
				case "Cassava":
					grObj.scaleX = 0.67;
					grObj.scaleY = 0.67;
					break;	
				case "Cotton":
					grObj.scaleX = 0.45;
					grObj.scaleY = 0.45;
					break;		
			}
			// Field_mc dim = 200 x 133
			grObj.x = fieldPos[fieldNumber - 1][0] + (180 - grObj.width)/2;
			grObj.y = fieldPos[fieldNumber - 1][1] + (120 - grObj.height)/2;
		}

		/******************************************************************/
		/*               Farm View & Market View                          */
		/******************************************************************/
		
		// Scale asset icons for stock scrollpanels
		function sizeAssetIcons(grObj:DisplayObject, assetName:String):void {
			
			switch (assetName) {
				case "Maize":
					grObj.scaleX = 0.5;
					grObj.scaleY = 0.5;
					break;
				case "HYV Maize":
					grObj.scaleX = 0.5;
					grObj.scaleY = 0.5;
					break;
				case "Beans":
					grObj.scaleX = 0.62;
					grObj.scaleY = 0.62;
					break;
				case "Cassava":
					grObj.scaleX = 0.5;
					grObj.scaleY = 0.5;
					break;	
				case "Cotton":
					grObj.scaleX = 0.37;
					grObj.scaleY = 0.37;
					break;	
				case "Fertilizer":
					grObj.scaleX = 0.48;
					grObj.scaleY = 0.48;
					break;	
				case "Pesticide":
					grObj.scaleX = 0.44;
					grObj.scaleY = 0.42;
					break;				
				case "Irrigation":
					grObj.scaleX = 0.48;
					grObj.scaleY = 0.48;
					break;	
				case "Vouchers":
					grObj.scaleX = 0.49;
					grObj.scaleY = 0.49;		
					break;				
				case "Land":
					grObj.scaleX = 0.49;
					grObj.scaleY = 0.49;
					break;		
			}
		}		
		/******************************************************************/
		/*               Village View                                     */
		/******************************************************************/

		// Scale & position status icons fro village view. 
		public function sizePosFamilyStatusIcon(grObj:DisplayObject, houseIcon:DisplayObject):void {
			
			grObj.scaleX = 0.05;
			grObj.scaleY = 0.05;
			grObj.x = houseIcon.x + 5;
			grObj.y = houseIcon.y + 43;
		}		
		
		/******************************************************************/
		/*               Navigation & Task Buttons                        */
		/******************************************************************/
		
		// Position task buttons down LH side of display
		function sizePosTaskBtn(taskBtn:SimpleButton,ypos:int):void {
			
			var baseX:Number = 10;
			var baseY:Number = 160;
			var gapY:int = 8;
			
			taskBtn.x = baseX;
			taskBtn.y = baseY + ypos*(taskBtn.height +gapY);
		}	
		/******************************************************************/
		/*               All views                                        */
		/******************************************************************/
		
		// Scale other player icons in each view.
		function sizePublicAvatar(avatar:MovieClip, avatarName:String):void {
			
			switch (avatarName) {	
				case "man1":
				case "man2":
					avatar.scaleX = 0.15;
					avatar.scaleY = 0.15;
					break;		
				case "man3":
					avatar.scaleX = 0.23;
					avatar.scaleY = 0.23;
					break;	
				case "man5":
					avatar.scaleX = 0.23;
					avatar.scaleY = 0.23;		
					break;
				case "man4":
				case "man6":
					avatar.scaleX = 0.24;
					avatar.scaleY = 0.24;
					break;	
				case "woman1":
					avatar.scaleX = 0.2;
					avatar.scaleY = 0.19;
					break;
				case "woman2":
					avatar.scaleX = 0.16;
					avatar.scaleY = 0.16;
					break;
				case "woman3":
				case "woman4":
					avatar.scaleX = 0.19;
					avatar.scaleY = 0.19;
					break;
				case "boy1":
					avatar.scaleX = 0.15;
					avatar.scaleY = 0.15;
					break;
				case "girl1":
					avatar.scaleX = 0.17;
					avatar.scaleY = 0.16;
					break;
				case "girl2":
					avatar.scaleX = 0.19;
					avatar.scaleY = 0.17;
					break;
			}
		}		
		// Postion other player icons in each view.
		function posPublicAvatar(avatar:MovieClip, ordinal:int):void {
			
			var gapX:int = 10;
			var baseY:int = 450;
			
			if (ordinal == 0) {  // displaying a new view so reset starting X-pos
				publicAvatarX = 680;
			}
			avatar.x = publicAvatarX + gapX;
			publicAvatarX -= (avatar.width + gapX);
			avatar.y = baseY - avatar.height;			
		}			
	}
}
