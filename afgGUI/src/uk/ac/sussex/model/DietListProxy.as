package uk.ac.sussex.model {
	import uk.ac.sussex.model.valueObjects.DietItem;
	import flash.events.Event;
	import uk.ac.sussex.model.valueObjects.Diet;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	/**
	 * @author em97
	 */
	public class DietListProxy extends Proxy implements IProxy {
		public static const NAME:String = "DietListProxy";
		public static const CURRENT_DIET_CHANGED:String = "CurrentDietChanged";
		public static const CURRENT_DIET_UPDATED:String = "CurrentDietUpdated";
		public static const NEW_DIET_ADDED:String = "NewDietAdded";
		public static const NEW_DIETS_ADDED:String = "NewDietsAdded";
		public static const DIET_UPDATED:String = "DietUpdated";
		public static const DIET_DELETED:String = "DietDeleted";
		
		private var currentDiet:Diet;
		private var dietaryRequirementsProxy:DietaryRequirementsProxy;
		private var gameAssetListProxy:GameAssetListProxy;
		
		public function DietListProxy(dietaryRequirementsProxy:DietaryRequirementsProxy, gameAssetListProxy:GameAssetListProxy) {
			super(NAME, new Array());
			this.dietaryRequirementsProxy = dietaryRequirementsProxy;
			this.gameAssetListProxy = gameAssetListProxy;
		}
		public function saveDiet(newDiet:Diet) :void {
			//Sort out the diet assets
			for each (var dietItem:DietItem in newDiet.getDietItems()){
				dietItem.setAsset(gameAssetListProxy.getFoodAsset(dietItem.getAssetId()));
			}
			
			//Search for the diet in the list.
			var diet:Diet = null;
			for each (var listDiet:Diet in dietList){
				if(listDiet.getId() == newDiet.getId()){
					diet = listDiet;
					break;
				}
			}
			trace("DietlistProxy sez: We are saving a diet. ");
			if(diet==null){
				//This is a new diet, and should just be added. 
				dietList.push(newDiet);
				sendNotification(NEW_DIET_ADDED, newDiet);
			} else {
				diet.setName(newDiet.getName());
				diet.setTarget(newDiet.getTarget());
				diet.setDietItems(newDiet.getDietItems());
				sendNotification(DIET_UPDATED, diet);
			}
		}
		public function addDiets(diets:Array):void {
			trace("DietListProxy sez: we are adding new diets numbering " + diets.length);
			for each (var diet:Diet in diets){
				dietList.push (diet);
			}
			sendNotification(NEW_DIETS_ADDED, diets);
		}
		public function changeCurrentDiet(dietId:int):void{
			for each (var diet:Diet in dietList){
				if(diet.getId()==dietId){
					this.setCurrentDiet(diet.getCopy());
					break;
				}
			}
		}
		public function createNewDiet():void {
			var newDiet:Diet = new Diet();
			newDiet.setName("Diet " + dietList.length.toString());
			newDiet.setTarget(Diet.DIET_TARGET_MALE);
			newDiet.setDietLevel(Diet.DIET_LEVEL_X);
			this.setCurrentDiet(newDiet);
		}
		public function clearCurrentDiet():void {
			this.setCurrentDiet(null);
			sendNotification(CURRENT_DIET_CHANGED);
		}
		public function getCurrentDiet():Diet {
			return currentDiet;
		}
		public function deleteDiet (dietId:int):void {
			trace("DietListProxy sez: we are deleting a diet " + dietId);
			var newDietArray:Array = new Array();
			for each (var diet:Diet in dietList) {
				if(diet.getId() != dietId){
					newDietArray.push(diet);
				}
			}
			data = newDietArray;
			sendNotification(DIET_DELETED, dietId);
		}
		public function getDiets():Array {
			return dietList;
		}
		public function getNumberOfDiets():int {
			return dietList.length;
		}
		private function setCurrentDiet(newDiet:Diet):void {
			if(currentDiet != null){
				currentDiet.removeEventListener(Diet.DIET_CONTENTS_CHANGED, currentDietUpdated);
				//currentDiet.removeEventListener(Diet.DIET_TARGET_CHANGED, currentDietUpdated);
				currentDiet.removeEventListener(Diet.DIET_TARGET_CHANGED, updateDietaryRequirements);
			}
			currentDiet = newDiet;
			if(currentDiet!= null){
				trace("DietListProxy sez: We are about to update the bits of the diet we need to.");
				trace("DietListProxy sez: The dietaryRequirementsProxy is ok. " + (dietaryRequirementsProxy != null));
				var dReqs:Array = dietaryRequirementsProxy.getTargetRequirements(currentDiet.getTarget());
				trace("DietListProxy sez: dReqs is not null " + (dReqs!= null));
				currentDiet.updateNutrientLevels();
				currentDiet.setDietaryRequirements(dReqs);
				currentDiet.addEventListener(Diet.DIET_CONTENTS_CHANGED, currentDietUpdated);
				//currentDiet.addEventListener(Diet.DIET_TARGET_CHANGED, currentDietUpdated);
				currentDiet.addEventListener(Diet.DIET_TARGET_CHANGED, updateDietaryRequirements);
			}
			sendNotification(CURRENT_DIET_CHANGED);
		}
		private function currentDietUpdated(e:Event):void {
			sendNotification(CURRENT_DIET_UPDATED, currentDiet);
		}
		private function updateDietaryRequirements(e:Event):void {
			var dReqs:Array = dietaryRequirementsProxy.getTargetRequirements(currentDiet.getTarget());
			currentDiet.setDietaryRequirements(dReqs);
			sendNotification(CURRENT_DIET_UPDATED, currentDiet);
		}
		protected function get dietList():Array {
			return data as Array;
		}
	}
}
