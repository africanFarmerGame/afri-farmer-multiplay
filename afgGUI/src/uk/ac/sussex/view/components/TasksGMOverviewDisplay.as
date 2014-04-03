package uk.ac.sussex.view.components {
	import uk.ac.sussex.model.valueObjects.Hearth;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import flash.text.TextFormat;
	import flash.display.Shape;
	import flash.display.MovieClip;

	/**
	 * @author em97
	 */
	public class TasksGMOverviewDisplay extends MovieClip {
		private var scrollingList:ScrollingList;
		
		public function TasksGMOverviewDisplay() {
			setup();
		}
		public function clearTasks():void {
			scrollingList.clearList();
		}
		public function addTask(hearth:Hearth, pendingTasks:int):void {
			var taskItem:TasksGMOverviewListItem = new TasksGMOverviewListItem();
			taskItem.setDetails(hearth, pendingTasks);
			scrollingList.addItem(taskItem);
		}
		/**public function getSelectedFineId():String{
			var selectedId:String = scrollingList.getCurrentValue();
			return selectedId;
		}*/
		public function clearSelection():void {
			scrollingList.clearCurrentSelection();
		}
		private function setup():void {
			setupTitleBar();
			
			scrollingList = new ScrollingList(620, 270);
			scrollingList.x = 0;
			scrollingList.y = 25; 
			scrollingList.setListItemsSelectable(false);
			scrollingList.showBackgroundFilter(false);
			scrollingList.setBorderColour(0x09063A);
			
			this.addChild(scrollingList);
		}
		private function setupTitleBar():void {
			var titleBar:Shape = new Shape();
			titleBar.graphics.lineStyle(1,0x000000);
			titleBar.graphics.beginFill(0xF49160); 
			titleBar.graphics.drawRect(0,0,607,25);
			titleBar.graphics.endFill();	
			this.addChild(titleBar);
			var tFormat:TextFormat = new TextFormat();
			tFormat.font = "Calibri";
			tFormat.size = 17;
			tFormat.bold = false;
			tFormat.align = TextFormatAlign.CENTER;	
			
			var headers:Array = TasksGMOverviewListItem.getColumnHeaders();
			
			for each (var header:Array in headers){
				var text:TextField = new TextField();
				text.defaultTextFormat = tFormat;
				text.textColor = 0x000000;
				text.background = false;
				text.border = false;
				text.borderColor = 0x000000;
				text.selectable = false;
				text.x = header.pop();
				text.width = header.pop();
				text.text = header.pop();
				text.height = 25;
				text.y = 0;
				this.addChild(text);
			}
		}
	}
}
