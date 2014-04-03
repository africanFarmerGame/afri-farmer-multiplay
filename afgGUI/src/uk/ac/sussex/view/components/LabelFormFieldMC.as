/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import uk.ac.sussex.model.valueObjects.FormField;

	/**
	 * @author em97
	 */
	public class LabelFormFieldMC extends GenericFormFieldMC {
		private var displayLabel:GameTextField;
		public function LabelFormFieldMC(formField : FormField) {
			super(formField);
			displayLabel = new GameTextField();
			displayLabel.x = label.x + label.width + GAP_SIZE;
			displayLabel.readonly =  true;
			this.addChild(displayLabel);
		}
		override public function setFieldValue() : void {
			var fieldValue:String = field.getFieldValue();
			if( fieldValue != null){
				displayLabel.text = fieldValue;
			} else {
				displayLabel.text = "";
			}
		}
		override public function setLabelWidth(labelWidth : Number):void {
			super.setLabelWidth(labelWidth);
			displayLabel.x = label.x + label.width + GAP_SIZE;
		}
	}
}
