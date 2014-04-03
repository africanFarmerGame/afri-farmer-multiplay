/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class FormButton {
		private var name:String;
		private var label:String;
		private var notification:String;
		private var submitFormData:Boolean;
		public function FormButton():void{
			
		}
		public function getName():String {
			return name;
		}
		public function setName(newName:String):void {
			name = newName;
		}
		public function getLabel():String {
			return label;
		}
		public function setLabel(newLabel:String):void {
			label = newLabel;
		}
		public function getNotification():String {
			return notification; 
		}
		public function setNotification(newNotification:String):void {
			notification = newNotification;
		}
		public function getSubmitFormData():Boolean {
			return submitFormData;
		}
		public function setSubmitFormData(submitFormData:Boolean):void {
			this.submitFormData = submitFormData;
		}
	}
}
