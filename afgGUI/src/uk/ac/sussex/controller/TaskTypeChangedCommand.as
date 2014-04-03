/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.controller {
	import uk.ac.sussex.model.valueObjects.FormFieldOption;
	import uk.ac.sussex.model.valueObjects.Form;
	import uk.ac.sussex.serverhandlers.FarmHandlers;
	import uk.ac.sussex.model.FormProxy;
	import uk.ac.sussex.model.valueObjects.PotentialTask;
	import uk.ac.sussex.model.TaskListProxy;
	import uk.ac.sussex.model.valueObjects.FormField;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author em97
	 */
	public class TaskTypeChangedCommand extends SimpleCommand {
		override public function execute(note:INotification):void {
			
			var taskTypeField:FormField = note.getBody() as FormField;
			if(taskTypeField == null){
				throw new Error("Task type field is null");
			}
			var taskType:String = taskTypeField.getFieldValue();
			var taskLP:TaskListProxy = facade.retrieveProxy(TaskListProxy.NAME) as TaskListProxy;
			var potentialTask:PotentialTask = taskLP.retrievePotentialTask(taskType);
			if(potentialTask==null){
				//We need to clear all of the dropdowns.
				clearDropDowns();
			} else {
				fillDropDowns(potentialTask);
			}
			
		}
		
		private function fillDropDowns(potentialTask:PotentialTask):void {
			var naOption:FormFieldOption = new FormFieldOption("N/A", "0");
			
			var locationOptions:Array = new Array();
			var locations:Array = potentialTask.getLocations();
			
			var taskFormProxy:FormProxy = facade.retrieveProxy(FarmHandlers.TASK_EDIT_FORM) as FormProxy;
			var taskForm:Form = taskFormProxy.getForm();
			
			if(locations!= null && locations.length>0){
				locationOptions = locations;
				taskForm.updatePossibleFieldValues(FarmHandlers.TASK_LOCATION, locationOptions);
				taskForm.setFieldEnabled(FarmHandlers.TASK_LOCATION, true);
				taskForm.setFieldValue(FarmHandlers.TASK_LOCATION, null);
			
			} else {
				locationOptions.push(naOption);
				taskForm.updatePossibleFieldValues(FarmHandlers.TASK_LOCATION, locationOptions);
				taskForm.setFieldEnabled(FarmHandlers.TASK_LOCATION, false);
				taskForm.setFieldValue(FarmHandlers.TASK_LOCATION, "0");
			}
			
			var actorOptions:Array = new Array();
			var actors:Array = potentialTask.getActors();
			if(actors!=null && actors.length>0){
				actorOptions = actors;
				taskForm.updatePossibleFieldValues(FarmHandlers.TASK_ACTOR, actorOptions);
				taskForm.setFieldEnabled(FarmHandlers.TASK_ACTOR, true);
				taskForm.setFieldValue(FarmHandlers.TASK_ACTOR, null);
			} else {
				actorOptions.push(naOption);
				taskForm.updatePossibleFieldValues(FarmHandlers.TASK_ACTOR, actorOptions);
				taskForm.setFieldEnabled(FarmHandlers.TASK_ACTOR, false);
				taskForm.setFieldValue(FarmHandlers.TASK_ACTOR, "0");
			}
			
			var assetOptions:Array = new Array();
			var assets:Array = potentialTask.getAssets();
			if(assets!=null && assets.length>0){
				assetOptions = assets;
				taskForm.updatePossibleFieldValues(FarmHandlers.TASK_ASSET, assetOptions);
				taskForm.setFieldValue(FarmHandlers.TASK_ASSET, null);
				taskForm.setFieldEnabled(FarmHandlers.TASK_ASSET, true);
			} else {
				assetOptions.push(naOption);
				taskForm.updatePossibleFieldValues(FarmHandlers.TASK_ASSET, assetOptions);
				taskForm.setFieldValue(FarmHandlers.TASK_ASSET, "0");
				taskForm.setFieldEnabled(FarmHandlers.TASK_ASSET, false);
			}
		}
		private function clearDropDowns():void {
			var taskFormProxy:FormProxy = facade.retrieveProxy(FarmHandlers.TASK_EDIT_FORM) as FormProxy;
			var taskForm:Form = taskFormProxy.getForm();
			taskForm.setFieldValue(FarmHandlers.TASK_LOCATION, null);
			taskForm.setFieldValue(FarmHandlers.TASK_ACTOR, null);
			taskForm.setFieldValue(FarmHandlers.TASK_ASSET, null);
			taskForm.updatePossibleFieldValues(FarmHandlers.TASK_LOCATION, null);
			taskForm.updatePossibleFieldValues(FarmHandlers.TASK_ACTOR, null);
			taskForm.updatePossibleFieldValues(FarmHandlers.TASK_ASSET, null);
		}
	}
}
