/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
