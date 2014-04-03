/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.serverhandlers {
	/**
	 * @author em97
	 */
	public class FarmHandlers {
		public static const GET_FIELD_DETAILS:String = "farm.get_field_details";
		public static const FIELD_DETAILS_RECIEVED:String = "FieldDetails";
		public static const FARM_ERROR:String = "farmError";
		public static const FIELD_DETAILS_ERROR:String = "get_field_details_error";
		
		public static const SUB_MENU_SUMMARY:String = "Summary";
		public static const SUB_MENU_TASKS:String = "Tasks";
		public static const SUB_MENU_STOCKS:String = "Stocks";
		
		public static const TASK_SUB_MENU_LIST:String = "List";
		public static const TASK_SUB_MENU_NEW:String = "New";
		public static const TASK_SUB_MENU_EDIT:String = "Edit";
		public static const TASK_SUB_MENU_DELETE:String = "Delete";
		public static const TASK_SUB_MENU_EXIT:String = "Return";
		
		public static const GET_POSSIBLE_TASKS:String = "farm.get_possible_tasks";
		public static const POSSIBLE_TASKS_RECEIVED:String = "PossibleTasks";
		public static const POSSIBLE_TASKS_ERROR:String = "get_possible_tasks_error";
		
		public static const GET_HOUSEHOLD_TASKS:String = "farm.get_household_tasks";
		public static const HOUSEHOLD_TASKS_RECEIVED:String = "HouseholdTasks";
		public static const HOUSEHOLD_TASKS_ERROR:String = "get_household_tasks_error";
		
		public static const DELETE_HOUSEHOLD_TASK:String = "farm.delete_task";
		public static const HOUSEHOLD_TASK_DELETED:String = "DeletedTask";
		public static const DELETE_TASK_ERROR:String ="delete_task_error";
		public static const UPDATED_TASKS:String = "tasks";
		
		public static const TASK_EDIT_FORM:String = "task_edit_form";
		public static const TASK_ID:String = "taskId";
		public static const TASK_HEARTH:String = "taskHearth";
		public static const TASK_TYPE:String = "taskType";
		public static const TASK_LOCATION:String = "taskLocation";
		public static const TASK_ASSET:String = "taskAsset";
		public static const TASK_ACTOR:String = "taskActor";
		public static const TASK_TYPE_UPDATED:String = "TaskFormTaskTypeUpdated";
		public static const TASK_SUBMIT:String = "TaskFormTaskSubmit";
		public static const TASK_CANCEL:String = "TaskFormTaskCancel";
		
		public static const TASK_SAVE:String = "farm.save_task";
		public static const TASK_SAVE_ERROR:String = "save_task_error";
		
		public static const TASK:String = "Task";
		public static const NEW_TASK_RECEIVED:String = "NewTask";
	}
}
