/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class RadioButtonMC extends MovieClip {
		
		private var upIcon:RadioButton_upIcon;
		private var downIcon:RadioButton_downIcon;
		private var overIcon:RadioButton_overIcon;
		private var disabledIcon:RadioButton_disabledIcon;
		private var selectedUpIcon:RadioButton_selectedUpIcon;
		private var selectedDownIcon:RadioButton_selectedDownIcon;
		private var selectedOverIcon:RadioButton_selectedOverIcon;
		
		private var isSelected:Boolean;
		
		public function RadioButtonMC() {
			setupIcons();
			this.makeVisible(upIcon);
		}
		
		public function set selected(selected:Boolean):void{
			isSelected = selected;
			if(isSelected){
				this.makeVisible(selectedUpIcon);
			} else {
				this.makeVisible(upIcon);
			}
		}
		public function get selected():Boolean{
			return isSelected;
		}
		
		private function setupIcons():void{
			upIcon = new RadioButton_upIcon();
			this.addChild(upIcon);
			downIcon = new RadioButton_downIcon();
			this.addChild(downIcon);
			overIcon = new RadioButton_overIcon();
			this.addChild(overIcon);
			selectedUpIcon = new RadioButton_selectedUpIcon();
			this.addChild(selectedUpIcon);
			selectedDownIcon = new RadioButton_selectedDownIcon();
			this.addChild(selectedDownIcon);
			selectedOverIcon = new RadioButton_selectedOverIcon();
			this.addChild(selectedOverIcon);
			disabledIcon = new RadioButton_disabledIcon();
			this.addChild(disabledIcon);
		}
		public function mouseOver():void {
			if(isSelected){
				this.makeVisible(selectedOverIcon);
			} else {
				this.makeVisible(overIcon);
			}
		}
		public function mouseDown():void {
			if(isSelected){
				this.makeVisible(selectedDownIcon);
			} else {
				this.makeVisible(downIcon);
			}
		}
		public function mouseUp():void {
			if(isSelected){
				this.makeVisible(selectedUpIcon);
			} else {
				this.makeVisible(upIcon);
			}
		}
		public function mouseOut():void {
			if(isSelected){
				this.makeVisible(selectedUpIcon);
			} else {
				this.makeVisible(upIcon);
			}
		}
		override public function set enabled(enabled:Boolean):void {
			super.enabled = enabled;
			if(enabled){
				if(isSelected){
					this.makeVisible(selectedUpIcon);
				} else {
					this.makeVisible(upIcon);
				}
			} else {
				this.makeVisible(disabledIcon);
			}
		}
		private function makeVisible(icon:MovieClip):void{
			disabledIcon.visible = false;
			upIcon.visible = false;
			downIcon.visible = false;
			overIcon.visible = false;
			selectedUpIcon.visible = false;
			selectedDownIcon.visible = false;
			selectedOverIcon.visible = false;
			
			icon.visible = true;
		}
	}
}
