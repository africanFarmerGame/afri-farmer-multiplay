/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.serverhandlers {
	/**
	 * @author em97
	 */
	public class HomeHandlers {
		public static const HEARTH_ID:String = "hearthId";
		
		public static const GET_MEMBER_DETAILS:String = "home.get_member_details";
		public static const GET_MEMBER_DETAILS_ERROR:String = "get_member_details_error";
		public static const HOME_ERROR:String = "homeError";
		public static const HEARTH_MEMBERS_LIST:String = "hearthMembersList";
		public static const GET_HEARTH_ASSETS:String = "home.get_hearth_assets";
		public static const GET_HEARTH_ASSETS_ERROR:String = "get_hearth_assets_error";
		public static const HEARTH_ASSETS_LIST:String = "HearthAssetsList";
		public static const GET_GAME_ASSETS:String = "home.get_game_assets";
		public static const GET_GAME_ASSETS_ERROR:String = "get_game_assets_error";
		public static const GAME_ASSETS_LIST_RECEIVED:String = "GameAssetsListReceived";
		public static const MEMBER_RESURRECTED:String = "FamilyMemberResurrected";
		
		public static const SUB_MENU_OVERVIEW:String = "Overview";
		public static const SUB_MENU_WORK:String = "Tasks";
		public static const SUB_MENU_ASSETS:String = "Assets";
		public static const SUB_MENU_DIET:String = "Food";
		
		public static const TASKS_SUB_MENU_OVERVIEW:String = "Overview";
		public static const TASKS_SUB_MENU_NEW:String = "New";
		public static const TASKS_SUB_MENU_EDIT:String = "Edit";
		public static const TASKS_SUB_MENU_DELETE:String = "Delete";
		public static const TASKS_SUB_MENU_LIST:String = "List";
		public static const TASKS_SUB_MENU_EXIT:String = "Return";
				
		public static const FOOD_SUB_MENU_OVERVIEW:String = "Overview";
		public static const FOOD_SUB_MENU_DIET:String = "Diet";
		public static const FOOD_SUB_MENU_ALLOCATION:String = "Allocation";
		public static const FOOD_SUB_MENU_SELECT:String = "Select";
		public static const FOOD_SUB_MENU_EXIT:String = "Return";
		
		public static const DIET_SUB_MENU_OVERVIEW:String = "Overview";
		public static const DIET_SUB_MENU_NEW:String = "New";
		public static const DIET_SUB_MENU_EDIT:String = "Edit";
		public static const DIET_SUB_MENU_DELETE:String = "Delete";
		public static const DIET_SUB_MENU_EXIT:String = "Return";
		
		public static const ALLOC_SUB_MENU_OVERVIEW:String = "Overview";
		public static const ALLOC_SUB_MENU_NEW:String = "New";
		public static const ALLOC_SUB_MENU_EDIT:String = "Edit";
		public static const ALLOC_SUB_MENU_DELETE:String = "Delete";
		public static const ALLOC_SUB_MENU_EXIT:String = "Return";
		
		public static const GET_DIET_LIST:String = "home.get_diets";
		public static const GET_DIET_LIST_ERROR:String = "get_diets_error";
		public static const DIET_LIST:String = "DietsList";
		
		public static const SAVE_DIET:String = "home.save_diet";
		public static const SAVE_DIET_ERROR:String = "save_diet_error";
		public static const SAVE_DIET_SUCCESS:String = "save_diet_success";
		
		public static const DELETE_DIET:String = "home.delete_diet";
		public static const DELETE_DIET_ERROR:String = "delete_diet_error";
		public static const DELETE_DIET_SUCCESS:String = "diet_deleted";
		
		public static const GET_DIETARY_REQS:String = "home.get_dietary_reqs";
		public static const DIETARY_REQUIREMENTS:String = "DietaryRequirements";
		
		public static const GET_ALLOCATIONS:String = "home.get_allocations";
		public static const GET_ALLOCATIONS_ERROR:String = "get_allocations_error";
		public static const ALLOCATIONS_LIST:String = "AllocationsList";
		
		public static const SAVE_ALLOCATION:String = "home.save_allocation";
		public static const SAVE_ALLOCATION_ERROR:String = "save_allocation_error";
		public static const SAVE_ALLOCATION_SUCCESS:String = "save_allocation_success";
		
		public static const DELETE_ALLOCATION:String = "home.delete_allocation";
		public static const DELETE_ALLOCATION_ERROR:String = "delete_allocation_error";
		public static const DELETE_ALLOCATION_SUCCESS:String = "allocation_deleted";
		
		public static const SET_SELECTED_ALLOCATION:String = "home.set_active_allocation";
		public static const SET_SELECTED_ALLOCATION_ERROR:String = "set_active_allocation_error";
		public static const SET_SELECTED_ALLOCATION_SUCCESS:String = "set_active_allocation_success";
		
		public static const ALLOCATION_UPDATED:String = "AllocationsUpdated";
		
		public static const DISPLAY_DIET:String = "displayThisDiet";
		
		public static const HEARTH_MEMBER_HEARTH_CHANGED:String = "HearthMemberHearthChanged";
		public static const HMHC_CHAR:String = "CharId";
		public static const HMHC_HEARTH:String = "HearthId";
		
		//GAME MANAGER CONSTANTS
		public static const GM_SUB_MENU_GAMEOVERVIEW:String = "Overview";
		public static const GM_SUB_MENU_TICKER:String = "Set Ticker";
		public static const GM_SUB_MENU_STAGEPROGRESS:String = "Progress";
		public static const GM_SUB_MENU_CHANGESTAGE:String = "New Stage";
		public static const GM_SUB_MENU_ENDGAME:String = "End Game";
		
		public static const SEND_TICKER_FORM:String = "SendTickerForm";
		public static const TICKER_MESSAGE:String = "TickerMessage";
		public static const TICKER_EXPIRES:String = "TickerExpires";
		public static const TICKER_DURATION:String = "TickerDuration";
		public static const TICKER_DURATION_UNIT:String = "TickerDurationUnit";
		public static const TICKER_EXPIRES_CHANGED:String = "TickerExpiresChanged";
		
		public static const TICKER_CANCEL:String = "CancelSendTickerForm";
		public static const TICKER_SUBMIT:String = "SubmitSendTickerForm";
		public static const TICKER_CLEAR:String = "SubmitClearTickerForm";
		
		public static const SUBMIT_TICKER_REQUEST:String = "comms.ticker_announce";
		public static const SUBMIT_TICKER_REQUEST_ERROR:String = "ticker_announce_error";
		
		public static const GM_END_GAME_FORM:String = "EndGameForm";
		public static const GM_END_GAME_SUBMIT:String = "SubmitEndGame";
		public static const GM_END_GAME_CANCEL:String = "CancelEndGame";
		
		public static const SUBMIT_END_GAME:String = "game.end_game";
		public static const END_GAME_ERROR:String = "end_game_error";
		
		public static const FETCH_STAGES:String = "seasons.fetch_gm_stage_info";
		public static const FETCH_STAGES_ERROR:String = "fetch_gm_stage_info_error";
		public static const STAGES_RECEIVED:String = "gm_stage_info";
		public static const GM_CURRENT_SEASON:String = "CurrentSeason";
		public static const GM_CURRENT_STAGE:String = "CurrentStage";
		public static const GM_NEXT_SEASON:String = "NextSeason";
		public static const GM_NEXT_STAGE:String = "NextStage";
		
		public static const GM_FETCH_PENDING_TASKS:String = "farm.gm_fetch_pending_tasks";
		public static const GM_FETCH_PENDING_TASKS_ERROR:String = "gm_fetch_pending_tasks_error";
		public static const GM_PENDING_TASKS_RECEIVED:String = "gm_pending_task_count";
		public static const GM_PENDING_TASKS_UPDATED:String = "gm_pending_tasks_updated";
		
		public static const GM_FETCH_FOOD_OVERVIEW:String = "home.gm_fetch_food_overview";
		public static const GM_FETCH_FOOD_ERROR:String = "gm_fetch_food_overview_error";
		public static const GM_FOOD_OVERVIEW_RECEIVED:String = "gm_food_overview";
		public static const GM_FOOD_OVERVIEW_UPDATED:String = "gm_food_overview_updated";
	}
}
