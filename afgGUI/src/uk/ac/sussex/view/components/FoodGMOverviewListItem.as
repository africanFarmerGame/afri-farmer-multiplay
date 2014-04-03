package uk.ac.sussex.view.components {
	import uk.ac.sussex.model.valueObjects.GMHouseholdData;
	import uk.ac.sussex.model.valueObjects.Hearth;
	import uk.ac.sussex.view.components.ListItem;

	/**
	 * @author em97
	 */
	public class FoodGMOverviewListItem extends ListItem {
		private var household:GameTextField;
		private var occupants:GameTextField;
		private var adiet:GameTextField;
		private var bdiet:GameTextField;
		private var cdiet:GameTextField;
		private var xdiet:GameTextField;
		private var enough:GameTextField;
		
		private static const GAP_SIZE:Number = 2;
		private static const ITEM_Y_POS:uint = 0;
		private static const ITEM_HEIGHT:uint = 25;
		
		private static const HOUSEHOLD_WIDTH:Number = 100;
		private static const NUMERIC_WIDTH:Number = 75;
		private static const INITIAL_X:Number = 8;
		
		public function FoodGMOverviewListItem() {
			super();
			setup();
			this.mouseChildren = false;
		}
		public function setDetails(hearth:Hearth, householdData:GMHouseholdData) :void {
			this.setItemID(hearth.getId().toString());
			household.text = hearth.getHearthName();
			occupants.text = (hearth.getNumAdults() + hearth.getNumChildren()).toString();
			adiet.text = householdData.getADiets().toString();
			bdiet.text = householdData.getBDiets().toString();
			cdiet.text = householdData.getCDiets().toString();
			xdiet.text = householdData.getXDiets().toString();
			if(householdData.getEnoughFood()){
				enough.text = "Yes";
			} else {
				enough.text = "No";
			}
		}
		private function setup():void{
			household = new GameTextField;
			household.readonly = true;
			household.width = HOUSEHOLD_WIDTH;
			household.height = ITEM_HEIGHT;
			household.x = INITIAL_X;
			household.y = ITEM_Y_POS;
			this.addChild(household);
			
			occupants = new GameTextField();
			occupants.readonly = true;
			occupants.width = NUMERIC_WIDTH;
			occupants.height = ITEM_HEIGHT;
			occupants.y = ITEM_Y_POS;
			occupants.x = household.x + household.width + GAP_SIZE;
			this.addChild(occupants);
			
			adiet = new GameTextField();
			adiet.readonly = true;
			adiet.width = NUMERIC_WIDTH;
			adiet.height = ITEM_HEIGHT;
			adiet.y = ITEM_Y_POS;
			adiet.x = occupants.x + occupants.width + GAP_SIZE;
			this.addChild(adiet);
			
			bdiet = new GameTextField();
			bdiet.readonly = true;
			bdiet.width = NUMERIC_WIDTH;
			bdiet.height = ITEM_HEIGHT;
			bdiet.y = ITEM_Y_POS;
			bdiet.x = adiet.x + adiet.width + GAP_SIZE;
			this.addChild(bdiet);
			
			cdiet = new GameTextField();
			cdiet.readonly = true;
			cdiet.width = NUMERIC_WIDTH;
			cdiet.height = ITEM_HEIGHT;
			cdiet.y = ITEM_Y_POS;
			cdiet.x = bdiet.x + bdiet.width + GAP_SIZE;
			this.addChild(cdiet);
			
			xdiet = new GameTextField();
			xdiet.readonly = true;
			xdiet.width = NUMERIC_WIDTH;
			xdiet.height = ITEM_HEIGHT;
			xdiet.y = ITEM_Y_POS;
			xdiet.x = cdiet.x + cdiet.width + GAP_SIZE;
			this.addChild(xdiet);
			
			enough = new GameTextField();
			enough.readonly = true;
			enough.width = NUMERIC_WIDTH;
			enough.height = ITEM_HEIGHT;
			enough.y = ITEM_Y_POS;
			enough.x = xdiet.x + xdiet.width + GAP_SIZE;
			this.addChild(enough);
		}
		public static function getColumnHeaders():Array {
			var headers:Array = new Array();
			
			var widthWithBorders:Number = NUMERIC_WIDTH + 2;
			
			headers.push(new Array("Household", HOUSEHOLD_WIDTH, INITIAL_X));
			headers.push(new Array("Occupants", widthWithBorders, INITIAL_X + HOUSEHOLD_WIDTH + GAP_SIZE));
			headers.push(new Array("A Diet", widthWithBorders, INITIAL_X + HOUSEHOLD_WIDTH + 2*GAP_SIZE + widthWithBorders));
			headers.push(new Array("B Diet", widthWithBorders, INITIAL_X + HOUSEHOLD_WIDTH + 3*GAP_SIZE + 2*widthWithBorders));
			headers.push(new Array("C Diet", widthWithBorders, INITIAL_X + HOUSEHOLD_WIDTH + 4*GAP_SIZE + 3*widthWithBorders));
			headers.push(new Array("X Diet", widthWithBorders, INITIAL_X + HOUSEHOLD_WIDTH + 5*GAP_SIZE + 4*widthWithBorders));
			headers.push(new Array("Enough?", widthWithBorders, INITIAL_X + HOUSEHOLD_WIDTH + 6*GAP_SIZE + 5*widthWithBorders));
			
			return headers;
		}
	}
}
