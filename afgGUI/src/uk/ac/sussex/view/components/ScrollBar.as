/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.view.components {
	import flash.geom.Rectangle;
	import fl.events.ScrollEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class ScrollBar extends MovieClip {
		
		private var thumb:MovieClip;
		private var track:MovieClip;
		
		private var direction:int = ScrollBar.VERTICAL;
		private var myScrollPosition:Number = 0;
		private var thumbColour:uint;
		private var trackColour:uint;
		private var pageSize:Number;
		private var contentSize:Number;
		private var thumbVisible:Boolean;
		
		private static const DEFAULT_WIDTH:Number = 15;
		private static const DEFAULT_HEIGHT:Number = 30;
		
		public static const VERTICAL:int = 0;
		public static const HORIZONTAL:int = 1; 
		
		public function ScrollBar(thumbColour:uint, trackColour:uint) {
			track = new MovieClip();
			thumb = new MovieClip();
			this.thumbColour = thumbColour;
			this.trackColour = trackColour;
			this.addChild(track);
			this.addChild(thumb);
			drawTrack(DEFAULT_WIDTH, DEFAULT_HEIGHT);
			drawThumb(DEFAULT_WIDTH, DEFAULT_HEIGHT);
		}
		public function setScrollDirection(direction:int):void {
			this.direction = direction;
		}
		public function set scrollPosition(position:Number):void {
			var oldPos:Number = myScrollPosition;
			//position is in relation to the container content. 
			//So, bottom of the content is contentSize;
			//Position therefore is actually contentSize - pageSize
			myScrollPosition = Math.max(position - pageSize, 0);
			if(direction==VERTICAL){
				thumb.y = (track.height - thumb.height) * myScrollPosition / (contentSize-pageSize);
			} else {
				thumb.x = (track.width - thumb.width) * myScrollPosition / (contentSize-pageSize);
			}
			moveThumb(oldPos);
		}
		public function setScrollProperties(pageSize:Number, contentSize:Number):void {
			this.pageSize = pageSize;
			this.contentSize = Math.max(contentSize, pageSize);
			setThumbVisible((contentSize - pageSize)>0);
		}
		override public function set width(newwidth:Number):void {
			drawTrack(newwidth, height);
			drawThumb(newwidth, height);
		}
		override public function set height(newheight:Number):void {
			drawTrack(width, newheight);
			drawThumb(width, newheight);
		}
		private function drawThumb(mcWidth:Number, mcHeight:Number):void {
			if(thumbVisible){
				var thumbHeight:Number;
				var thumbWidth:Number;
				if(direction==VERTICAL){
					thumbHeight = mcHeight * 0.1;
					thumbWidth = mcWidth;
				} else {
					thumbWidth = mcWidth *0.1;
					thumbHeight = mcHeight;
				}
				thumb.graphics.clear();
				thumb.graphics.beginFill(thumbColour);
				thumb.graphics.drawRect(0, 0, thumbWidth, thumbHeight);
				//this.addChildAt(thumb, zPos);
				this.addChild(thumb);
			} else {
				if(thumb.parent!=null){
					thumb.parent.removeChild(thumb);
				}
			}
		}
		private function drawTrack(mcWidth:Number, mcHeight:Number):void {
			var zPos:uint = this.getChildIndex(track);
			track.graphics.clear();
			track.graphics.beginFill(trackColour);
			track.graphics.drawRect(0, 0, mcWidth, mcHeight);
			track.graphics.endFill();
			this.addChildAt(track, zPos);
		}
		private function jumpToPoint(e:MouseEvent):void {
			var oldPos:Number = myScrollPosition;
			var trackLength:Number ;
			if(direction==VERTICAL){
				//Get the local y pos. 
				trackLength = track.height - thumb.height;
				var yPos:Number = Math.min(e.localY, trackLength);
				myScrollPosition = (yPos/trackLength) * (contentSize-pageSize);
				thumb.y = yPos;
			} else {
				trackLength = track.width - thumb.width;
				var xPos: Number = Math.min(e.localX, track.width - thumb.width);;
				myScrollPosition = (xPos/trackLength) * (contentSize - pageSize);
				thumb.x = xPos;
			}
			
			moveThumb(oldPos);
		}
		private function followMouse(e:MouseEvent):void {
			var dragBounds:Rectangle;
			if(direction == VERTICAL){
				dragBounds = new Rectangle(this.thumb.x, 0, 0, this.track.height - this.thumb.height);	
			} else {
				dragBounds = new Rectangle(0, thumb.y, this.track.width - this.thumb.width, 0);
			}
			
			thumb.startDrag(false, dragBounds);
			
			this.addEventListener(Event.ENTER_FRAME, moved);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, stopFollowingMouse);
			
		}
		private function stopFollowingMouse(e:MouseEvent):void {
			thumb.stopDrag();
			this.removeEventListener(Event.ENTER_FRAME, moved);
		}
		private function moved(e:Event):void {
			var oldPos:Number = myScrollPosition;
			var trackLength:Number;
			if(direction==VERTICAL){
				trackLength = track.height - thumb.height;
				myScrollPosition = (thumb.y/trackLength) * (contentSize - pageSize);
			} else {
				trackLength = track.width - thumb.width;
				myScrollPosition = (thumb.x/trackLength) * (contentSize - pageSize);
			}
			moveThumb(oldPos);
		}
		private function moveThumb(oldPosition:Number):void {
			
			var delta:Number = myScrollPosition - oldPosition;
			
			this.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, delta, myScrollPosition));
		}
		private function setThumbVisible(visible:Boolean):void {
			this.thumbVisible = visible;
			drawThumb(track.width, track.height);
			if(visible){
				track.addEventListener(MouseEvent.CLICK, jumpToPoint);
				thumb.addEventListener(MouseEvent.MOUSE_DOWN, followMouse);
			} else {
				track.removeEventListener(MouseEvent.CLICK, jumpToPoint);
				thumb.removeEventListener(MouseEvent.MOUSE_DOWN, followMouse);
			}
		}
	}
}
