﻿package uk.ac.sussex.serverhandlers {		public class BankHandlers {				public static const BANK_SUB_MENU_OVERVIEW:String = "Overview";		public static const BANK_SUB_MENU_FINES:String = "Bills";				public static const FINES_SUB_MENU_LIST:String = "List";		public static const FINES_SUB_MENU_PAY:String = "Pay Bill";		public static const FINES_SUB_MENU_EXIT:String = "Return";				public static const BANK_ERROR:String = "bankError";		public static const FINES_REQUEST:String = "bank.get_hearth_fines";		public static const FINES_REQUEST_ERROR:String = "get_hearth_fines_error";		public static const FINES_REQUEST_SUCCESS:String = "get_hearth_fines_success";				public static const FINES_PAY_FORM:String = "PayFinesForm";		public static const FINES_PAYEE:String = "FinePayee";		public static const FINES_ID:String = "FineId";		public static const FINES_RATE:String = "FineRate";		public static const FINES_DESCRIPTION:String = "FineDescription";		public static const FINES_FORM_SUBMIT:String = "SubmitFineForm";		public static const FINES_FORM_CANCEL:String = "CancelFineForm";				public static const FINES_PAY:String = "bank.pay_fine";		public static const FINES_PAY_ERROR:String = "pay_fine_error";		public static const FINES_PAY_SUCCESS:String = "pay_fine_success";				//GAME MANAGER CONSTANTS		public static const GM_SUB_MENU_OVERVIEW:String = "Overview";		public static const GM_SUB_MENU_FINES:String = "Bills";				public static const GM_FINES_SUB_MENU_LIST:String = "List";		public static const GM_FINES_SUB_MENU_EXIT:String = "Return";				public static const GM_FINES_FETCH_ALL:String = "bank.fetch_manager_fines";		public static const GM_FINES_ALL_FETCHED:String = "AllBills";		public static const GM_FINES_FETCH_ALL_ERROR:String = "fetch_manager_fines_error";				public static const GM_FETCH_BANK_OVERVIEW:String = "bank.fetch_manager_overview";		public static const GM_FETCH_BANK_ERROR:String = "fetch_manager_overview_error";		public static const GM_BANK_OVERVIEW_RECEIVED:String = "gm_manager_overview";		public static const GM_OVERVIEW_HEARTH_DETAILS:String = "HearthOverviewDetails";				public static const GM_HOUSEHOLD_ASSETS_UPDATED:String = "GMHouseholdBankAssetsUpdated";		public static const GM_HOUSEHOLD_UNPAID_BILLS_UPDATED:String = "GMUnpaidBillsUpdated";		public static const GM_HOUSEHOLD_BILL_UPDATED:String = "GMUpdatedBill";			}	}