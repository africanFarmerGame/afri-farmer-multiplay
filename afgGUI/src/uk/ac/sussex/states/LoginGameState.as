﻿package uk.ac.sussex.states {		import uk.ac.sussex.view.GameLogoMediator;	import uk.ac.sussex.view.SplashMediator;	import uk.ac.sussex.view.FormMediator;	import uk.ac.sussex.model.FormProxy;	import uk.ac.sussex.model.IncomingDataProxy;	import org.puremvc.as3.multicore.interfaces.IFacade;	import uk.ac.sussex.general.ApplicationFacade;	import uk.ac.sussex.controller.*;	import flash.display.Sprite;	import uk.ac.sussex.view.CreateUserButtonMediator;		public class LoginGameState implements IGameState {		public static const NAME:String = "LoginGameState";				public static const ATTEMPT_LOGIN:String = "AttemptLogin";		public static const FOUND_PC_SUCCESS:String = "foundpc_success";		public static const FOUND_PC_ERROR:String = "FoundPCError";		public static const FORM_LOGIN:String = "FormLogin";		public static const FORM_FIELD_PASSWORD:String = "password";		public static const FORM_FIELD_USERNAME:String = "username";		private var facade:IFacade;				public function LoginGameState(facade:IFacade) {			// constructor code			this.facade = facade;		}				public function displayState():void {			//Register proxy			var foundPcIncoming:IncomingDataProxy = new IncomingDataProxy(FOUND_PC_SUCCESS, ApplicationFacade.GET_CHARACTER_DATA);			this.facade.registerProxy(foundPcIncoming);						var loginForm:FormProxy = new FormProxy(FORM_LOGIN);			loginForm.addTextField(FORM_FIELD_USERNAME, "Username: ", false, "a-zA-Z0-9", 50); //TODO add the validation on the username			loginForm.addHiddenTextField(FORM_FIELD_PASSWORD, "Password: "); //TODO add some validation on the password			loginForm.addButton("Login", ATTEMPT_LOGIN);			this.facade.registerProxy(loginForm);						//Register commands			this.facade.registerCommand(ATTEMPT_LOGIN, AttemptLoginCommand);			this.facade.registerCommand(ApplicationFacade.LOGIN_SUCCESSFUL, SuccessfulLoginCommand);			this.facade.registerCommand(ApplicationFacade.CREATE_USER_CLICKED, CreateUserStatePrepCommand);			this.facade.registerCommand(ApplicationFacade.GET_CHARACTER_DATA, EnterGameCommand);			//Register mediators			facade.registerMediator(new SplashMediator());						var createUBMediator:CreateUserButtonMediator = new CreateUserButtonMediator(new Sprite);			this.facade.registerMediator(createUBMediator);			this.facade.registerMediator(new GameLogoMediator());			var formMediator:FormMediator = new FormMediator(FORM_LOGIN, new Sprite());			this.facade.registerMediator(formMediator);						formMediator.addToMainScreen(237, 430);		}		public function cleanUpState():void {			//Remove proxies			this.facade.removeProxy(FORM_LOGIN);			this.facade.removeProxy(FOUND_PC_SUCCESS + IncomingDataProxy.NAME);			//Remove commands			this.facade.removeCommand(ATTEMPT_LOGIN);			this.facade.removeCommand(ApplicationFacade.LOGIN_SUCCESSFUL);			this.facade.removeCommand(ApplicationFacade.CREATE_USER_CLICKED);			this.facade.removeCommand(ApplicationFacade.GET_CHARACTER_DATA);			//Remove mediators			//this.facade.removeMediator(LoginPanelMediator.NAME);			this.facade.removeMediator(FORM_LOGIN);			this.facade.removeMediator(CreateUserButtonMediator.NAME);			this.facade.removeMediator(SplashMediator.NAME);			this.facade.removeMediator(GameLogoMediator.NAME);		}		public function getName():String {			return NAME;		}		public function refresh():void{					}	}	}