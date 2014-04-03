package uk.ac.sussex.view.components {
	import flash.filters.DropShadowFilter;
	import flash.events.*;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class Avatar extends MovieClip {
		protected var myAvatar:MovieClip;
		private var mouseOver:MouseoverTextField;
		private var selected:Boolean = false;
		private var dropShadowFilter:DropShadowFilter;
		private var avatarId:int;
		private var hospitalIcon:HospitalMC;
		private var showHospitalIcon:Boolean;
		
		protected static const AVATAR_LAYER:uint = 0;
		private static const HOSPITAL_ICON_WIDTH:Number = 30;
		private static const AVATAR_SCALE:Number = 0.23;
		
		public static const MAN:String = "AvatarMan";
		public static const WOMAN:String = "AvatarWoman";
		public static const BOY:String = "AvatarBoy";
		public static const GIRL:String = "AvatarGirl";
		public static const BABY:String = "AvatarBaby";
		
		/**
		 * @param avatarType - this should be one of the constants: MAN, WOMAN, BOY, GIRL, or BABY.
		 */
		public function Avatar(avatarType:String, avatarBodyType:uint) {
			this.displayHospitalIcon(true);
			this.setRole(avatarType, avatarBodyType);
			this.mouseOver = new MouseoverTextField();
			this.setupFilter();
		}
		public function setMouseoverText(newText:String):void {
			this.mouseOver.text = newText;
		}		
		public function getAvatarId():int {
		  return this.avatarId;
		}
		public function setAvatarId(newId:int):void {
		  this.avatarId = newId;
		}
		public function setAlive(alive:int):void {
		  if(alive==0){
		    myAvatar.alpha = 0.5;
		  } else {
		    myAvatar.alpha = 1;
		  }
		}
		public function set isSelected(selected:Boolean):void{
			if(selected){
				myAvatar.filters = [dropShadowFilter];
			} else {
				myAvatar.filters = [];
			}
			this.selected = selected;
		}
		public function get isSelected():Boolean {
		  return this.selected;
		}
		public function setIll(ill:Boolean):void {
			hospitalIcon.visible = ill;
		}
		public function destroy():void {
			if(mouseOver!=null){
				mouseOver.removeFromScreen();
			}
		}
		protected function addEventListeners():void{
			myAvatar.addEventListener(MouseEvent.MOUSE_OVER, avatarMouseOver);
			myAvatar.addEventListener(MouseEvent.MOUSE_OUT, avatarMouseOut);
		}
		protected function displayHospitalIcon(display:Boolean):void {
			showHospitalIcon = display;
			if(showHospitalIcon){
				this.setupHospitalIcon();
			} else {
				if(hospitalIcon.parent!=null){
					hospitalIcon.parent.removeChild(hospitalIcon);
				}
			}
		}
		private function setRole(avatarType:String, bodyType:uint):void {
			//this.removeChild(this.myAvatar);
			switch (avatarType) {
				case Avatar.MAN:
					this.itsAMan(bodyType);
					break;
				case Avatar.WOMAN:
					this.itsAWoman(bodyType);
					break;
				case Avatar.GIRL:
					this.itsAGirl(bodyType); 
					break;
				case Avatar.BOY:
					this.itsABoy(bodyType);
					break;
				case Avatar.BABY:
					this.itsABaby(bodyType);
					break;
				default:
					throw new Error("Unknown avatar type: " + avatarType);
			}
			myAvatar.scaleX = myAvatar.scaleY = AVATAR_SCALE;
			this.addEventListeners();
			this.addChildAt(myAvatar, AVATAR_LAYER);
			this.repositionHospitalIcon();
		}
		private function itsAWoman(avatarBodyType:uint):void {
			switch(avatarBodyType){
				case 1:
					myAvatar = new AvatarWoman1_mc();
					break;
				case 2:
					myAvatar = new AvatarWoman2_mc();
					break;
				case 3:
					myAvatar = new AvatarWoman3_mc();
					break;
				case 4: 
					myAvatar = new AvatarWoman4_mc();
					break;
				default:
					throw new Error("Unknown body type: " + avatarBodyType);
			}
		}
		private function itsABaby(avatarBodyType:uint):void {
			switch(avatarBodyType){
				case 1:
					myAvatar = new AvatarBaby1_mc();
					break;
				case 2:
					myAvatar = new AvatarBaby2_mc();
					break;
				case 3:
					myAvatar = new AvatarBaby3_mc();
					break;
				case 4: 
					myAvatar = new AvatarBaby4_mc();
					break;
				default:
					throw new Error("Unknown body type: " + avatarBodyType);
			}
		}
		
		private function itsAMan(avatarBodyType:uint):void {
			switch(avatarBodyType){
				case 1:
					myAvatar = new AvatarMan1_mc();
					break;
				case 2:
					myAvatar = new AvatarMan2_mc();
					break;
				case 3:
					myAvatar = new AvatarMan3_mc();
					break;
				case 4: 
					myAvatar = new AvatarMan4_mc();
					break;
				default:
					throw new Error("Unknown body type: " + avatarBodyType);
			}
		}
	
		private function itsABoy(avatarBodyType:uint):void {
			switch(avatarBodyType){
				case 1:
					myAvatar = new AvatarBoy1_mc();
					break;
				case 2:
					myAvatar = new AvatarBoy2_mc();
					break;
				case 3:
					myAvatar = new AvatarBoy3_mc();
					break;
				case 4: 
					myAvatar = new AvatarBoy4_mc();
					break;
				default:
					throw new Error("Unknown body type: " + avatarBodyType);
			}
		}
		private function itsAGirl(avatarBodyType:uint):void {
			switch(avatarBodyType){
				case 1:
					myAvatar = new AvatarGirl1_mc();
					break;
				case 2:
					myAvatar = new AvatarGirl2_mc();
					break;
				case 3:
					myAvatar = new AvatarGirl3_mc();
					break;
				case 4: 
					myAvatar = new AvatarGirl4_mc();
					break;
				default:
					throw new Error("Unknown body type: " + avatarBodyType);
			}
		}
		private function setupFilter():void {
			dropShadowFilter = new DropShadowFilter();
			dropShadowFilter.distance = 0;
			dropShadowFilter.angle = 0;
			dropShadowFilter.color = 0xFFFFFF;
			dropShadowFilter.alpha = 0.8;
			dropShadowFilter.blurX = 6;
			dropShadowFilter.blurY = 6;
			dropShadowFilter.strength = 3;
			dropShadowFilter.quality = 15;
			dropShadowFilter.inner = false;
			dropShadowFilter.knockout = false;
			dropShadowFilter.hideObject = false;
		}
		private function setupHospitalIcon():void {
			hospitalIcon = new HospitalMC();
			
			hospitalIcon.height = HOSPITAL_ICON_WIDTH * hospitalIcon.height / hospitalIcon.width;
			hospitalIcon.width = HOSPITAL_ICON_WIDTH;
			
			this.repositionHospitalIcon();
			
			this.addChild(hospitalIcon);
		}
		protected function repositionHospitalIcon():void {
			if(myAvatar!=null){
				hospitalIcon.x = (this.width-hospitalIcon.width)/2;
				hospitalIcon.y = 0-hospitalIcon.height;
			} else {
				hospitalIcon.x = 0;
				hospitalIcon.y = 0;	
			}
		}
		private function avatarMouseOver(e:MouseEvent):void {
			mouseOver.addToScreen(this, mouseX + 5, mouseY - mouseOver.height);
		}
		private function avatarMouseOut(e:MouseEvent):void {
			mouseOver.removeFromScreen();	
		}
	}
}
