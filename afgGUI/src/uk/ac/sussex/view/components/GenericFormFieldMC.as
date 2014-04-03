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
