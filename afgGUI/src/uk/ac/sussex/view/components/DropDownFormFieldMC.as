/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import uk.ac.sussex.model.valueObjects.FormFieldOption;
	import uk.ac.sussex.model.valueObjects.FormField;

	/**
	 * @author em97
	 */
	public class DropDownFormFieldMC extends GenericFormFieldMC {
		private var scrollingOptions:ScrollingList;
		private var displayBox:GameTextField;
		private var expandButton:ExpandButton;
		private var clickTime:int = 0;
		private var listOptions:Array;
		
		public static const DISPLAY_LIST:String = "DropDownDisplayList";
		public static const HIDE_LIST:String = "DropDownHideList";
		
		public function DropDownFormFieldMC(formField : FormField) {
			super(formField);
			listOptions = formField.getPossibleValues();
			var initialX:Number = this.label.x + this.label.width + GAP_SIZE;
			
			displayBox = new GameTextField();
			expandButton = new ExpandButton();
			
			displayBox.width = displayBox.width - expandButton.width + 1;
			displayBox.x = initialX;
			displayBox.readonly = true;
			
			expandButton.x = displayBox.x + displayBox.width;
			expandButton.height = displayBox.height;
			expandButton.addEventListener(MouseEvent.MOUSE_UP, expandList);
			
			scrollingOptions = new ScrollingList(displayBox.width + expandButton.width, 200);
			scrollingOptions.y = displayBox.height;
			scrollingOptions.setBorderColour(0x09063A);
			scrollingOptions.showBackgroundFilter(false);
			fillList();
			scrollingOptions.x = this.label.x + GAP_SIZE;
			this.addChild(displayBox);
			this.addChild(expandButton);
			
		}
		public function updateListOptions():void {
			//Need to clear the current value, 
			//And the display, 
			//And refill scrollingList. Actually, I think that bit's easiest.
			listOptions = field.getPossibleValues();
			scrollingOptions.clearList();
			fillList();
		}
		override public function setFieldValue() : void {
			var fieldValue:String = field.getFieldValue();
			if( fieldValue != null){
				for each (var option:FormFieldOption in listOptions){
					if(option.getOutputValue()==fieldValue){
						displayBox.text = option.getDisplayName();
						scrollingOptions.setCurrentSelection(scrollingOptions.getItemWithID(fieldValue));
					}
				}
			} else {
				displayBox.text = "";
				scrollingOptions.clearCurrentSelection();
			}
		}
		override public function setLabelWidth(labelWidth : Number):void {
			super.setLabelWidth(labelWidth);
			displayBox.x = label.x + label.width + GAP_SIZE;
			expandButton.x = displayBox.x + displayBox.width;
			scrollingOptions.x = displayBox.x;
		}
		override public function updateEnabled():void {
			super.updateEnabled();
			var enabled:Boolean = field.getEnabled();
			if(enabled){
				this.addChild(expandButton);
			} else {
				if(expandButton.parent!=null){
					expandButton.parent.removeChild(expandButton);
				}
			}
		}
		public function fetchScrollingList():ScrollingList{
			return scrollingOptions;
		}
		override public function destroy():void {
			scrollingOptions.destroy();
		}
		private function fillList():void {
			for each (var option:FormFieldOption in listOptions){
				var li:DropDownListItem = new DropDownListItem();
				li.width = displayBox.width;
				li.setItemID(option.getOutputValue());
				li.setText(option.getDisplayName());
				li.setStatus(option.getStatus());
				li.setNotes(option.getNotes());
				scrollingOptions.addItem(li);
			}
		}
		private function valueChanged(e:MouseEvent):void {
			if(clickTime>=1){
				var selectedId:String = scrollingOptions.getCurrentValue();
				field.setFieldValue(selectedId);
				if(selectedId==null || selectedId==""){
					displayBox.text = "";
				} else {
					//Get the list item that represents and copy the text over to the display box.
					var tli:DropDownListItem = scrollingOptions.getItemWithID(selectedId) as DropDownListItem;
					if(tli!=null){
						displayBox.text = tli.getText();
					} else {
						throw new Error("Couldn't find a DropDownListItem for selectedId " + selectedId);
					}
				}
				hideScrollingList();
				clickTime = 0;
				this.stage.removeEventListener(MouseEvent.CLICK, valueChanged);
			} else {
				clickTime ++;
			}
		
		}
		private function hideScrollingList():void {
			dispatchEvent(new Event(DropDownFormFieldMC.HIDE_LIST, true));
		}
		private function showScrollingList():void {
			//this.parent.addChild(this);
			scrollingOptions.x = displayBox.x;
			scrollingOptions.y = displayBox.height;
			this.addChild(scrollingOptions);
		}
		private function expandList(e:MouseEvent):void {
			showScrollingList();
			e.stopImmediatePropagation();
			dispatchEvent(new Event(DropDownFormFieldMC.DISPLAY_LIST, true));
			this.stage.addEventListener(MouseEvent.CLICK, valueChanged);
		}
	}
}
