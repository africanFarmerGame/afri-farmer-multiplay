package uk.ac.sussex.view.components {
	import flash.display.MovieClip;
	import flash.events.*;
	/**
	 * @author em97
	 */
	public class ListItem extends MovieClip {
		
		public static const LIST_ITEM_CLICKED:String = "Item clicked";
		
		private var itemID:String;
		
		public function ListItem() {
		  //Make this enabled by default:
		  this.enabled = true;
		}
		
		public function getItemID():String {
			return this.itemID;
		}
		public function setItemID(newItemID:String):void{
			this.itemID = newItemID;
		}
		public function destroy():void{
			
		}
		override public function set enabled(enabled:Boolean):void {
		  if(enabled){
		    this.addEventListener(MouseEvent.CLICK, onClick);
		  } else {
		    this.removeEventListener(MouseEvent.CLICK, onClick);
	    }
		}
		private function onClick(e:MouseEvent):void {
			this.dispatchEvent(new Event(LIST_ITEM_CLICKED, true));
		}
	}
}
