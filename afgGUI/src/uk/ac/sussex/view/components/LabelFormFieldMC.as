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
