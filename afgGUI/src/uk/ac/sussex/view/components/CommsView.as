package uk.ac.sussex.view.components {
	import uk.ac.sussex.model.valueObjects.Message;
	import uk.ac.sussex.model.valueObjects.CallHistoryItem;
	import uk.ac.sussex.model.valueObjects.TextMessage;
	/*
	CommsView handles the communications section of the game. It calls DirectoryMgr
	to create the directly listings for talk and phone contact. TickerMgr creates the
	moving ticker display at the bottom of the screen.
	 */
	 
	import flash.display.*;
	import flash.filters.*;
	import flash.events.*;
	import flash.text.*;  
//	import flash.utils.Timer;
	
	public class CommsView extends Sprite {

		private var talkBtn:TalkBtn = new TalkBtn();
		private var smsBtn:SmsBtn = new SmsBtn();
		private var phoneBtn:PhoneBtn = new PhoneBtn();
		private var mailBtn:MailBtn = new MailBtn();
		private var sendBtn:SendBtn = new SendBtn();
		private var msgDisplay:ScrollingList;
		private var commsBtnGlow:GlowFilter = new GlowFilter();
		private var unreadSMScounter:UnreadCountIcon;
		private var unreadMessageCounter:UnreadCountIcon;
		
		private var playerInput:TextField = new TextField();
		private var selectedFunction:String = TALK;
		
		//private static const YOU:String = "You";
		private static const TOP_OFFSET:uint = 10;
		private static const BORDER_COLOURS:uint = 0xCDCDCD;
		private static const SEND_BUTTON_WIDTH:uint = 100;
		//private static const SEND_BUTTON_HEIGHT:uint = 50;
		
		//These are the custom events
		public static const TALK_SELECTED:String = "talkSelected";
		public static const PHONE_SELECTED:String = "phoneSelected";
		public static const SMS_SELECTED:String = "smsSelected";
		public static const MAIL_SELECTED:String = "mailSelected";
		public static const SEND_MESSAGE:String = "sendMessage";
		public static const SMS_MESSAGE_SELECTED:String = "smsMessageSelected";
		public static const MAIL_MESSAGE_SELECTED:String = "mailMessageSelected";
		
		//These are the possible functions
		public static const TALK:String = "talk";
		public static const SMS:String = "sms";
		public static const MAIL:String = "mail";
		public static const PHONE:String = "phone";
		
		public function CommsView() {
			this.graphics.lineStyle(1, BORDER_COLOURS);
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(960, 0);
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0,0, 960, 240);
			this.graphics.endFill();
			setupBtns();
			setupFilters ();
			setupTxtFields();
			addListeners();
			displayBtns();
			displayCostTxt();
			
			talkBtn.filters = [commsBtnGlow]; // initially set to "talk" function
		}
		public function getSelectedFunction():String {
			return this.selectedFunction;
		}
		public function clearPlayerInput():void {
			this.playerInput.text = "";
		}
		public function getPlayerInput():String {
		 	return playerInput.text;
		}
		public function updateMessageText(messageText:String, author:String):void{
			var msgItem:MsgListItem = new MsgListItem();
			msgItem.setText(messageText, author);
			
			this.msgDisplay.addItem(msgItem);
			this.msgDisplay.resetToBottom();
		}
		public function displayTextMessages(messages:Array):void {
			msgDisplay.clearList();
			for each (var tm:TextMessage in messages){
				if(!tm.getDeleted()){
					var tmListItem:TextMessageListItem = new TextMessageListItem(tm);
					msgDisplay.addItem(tmListItem);
				}
			}
			this.msgDisplay.resetToBottom();
		}
		public function displayMessages(messages:Array):void {
			msgDisplay.clearList();
			for each (var tm:Message in messages){
				if(!tm.getDeleted()){
					var tmListItem:MessageListItem = new MessageListItem(tm);
					msgDisplay.addItem(tmListItem);
				}
			}
			this.msgDisplay.resetToBottom();
		}
		public function displayCallHistory(callHistoryList:Array):void {
			msgDisplay.clearList();
			for each(var callHistory:CallHistoryItem in callHistoryList) {
				var callHistoryListItem:CallHistoryListItem = new CallHistoryListItem(callHistory);
				msgDisplay.addItem(callHistoryListItem);
			}
			this.msgDisplay.resetToBottom();
		}
		public function getSelectedMessage():String {
			return msgDisplay.getCurrentValue();
		}
		public function displayUnreadSMSCount(unreadCount:uint):void {
			unreadSMScounter.setUnread(unreadCount);
			unreadSMScounter.visible = (unreadCount > 0);
		}
		public function displayUnreadMessageCount(unreadCount:uint):void {
			unreadMessageCounter.setUnread(unreadCount);
			unreadMessageCounter.visible = (unreadCount > 0);
		}
		public function flashPhoneIcon():void {
			phoneBtn.setFlashing(true);
		}
		public function stopFlashingPhoneIcon():void {
			phoneBtn.setFlashing(false);
		}
		public function beginPhoneCall():void {
			talkBtn.removeEventListener(MouseEvent.CLICK, talkBtnHandler);
			smsBtn.removeEventListener(MouseEvent.CLICK, smsBtnHandler);
			mailBtn.removeEventListener(MouseEvent.CLICK, mailBtnHandler);
			
			talkBtn.enabled = false;
			smsBtn.enabled = false;
			mailBtn.enabled = false;
			
			this.selectPhoneBtn();
		}
		public function endPhoneCall():void {
			talkBtn.addEventListener(MouseEvent.CLICK, talkBtnHandler);
			smsBtn.addEventListener(MouseEvent.CLICK, smsBtnHandler);
			mailBtn.addEventListener(MouseEvent.CLICK, mailBtnHandler);
			
			talkBtn.enabled = true;
			smsBtn.enabled = true;
			mailBtn.enabled = true;
			//On the off chance this is before the other person has answered.
			this.stopFlashingPhoneIcon();
			
			selectPhoneBtn();
			this.dispatchEvent(new Event(CommsView.PHONE_SELECTED));
		}
		/** 
		 * Positions and scales the buttons. 
		 */
		private function setupBtns():void {
			
			var scale:Number = 0.24;
			var baseX:int = 588;
			//var baseY:int = 19;
			var gap:int = 13;
			
			talkBtn.scaleX = talkBtn.scaleY = scale;
			talkBtn.x = baseX;
			talkBtn.y = TOP_OFFSET;
			
			phoneBtn.scaleX = phoneBtn.scaleY = scale;
			phoneBtn.x = baseX + gap + phoneBtn.width;
			phoneBtn.y = talkBtn.y;
			
			smsBtn.scaleX = smsBtn.scaleY = scale;
			smsBtn.x = baseX;
			smsBtn.y = talkBtn.y + gap + talkBtn.height;
			unreadSMScounter = new UnreadCountIcon();
			unreadSMScounter.setUnread(0);
			unreadSMScounter.x = smsBtn.x + smsBtn.width;
			unreadSMScounter.y = smsBtn.y;
			
			mailBtn.scaleX = mailBtn.scaleY = scale;
			mailBtn.x = baseX + gap + mailBtn.width;
			mailBtn.y = talkBtn.y + gap + talkBtn.height;
			unreadMessageCounter = new UnreadCountIcon();
			unreadMessageCounter.setUnread(0);
			unreadMessageCounter.x = mailBtn.x + mailBtn.width;
			unreadMessageCounter.y = mailBtn.y;
		}
		private function setupTxtFields():void {
			
			this.msgDisplay = new ScrollingList(550, 151);
			this.msgDisplay.x = 12;
			this.msgDisplay.y = TOP_OFFSET;
			this.msgDisplay.setBorderColour(0xCDCDCD);
			this.msgDisplay.setListItemsSelectable(false);
			msgDisplay.showBackgroundFilter(false);
			this.addChild(msgDisplay);
			
			var sendBtnScale:Number = SEND_BUTTON_WIDTH/sendBtn.width;
			sendBtn.scaleX = sendBtn.scaleY = sendBtnScale;
			
			
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = "Calibri";
			txtFormat.size = 15;
			txtFormat.bold = false;
			txtFormat.align = TextFormatAlign.LEFT;
			txtFormat.leftMargin = 6;
			playerInput.defaultTextFormat = txtFormat;
			playerInput.type = TextFieldType.INPUT;
			playerInput.height = 21;
			playerInput.width = 550;
			playerInput.y = 4;
			
			var textBackground:MovieClip = new MovieClip();
			textBackground.graphics.lineStyle(1, BORDER_COLOURS);
			textBackground.graphics.moveTo(0, 0);
			textBackground.graphics.lineTo(550, 0);
			textBackground.graphics.lineTo(550, sendBtn.height);
			textBackground.graphics.lineTo(0, sendBtn.height);
			textBackground.graphics.lineTo(0,0);
			textBackground.addChild(playerInput);
			textBackground.x = 12;
			textBackground.y = msgDisplay.y + msgDisplay.height + TOP_OFFSET - 4;
			this.addChild(textBackground);
			
			sendBtn.x = 584;
			sendBtn.y = textBackground.y;
		}
		private function displayCostTxt ():void {	
			var costTxt:TextField = new TextField();
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = "Calibri";
			txtFormat.size = 20;
			costTxt.defaultTextFormat = txtFormat;	
			costTxt.textColor = 0xBBBBBB;
			costTxt.autoSize = TextFieldAutoSize.LEFT;
			costTxt.x = 590;
			costTxt.y = 125;
			costTxt.border= false;
			costTxt.text = "Cost";
			addChild(costTxt);
		}
		private function setupFilters ():void {
			commsBtnGlow.color = 0xFF9407;
			commsBtnGlow.alpha = 1;
			commsBtnGlow.blurX = 4;
			commsBtnGlow.blurY = 4;
			commsBtnGlow.strength = 5;
			commsBtnGlow.quality = 15;
		}
		private function addListeners():void {		
			talkBtn.addEventListener(MouseEvent.CLICK, talkBtnHandler);
			phoneBtn.addEventListener(MouseEvent.CLICK, phoneBtnHandler);
			smsBtn.addEventListener(MouseEvent.CLICK, smsBtnHandler);
			mailBtn.addEventListener(MouseEvent.CLICK, mailBtnHandler);
			sendBtn.addEventListener(MouseEvent.CLICK, sendBtnHandler);
		}
		private function displayBtns ():void {
			addChild(talkBtn);
			addChild(phoneBtn);
			addChild(smsBtn);
			addChild(mailBtn);
			addChild(unreadSMScounter);
			addChild(unreadMessageCounter);
			addChild(sendBtn);
		}		
		private function talkBtnHandler (event:MouseEvent):void {
			if(selectedFunction !=TALK){
				selectTalkBtn();
			}
			this.dispatchEvent(new Event(CommsView.TALK_SELECTED));
		}
		private function selectTalkBtn():void {
			selectedFunction = TALK;
			msgDisplay.clearList();
			msgDisplay.setListItemsSelectable(false);
			msgDisplay.removeEventListener(ScrollingList.ITEM_SELECTED, itemSelected);
			playerInput.text = "";
			talkBtn.filters = [commsBtnGlow];
			mailBtn.filters = [];
			phoneBtn.filters = [];
			smsBtn.filters = [];
		}
		private function phoneBtnHandler (event:MouseEvent):void {
			if(selectedFunction!=PHONE){
				this.selectPhoneBtn();
			}
			this.dispatchEvent(new Event(CommsView.PHONE_SELECTED));
		}
		private function selectPhoneBtn():void {
			selectedFunction = PHONE;
			msgDisplay.clearList();
			msgDisplay.setListItemsSelectable(false);
			msgDisplay.removeEventListener(ScrollingList.ITEM_SELECTED, itemSelected);
			playerInput.text = "";
			talkBtn.filters = [];
			mailBtn.filters = [];
			phoneBtn.filters = [commsBtnGlow];
			smsBtn.filters = [];
		}
		private function smsBtnHandler (event:MouseEvent):void {
			selectedFunction = SMS;
			msgDisplay.clearList();
			msgDisplay.setListItemsSelectable(true);
			msgDisplay.addEventListener(ScrollingList.ITEM_SELECTED, itemSelected);
			playerInput.text = "";
			talkBtn.filters = [];
			mailBtn.filters = [];
			phoneBtn.filters = [];
			smsBtn.filters = [commsBtnGlow];
			this.dispatchEvent(new Event(CommsView.SMS_SELECTED));
		}
		private function mailBtnHandler (event:MouseEvent):void {
			selectedFunction = MAIL;
			msgDisplay.clearList();
			msgDisplay.setListItemsSelectable(true);
			msgDisplay.addEventListener(ScrollingList.ITEM_SELECTED, itemSelected);			
			playerInput.text = "";
			/**var str:String = "Today @ 12:17pm, message from Dogo Sibale:\nAbasi, ru going 2mkt 2day? I need 1b fert.";
			var str1:String = "Today @ 2:15pm, message from Makini Nyondo:\n";
			str1 = str1.concat("Don't forget school vouchrs");
			this.updateMessageText(str, "Whatever");
			this.updateMessageText(str1, "Whatever");*/
			talkBtn.filters = [];
			mailBtn.filters = [commsBtnGlow];
			phoneBtn.filters = [];
			smsBtn.filters = [];
			this.dispatchEvent(new Event(CommsView.MAIL_SELECTED));
		}
		private function itemSelected(e:Event):void {
			switch(selectedFunction){
				case SMS:
					dispatchEvent(new Event(SMS_MESSAGE_SELECTED));
					break;
				case MAIL:
					dispatchEvent(new Event(MAIL_MESSAGE_SELECTED));
					break;
				default:
					//Shouldn't get here. 
					trace("CommsView sez: we've got somewhere we shouldn't have.");
			}
		}
		private function sendBtnHandler (event:MouseEvent):void {
			//It doesn't matter which function is selected, all is dealt with in CommsViewMediator.
			dispatchEvent(new Event(CommsView.SEND_MESSAGE));
			
		}
	}
}
