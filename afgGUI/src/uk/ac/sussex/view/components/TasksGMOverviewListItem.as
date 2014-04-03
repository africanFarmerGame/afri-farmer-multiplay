package uk.ac.sussex.view.components {
	import uk.ac.sussex.model.valueObjects.Hearth;
	import uk.ac.sussex.view.components.ListItem;

	/**
	 * @author em97
	 */
	public class TasksGMOverviewListItem extends ListItem {
		private var household:GameTextField;
		private var fields:GameTextField;
		private var occupants:GameTextField;
		private var seasonTasks:GameTextField;
		
		private static const GAP_SIZE:Number = 2;
		private static const ITEM_Y_POS:uint = 0;
		private static const ITEM_HEIGHT:uint = 25;
		
		private static const HOUSEHOLD_WIDTH:Number = 150;
		private static const NUMERIC_WIDTH:Number = 100;
		
		public function TasksGMOverviewListItem() {
			super();
			setup();
			this.mouseChildren = false;
		}
		public function setDetails(hearth:Hearth, pendingTasks:int) :void {
			this.setItemID(hearth.getId().toString());
			household.text = hearth.getHearthName();
			fields.text = hearth.getNumFields().toString();
			occupants.text = (hearth.getNumAdults() + hearth.getNumChildren()).toString();
			seasonTasks.text = pendingTasks.toString();
		}
		private function setup():void{
			household = new GameTextField;
			household.readonly = true;
			household.width = HOUSEHOLD_WIDTH;
			household.height = ITEM_HEIGHT;
			household.x = 10;
			household.y = ITEM_Y_POS;
			this.addChild(household);
			
			fields = new GameTextField();
			fields.readonly = true;
			fields.width = NUMERIC_WIDTH;
			fields.height = ITEM_HEIGHT;
			fields.y = ITEM_Y_POS;
			fields.x = household.x + household.width + GAP_SIZE;
			this.addChild(fields);
			
			occupants = new GameTextField();
			occupants.readonly = true;
			occupants.width = NUMERIC_WIDTH;
			occupants.height = ITEM_HEIGHT;
			occupants.y = ITEM_Y_POS;
			occupants.x = fields.x + fields.width + GAP_SIZE;
			this.addChild(occupants);
			
			seasonTasks = new GameTextField();
			seasonTasks.readonly = true;
			seasonTasks.width = NUMERIC_WIDTH;
			seasonTasks.height = ITEM_HEIGHT;
			seasonTasks.y = ITEM_Y_POS;
			seasonTasks.x = occupants.x + occupants.width + GAP_SIZE;
			this.addChild(seasonTasks);
		}
		public static function getColumnHeaders():Array {
			var headers:Array = new Array();
			
			headers.push(new Array("Household", HOUSEHOLD_WIDTH, 0));
			headers.push(new Array("Fields", NUMERIC_WIDTH, HOUSEHOLD_WIDTH + GAP_SIZE));
			headers.push(new Array("Occupants", NUMERIC_WIDTH, HOUSEHOLD_WIDTH + 2*GAP_SIZE + NUMERIC_WIDTH));
			headers.push(new Array("Tasks", NUMERIC_WIDTH, HOUSEHOLD_WIDTH + 3*GAP_SIZE + 2*NUMERIC_WIDTH));
			
			return headers;
		}
	}
}
