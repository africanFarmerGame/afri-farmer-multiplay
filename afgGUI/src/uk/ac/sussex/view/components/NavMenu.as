package uk.ac.sussex.view.components {

	/*
	NavMenu creates the navigation menu that switches between game views.
	It also displays red, amber or green buttons depending on the 'viewStatus' setting.
	 */
	 
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class NavMenu extends Sprite {

		private var homeBtn:HouseholdNavMC;
		private var farmBtn:FarmNavMC;
		private var villageBtn:VillageNavMC;
		private var marketBtn:MarketNavMC;
		private var bankBtn:BankNavMC;
		//private var infoBtn:InfoBtn;
		//private var helpBtn:HelpBtn = new HelpBtn();
		private var banker:Boolean;
		private var currentlySelected:String;
		public static const HOME_BUTTON:String = "home";
		public static const HOME_BUTTON_PRESSED:String = "HomeButtonPressed";
		public static const FARM_BUTTON:String = "farm";
		public static const FARM_BUTTON_PRESSED:String = "FarmButtonPressed"; 
		public static const VILLAGE_BUTTON:String = "village";
		public static const VILLAGE_BUTTON_PRESSED:String = "VillageButtonPressed";
		public static const MARKET_BUTTON:String = "market";
		public static const MARKET_BUTTON_PRESSED:String = "MarketButtonPressed";
		public static const BANK_BUTTON:String = "bank";
		public static const BANK_BUTTON_PRESSED:String = "BankButtonPressed";
		public static const HELP_BUTTON_PRESSED:String = "HelpButtonPressed";
		public static const BUTTON_STATE_GREEN:String = "Green";
		public static const BUTTON_STATE_AMBER:String = "Amber";
		public static const BUTTON_STATE_RED:String = "Red";
		public static const BUTTON_UNSELECTED:String = "Unsel";
		
		private static const BUTTON_GAP:Number = 7;
		private static const BUTTON_WIDTH:Number = 41;
		private static const BUTTON_HEIGHT:Number = 41;
		private static const BUTTON_Y:uint = 100;
		private static const BUTTON_START_X:uint = 7;
		
		public function NavMenu(isBanker:Boolean = false) {
			this.banker = isBanker;
			//setupFilter();
			setupBtns();
			addlisteners();
			displayBtns();
		}
		public function highlightButton (selectedBtnName:String):void {
			if(currentlySelected!=null){
				var currentButton:MovieClip = this.getButtonFromName(currentlySelected);
				var newState:String = currentButton.currentFrameLabel + BUTTON_UNSELECTED;
				this.setBtnVisibility(currentlySelected, newState);
				//disableButton(currentlySelected, false);
			}
			currentlySelected = selectedBtnName;
			var newButton:MovieClip = this.getButtonFromName(selectedBtnName);
			var buttonState:String = newButton.currentFrameLabel.replace(BUTTON_UNSELECTED, "");
			this.setBtnVisibility(selectedBtnName, buttonState);
			//disableButton(currentlySelected, true);
		}
		public function clearButtonHighlights():void {
			if(!banker){
				homeBtn.filters = [];
				farmBtn.filters = [];
			}
			villageBtn.filters = [];
			marketBtn.filters = [];
			bankBtn.filters = [];
			//infoBtn.filters = [];
		}
		/**
		 * This should be accessed from the NavMenuMediator and pass in one of the static button names
		 * and one of the static button states declared in this class.
		 * @param buttonName should be e.g. HOME_BUTTON, FARM_BUTTON etc. 
		 * @param buttonState shoudl be e.g. BUTTON_STATE_GREEN, BUTTON_STATE_RED etc.  
		 */
		public function setButtonState(buttonName:String, buttonState:String):void{
			trace("NavMenu sez: um, hello?");
			this.setBtnVisibility(buttonName, buttonState);
		}
		public function disableButton(buttonName:String, disabled:Boolean):void {
			var button:MovieClip = this.getButtonFromName(buttonName);
			button.enabled = !disabled;
			if(disabled){
				removeButtonListeners(buttonName);
			} else {
				addButtonListeners(buttonName);
			}
		}
		private function setupBtns():void {
			var position:uint = 0;
			if(!banker){
				homeBtn = new HouseholdNavMC();
				positionButton(homeBtn, position);
				position ++;
				addChild(homeBtn);
				farmBtn = new FarmNavMC();
				positionButton(farmBtn, position);
				position ++;
				addChild(farmBtn);
			}
			villageBtn = new VillageNavMC();
			positionButton(villageBtn, position);
			position ++;
			addChild(villageBtn);
			
			marketBtn = new MarketNavMC;
			positionButton(marketBtn, position);
			position ++;
			addChild(marketBtn);
			
			bankBtn = new BankNavMC;
			positionButton(bankBtn, position);
			position ++;
			addChild(bankBtn);
			
			//positionButton(helpBtn,position);
			//position ++;
			//addChild(helpBtn);
		/*	//TODO: Make this less obscure?!
			infoBtn = new InfoBtn();
			infoBtn.gotoAndStop(BUTTON_STATE_GREEN + BUTTON_UNSELECTED);
			positionButton(infoBtn,9);
			addChild(infoBtn);*/
		}
		private function positionButton(button:DisplayObject, position:uint):void{
			button.width = BUTTON_WIDTH;
			button.height = BUTTON_HEIGHT;
			
			button.x = BUTTON_START_X + position*(BUTTON_GAP + button.width);
			button.y = BUTTON_Y;
		}
		private function addlisteners():void {
			homeBtn.addEventListener(MouseEvent.CLICK, homeBtnHandler);
			farmBtn.addEventListener(MouseEvent.CLICK, farmBtnHandler);
			villageBtn.addEventListener(MouseEvent.CLICK, villageBtnHandler);
			marketBtn.addEventListener(MouseEvent.CLICK, marketBtnHandler);
			bankBtn.addEventListener(MouseEvent.CLICK, bankBtnHandler);
			//helpBtn.addEventListener(MouseEvent.CLICK, helpBtnHandler);
			//infoBtn.addEventListener(MouseEvent.CLICK, infoBtnHandler);
		}
		private function removeButtonListeners(buttonName:String):void {
			switch(buttonName){
				case HOME_BUTTON:
					homeBtn.removeEventListener(MouseEvent.CLICK, homeBtnHandler);
					break;
				case FARM_BUTTON:
					farmBtn.removeEventListener(MouseEvent.CLICK, farmBtnHandler);
					break;
				case VILLAGE_BUTTON:
					villageBtn.removeEventListener(MouseEvent.CLICK, villageBtnHandler);
					break;
				case MARKET_BUTTON:
					marketBtn.removeEventListener(MouseEvent.CLICK, marketBtnHandler);
					break;
				case BANK_BUTTON:
					bankBtn.removeEventListener(MouseEvent.CLICK, bankBtnHandler);
					break;
				default:
				trace("NavMenu sez: I have nothing to do with this state");
					//Nothing to do. 	
			}
		}
		private function addButtonListeners(buttonName:String):void {
			switch(buttonName){
				case HOME_BUTTON:
					homeBtn.addEventListener(MouseEvent.CLICK, homeBtnHandler);
					break;
				case FARM_BUTTON:
					farmBtn.addEventListener(MouseEvent.CLICK, farmBtnHandler);
					break;
				case VILLAGE_BUTTON:
					villageBtn.addEventListener(MouseEvent.CLICK, villageBtnHandler);
					break;
				case MARKET_BUTTON:
					marketBtn.addEventListener(MouseEvent.CLICK, marketBtnHandler);
					break;
				case BANK_BUTTON:
					bankBtn.addEventListener(MouseEvent.CLICK, bankBtnHandler);
					break;
				default:
				trace("NavMenu sez: I have nothing to do with this state");
					//Nothing to do. 	
			}
		}
		private function homeBtnHandler (event:MouseEvent):void {
			trace("NavMenu sez: We'll be heading for home");
			dispatchEvent(new Event(HOME_BUTTON_PRESSED));
		}
		private function farmBtnHandler (event:MouseEvent):void {
			trace("NavMenu sez: We'll be off to the farm");
			dispatchEvent(new Event(FARM_BUTTON_PRESSED));
		}
		private function villageBtnHandler (event:MouseEvent):void {
			trace("NavMenu sez: Time to head for the village");
			dispatchEvent(new Event(VILLAGE_BUTTON_PRESSED));
		}					
		private function marketBtnHandler (event:MouseEvent):void {
			trace("NavMenu sez: Let's head for the market");
			dispatchEvent(new Event(MARKET_BUTTON_PRESSED));
		}	
		private function bankBtnHandler (event:MouseEvent):void {
			trace("NavMenu sez: Best get to the bank");
			dispatchEvent(new Event(BANK_BUTTON_PRESSED));
		}
		/**private function helpBtnHandler (event:MouseEvent):void {
			trace("NavMenu sez: I need help!");
			dispatchEvent(new Event(HELP_BUTTON_PRESSED));
		}*/
		/*private function infoBtnHandler (event:MouseEvent):void {
			trace("NavMenu sez: More info please?");
			dispatchEvent(new Event(INFO_BUTTON_PRESSED));
		}*/
		private function displayBtns ():void {
			if(!banker){
				this.setBtnVisibility(HOME_BUTTON, BUTTON_STATE_GREEN);
				this.setBtnVisibility(FARM_BUTTON, BUTTON_STATE_AMBER);
			}
			this.setBtnVisibility(VILLAGE_BUTTON, BUTTON_STATE_RED);
			this.setBtnVisibility(MARKET_BUTTON, BUTTON_STATE_GREEN);
			this.setBtnVisibility(BANK_BUTTON, BUTTON_STATE_AMBER);
		}	
		private function setBtnVisibility(buttonName:String, viewStatus:String):void{
			var btn:MovieClip = this.getButtonFromName(buttonName);
			
			if(this.currentlySelected != buttonName){
				viewStatus += BUTTON_UNSELECTED;
			}
			trace("NavMenu sez: I am setting the colour of " + buttonName + " to " + viewStatus);
			btn.gotoAndStop(viewStatus);
		}	
		private function getButtonFromName(buttonName:String):MovieClip{
			switch(buttonName){
				case HOME_BUTTON:
					return homeBtn;
				case FARM_BUTTON:
					return farmBtn;
				case VILLAGE_BUTTON:
					return villageBtn;
				case MARKET_BUTTON:
					return marketBtn;
				case BANK_BUTTON:
					return bankBtn;
				default:
					throw new Error("A bad button name was passed through.");
					//Nothing to do. 	
			}
		}
	}
}
