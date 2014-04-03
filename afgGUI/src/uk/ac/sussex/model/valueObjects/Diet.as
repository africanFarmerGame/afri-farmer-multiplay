/**
This file is part of the African Farmer Game - Multiplayer version.

African Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.valueObjects {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * @author em97
	 */
	public class Diet extends EventDispatcher {
		private var id:int = -1;
		private var name:String;
		private var dietItems:Array;
		private var hearthId:int;
		private var dietTarget:int = 0;
		//This stuff is calculated on the fly, not downloaded from the database.
		private var dietaryRequirements:Array; 
		private var dietLevel:String; 
		private var totalCarbs:int;
		private var totalNutrients:int;
		private var totalProtein:int;
		private var totalCarbSources:int;
		private var totalProteinSources:int;
		private var totalNutrientSources:int;
		//These are calculated by an external command, triggered by the change in contents or target.
		private var carbLevel:String;
		private var nutrientLevel:String;
		private var proteinLevel:String;
		private var carbDelta:Number;
		private var nutrientDelta:Number;
		private var proteinDelta:Number;
		
		public static const DIET_TARGET_MALE:int = 0;
		public static const DIET_TARGET_FEMALE:int = 1;
		public static const DIET_TARGET_CHILD:int = 2;
		public static const DIET_TARGET_BABY:int = 3;
		
		public static const DIET_LEVEL_A:String = "A";
		public static const DIET_LEVEL_B:String = "B";
		public static const DIET_LEVEL_C:String = "C";
		public static const DIET_LEVEL_X:String = "X";
		
		public static const DIET_TARGET_CHANGED:String = "DietTargetChanged";
		public static const DIET_CONTENTS_CHANGED:String = "DietContentsChanged";
		
		public function getId():int {
			return id;
		}
		public function setId(newId:int):void {
			this.id = newId;
		}
		public function getName():String {
			return name;
		}
		public function setName(newName:String):void {
			this.name = newName;
		}
		public function getDietItems():Array {
			return this.dietItems;
		}
		public function setDietItems(newDietItems:Array):void {
			trace("Diet sez: Diet items were set to an array of length " + newDietItems.length);
			this.dietItems = newDietItems;
			this.updateNutrientLevels();
			this.computeLevelAndDeltas();
			dispatchEvent(new Event(DIET_CONTENTS_CHANGED));
		}
		public function getHearthId():int {
			return this.hearthId;
		}
		public function setHearthId(newHearthId:int) :void {
			this.hearthId = newHearthId;
		}
		public function getTarget():int {
			return dietTarget;
		}
		public function setTarget(newTarget:int):void {
			trace("Diet sez: Target was set to " + newTarget);
			dietTarget = newTarget;
			dispatchEvent(new Event(DIET_TARGET_CHANGED));
		}
		public function getCopy():Diet{
			var diet:Diet = new Diet();
			diet.setId(this.getId());
			diet.setTarget(this.getTarget());
			diet.setDietaryRequirements(dietaryRequirements);
			var dietItems:Array = new Array();
			for each (var di:DietItem in this.getDietItems()){
				var newDi:DietItem = di.getCopy();
				newDi.setDiet(diet);
				dietItems.push(newDi);
			}
			diet.setDietItems(dietItems);
			diet.setName(this.getName());
			diet.updateNutrientLevels();
			return diet;
		}
		//This stuff is calculated on the fly, not downloaded from the database.
		public function setDietaryRequirements(levelReqs:Array):void{
			this.dietaryRequirements = levelReqs; 
			this.computeLevelAndDeltas();
		}
		public function getDietLevel():String {
			return dietLevel;
		}
		public function setDietLevel(newDietLevel:String):void {
			this.dietLevel = newDietLevel;
		}
		public function updateNutrientLevels():void {
			totalCarbs = 0;
			totalNutrients = 0;
			totalProtein = 0;
			for each (var di:DietItem in this.dietItems){
				var foodAsset:GameAssetFood = di.getAsset();
				if(foodAsset != null){
					totalCarbs += (foodAsset.getCarbs())* di.getAmount();
					totalCarbSources += (foodAsset.getCarbs()>1?1:0);
					totalNutrients += (foodAsset.getNutrients()) * di.getAmount();
					totalNutrientSources += (foodAsset.getNutrients()>1?1:0);
					totalProtein += (foodAsset.getProtein()) * di.getAmount();
					totalProteinSources += (foodAsset.getProtein()>1?1:0);
				} else {
					trace("Diet sez: We have a problem - food Asset was null");
				}
			}
		}
		public function getTotalCarbs():int{
			return totalCarbs;
		}
		public function getTotalProtein():int{
			return totalProtein;
		}
		public function getTotalNutrients():int {
			return totalNutrients;
		}
		public function getTotalCarbSources():int {
			return totalCarbSources;
		}
		public function getTotalProteinSources():int {
			return totalProteinSources;
		}
		public function getTotalNutrientSources():int {
			return totalNutrientSources;
		}
		//These are calculated by an external command, triggered by the change in contents or target.
		public function getCarbLevel():String {
			return this.carbLevel;
		}
		public function getNutrientLevel():String{
			return this.nutrientLevel;
		}
		public function getProteinLevel():String {
			return this.proteinLevel;
		}
		public function getCarbDelta():Number {
			return carbDelta;
		}
		public function getProteinDelta():Number {
			return proteinDelta;
		}
		public function getNutrientDelta():Number {
			return nutrientDelta;
		}
		private function computeLevelAndDeltas():void{
			if(dietaryRequirements != null){
				var levelReqA:DietaryRequirement = dietaryRequirements[Diet.DIET_LEVEL_A];
				var levelReqB:DietaryRequirement = dietaryRequirements[Diet.DIET_LEVEL_B];
				var levelReqC:DietaryRequirement = dietaryRequirements[Diet.DIET_LEVEL_C];
				carbLevel = calculateLevel(totalCarbs, levelReqA.getCarbs(), levelReqB.getCarbs(), levelReqC.getCarbs());
				proteinLevel = calculateLevel(totalProtein, levelReqA.getProtein(), levelReqB.getProtein(), levelReqC.getProtein());
				nutrientLevel = calculateLevel(totalNutrients, levelReqA.getNutrients(), levelReqB.getNutrients(), levelReqC.getNutrients());
				carbDelta = calculateDelta(totalCarbs, carbLevel, levelReqA.getCarbs(), levelReqB.getCarbs(), levelReqC.getCarbs());
				proteinDelta = calculateDelta(totalProtein, proteinLevel, levelReqA.getProtein(), levelReqB.getProtein(), levelReqC.getProtein());
				nutrientDelta = calculateDelta(totalNutrients, nutrientLevel, levelReqA.getNutrients(), levelReqB.getNutrients(), levelReqC.getNutrients());
				calculateTotalLevel();
			} else {
				trace("Diet sez: we have not actually initialised the dietary requirements for this target yet.");
			}
		}
		private function calculateLevel(currentAmount:Number, reqALevel:Number, reqBLevel:Number, reqCLevel:Number):String {
			var currentLevel:String = Diet.DIET_LEVEL_X;
			if (currentAmount >= reqALevel) {
				currentLevel = Diet.DIET_LEVEL_A;					
			} else if (currentAmount >= reqBLevel) {
				currentLevel = Diet.DIET_LEVEL_B;
			} else if (currentAmount >= reqCLevel) {
				currentLevel = Diet.DIET_LEVEL_C;
			} 
			return currentLevel;
		}
		private function calculateDelta(currentAmount:Number, currentLevel:String, reqALevel:Number, reqBLevel:Number, reqCLevel:Number):Number{
			var delta:Number = 0;
			switch (currentLevel){
				case Diet.DIET_LEVEL_A:
					delta = (currentAmount - reqALevel)/reqALevel;
					break;
				case Diet.DIET_LEVEL_B:
					delta = (currentAmount - reqBLevel)/(reqALevel - reqBLevel);
					break;
				case Diet.DIET_LEVEL_C:
					delta = (currentAmount - reqCLevel)/(reqBLevel - reqCLevel);
					break;
				default:
					delta = currentAmount/reqCLevel;
					break;
			}
			return delta;
		}
		private function calculateTotalLevel():void{
			if (carbLevel == Diet.DIET_LEVEL_A && proteinLevel == Diet.DIET_LEVEL_A && nutrientLevel == Diet.DIET_LEVEL_A) {
				this.setDietLevel(Diet.DIET_LEVEL_A);
			} else if (carbLevel != Diet.DIET_LEVEL_X && carbLevel != Diet.DIET_LEVEL_C && proteinLevel != Diet.DIET_LEVEL_X && proteinLevel != Diet.DIET_LEVEL_C && nutrientLevel != Diet.DIET_LEVEL_X && nutrientLevel != Diet.DIET_LEVEL_C) {
				this.setDietLevel(Diet.DIET_LEVEL_B);
			} else if (carbLevel != Diet.DIET_LEVEL_X && proteinLevel != Diet.DIET_LEVEL_X && nutrientLevel != Diet.DIET_LEVEL_X) {
				this.setDietLevel(Diet.DIET_LEVEL_C);
			} else {
				this.setDietLevel(Diet.DIET_LEVEL_X);
			}
		}
		
		public static function translateDietTargetToText(dietTarget:int):String {
			switch (dietTarget){
				case DIET_TARGET_MALE:
					return "Adult male";
					break;
				case DIET_TARGET_FEMALE:
					return "Adult female";
					break;
				case DIET_TARGET_CHILD:
					return "Child";
					break;
				case DIET_TARGET_BABY:
					return "Baby";
					break;
			}
		}
	}
}
