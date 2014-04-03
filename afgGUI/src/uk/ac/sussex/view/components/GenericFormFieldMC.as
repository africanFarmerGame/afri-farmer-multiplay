/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import uk.ac.sussex.model.valueObjects.FormField;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class GenericFormFieldMC extends MovieClip {
		protected var label:GenericFieldLabel;
		protected var field:FormField;
		protected static const GAP_SIZE:Number = 20;
		
		public function GenericFormFieldMC(formField:FormField) {
			field = formField;
			label = new GenericFieldLabel();
			this.addChild(label);
		}

		public function setFieldLabel() : void {
			label.setText(field.getFieldLabel());
		}

		public function setFieldValue() : void {
			throw new Error("This should be implemented on the less generic form field classes");
		}
		
		public function setLabelWidth(labelWidth : Number) : void {
			label.width = labelWidth;
		}

		public function setTotalWidth(totalWidth : Number) : void {
			throw new Error("This should be implemented on the less generic form field classes");
		}
		
		public function updateEnabled():void {
			label.enabled = field.getEnabled();
		}
		public function getName():String {
			return field.getFieldName();
		}
		public function destroy():void {
			
		}
	}
}
