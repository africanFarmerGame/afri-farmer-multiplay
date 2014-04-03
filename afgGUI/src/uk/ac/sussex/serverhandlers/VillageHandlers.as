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
	public class VillageHandlers {
		public static const GET_HEARTH_DETAILS:String = "village.get_hearth_details";
		public static const GET_HEARTH_DETAILS_ERROR:String = "get_hearth_details_error";
		public static const VILLAGE_ERROR:String = "villageError";
		public static const HEARTH_LIST:String = "hearthslist";
		public static const GET_VILLAGE_DETAILS:String = "village.get_village_overview";
		public static const GET_VILLAGE_DETAILS_ERROR:String = "get_village_overview_error";
		public static const VILLAGE_DETAILS:String = "villageoverview";
		public static const GET_HEARTH_ASSETS:String = "village.get_hearth_assets";
		public static const GET_HEARTH_ASSETS_ERROR:String = "get_hearth_assets_error";
		public static const HEARTH_ASSETS:String = "hearthassets";
		
		public static const SUB_MENU_OVERVIEW:String = "Overview";
		public static const SUB_MENU_LIKE:String = "Like";
		public static const SUB_MENU_GIVE:String = "Give";
		public static const SUB_MENU_JOIN:String = "Proposals";
		public static const SUB_MENU_RESURRECT:String = "Resurrect";
		
		public static const GIVE_FORM:String = "GiveForm";
		public static const GIVE_HEARTH:String = "GiveHearth";
		public static const GIVE_ASSET:String = "GiveAsset";
		public static const GIVE_ASSET_ID:String = "GiveAssetId";
		public static const GIVE_ASSET_OPTIONS:String = "GiveAssetOption";
		public static const GIVE_ASSET_AMOUNT:String = "GiveAssetAmount";
		public static const GIVE_SUBMIT:String = "GiveSubmit";
		public static const GIVE_CANCEL:String = "GiveCancel";
		
		public static const GIVE_REQUEST:String = "village.give_asset";
		public static const GIVE_REQUEST_ERROR:String = "give_asset_error";
		public static const GIVE_REQUEST_SUCCESS:String = "give_asset_success";
	  	public static const GET_GIVE_ASSETS:String = "village.get_give_assets";
	  	public static const GET_GIVE_ASSETS_ERROR:String = "get_give_assets_error";
	  	public static const GET_GIVE_ASSETS_SUCCESS:String = "get_give_assets_success";
		
		public static const FETCH_HEARTHLESS:String = "village.fetch_hearthless";
		public static const HEARTHLESS_RECEIVED:String = "HearthlessPlayers";
		public static const FETCH_HEARTHLESS_ERROR:String = "fetch_hearthless_error";
		public static const HEARTHLESS_LIST:String = "HearthlessList";
		public static const HEARTHLESS_ARRAY:String = "Hearthless";
		
		public static const PROP_SUB_MENU_EXIT:String = "Exit";
		public static const PROP_SUB_MENU_PROPOSE:String = "Propose";
		public static const PROP_SUB_MENU_INCOMING:String = "Incoming";
		public static const PROP_SUB_MENU_OUTGOING:String = "Outgoing";
		
		public static const FETCH_VILLAGE_MEMBERS:String = "village.fetch_village_members";
		public static const FETCH_VILLAGE_MEMBERS_ERROR:String = "fetch_village_members_error";
		public static const VILLAGE_MEMBERS_RECEIVED:String = "VillageMembers";
		public static const VILLAGE_MEMBERS_HEARTHS:String = "Hearths";
		public static const VILLAGE_MEMBERS_PCS:String = "PlayerChars";
		public static const VILLAGE_MEMBERS_NPCS:String = "NPCs";
		
		public static const PROPOSAL_FORM:String = "ProposalForm";
		public static const PROPOSAL_FORM_PROPOSER:String = "Proposer";
		public static const PROPOSAL_FORM_PROPOSER_HEARTH:String = "ProposerHearth";
		public static const PROPOSAL_FORM_CURRENT_HEARTH:String = "CurrentHousehold:";
		public static const PROPOSAL_FORM_TARGET:String = "Target";
		public static const PROPOSAL_FORM_JOIN_HEARTH:String = "TargetHearth";
		public static const PROPOSAL_FORM_SUBMIT:String = "Submit";
		public static const PROPOSAL_FORM_CANCEL:String = "Cancel";
		
		public static const PROPOSAL_CURRENT_HEARTH_UPDATED:String = "ProposalCurrentHearthUpdated";
		
		public static const SUBMIT_PROPOSAL:String = "village.submit_proposal";
		
		public static const PROPOSAL_REQUEST:String = "village.request_proposals";
		public static const PROPOSAL_REQUEST_ERROR:String = "request_proposals_error";
		public static const PROPOSALS_RECEIVED:String = "ProposalList";
		public static const PROPOSALS_LIST:String = "Proposals";
		
		public static const PROPOSAL_UPDATED:String = "ProposalUpdate";
		public static const PROPOSAL:String = "Proposal";
		public static const UPDATE_PROPOSAL:String = "village.update_proposal";
		
		//Manager's constants
		public static const RES_FORM:String = "ResurrectionForm";
		public static const RES_FORM_HEARTH:String = "Hearth";
		public static const RES_FORM_DEAD:String = "Person";
		public static const RES_FORM_SUBMIT:String = "Resurrect";
		public static const RES_FORM_CANCEL:String = "Cancel";
		public static const RES_HEARTH_UPDATED:String = "ResFarmUpdated";
		public static const RES_FORM_SUBMITTED:String = "ResFormSubmitted";
		public static const RES_FORM_CANCELLED:String = "ResFormCancelled";
		
		public static const FETCH_DEAD:String = "village.fetch_dead";
		public static const FETCH_DEAD_ERROR:String = "fetch_dead_error";
		public static const DEAD_FETCHED:String = "dead_fetched";
		
		public static const RES_REQUEST:String = "village.resurrect";
		public static const RES_REQUEST_ID:String = "CharId";
		public static const RES_REQUEST_ERROR:String = "resurrect_error";
		public static const RES_SUCCESS:String = "resurrection_success";
  }
}
