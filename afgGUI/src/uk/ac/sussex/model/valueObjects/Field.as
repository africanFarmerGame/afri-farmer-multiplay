package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class Field {
		private var id:int;
		private var quality:int;
		private var fieldCrop:GameAsset;
		private var cropAge:int;
		private var cropHealth:int;
		private var name:String;
		private var cropPlanting:int;
		private var fertiliser:GameAsset;
		private var hazard:String;
		private var fullReduction:int;
		private var mitigatedReduction:int;
		private var hazardNotes:String;
		private var weeded:Boolean = false;
		
		public function getId():int {
			return this.id;
		}
		public function setId(newId:int):void {
			this.id = newId;
		}
		public function getQuality():int {
			return this.quality;
		}
		public function setQuality(newQual:int):void {
			this.quality = newQual;
		}
		public function getCrop():GameAsset {
			return fieldCrop;
		}
		public function setCrop(newCrop:GameAsset):void {
			this.fieldCrop = newCrop;
		}
		public function getName():String {
			return name;
		}
		public function setName(newName:String):void {
			this.name = newName;
		}
		public function getCropAge():int {
			return cropAge;
		}
		public function setCropAge(newCropAge:int):void{
			this.cropAge = newCropAge;
		}
		public function getCropHealth():int {
			return cropHealth;
		}
		public function setCropHealth(newCropHealth:int):void {
			this.cropHealth = newCropHealth;
		}
		public function getCropPlanting():int{
			return this.cropPlanting;
		}
		public function setCropPlanting(cropPlanting:int):void {
			this.cropPlanting = cropPlanting;
		}
		public function getFertiliser():GameAsset{
			return fertiliser;
		}
		public function setFertiliser(newFertiliser:GameAsset):void {
			this.fertiliser = newFertiliser;
		}
		public function getHazard():String {
		  return hazard;
		}
		public function setHazard(newHazard:String):void {
		  this.hazard = newHazard;
		}
		public function getFullReduction():int {
		  return fullReduction;
		}
		public function setFullReduction(newReduction:int):void {
		  this.fullReduction = newReduction;
		}
		public function getMitigatedReduction():int {
		  return mitigatedReduction;
		}
		public function setMitigatedReduction(newReduction:int):void {
		  this.mitigatedReduction = newReduction;
		}
		public function getHazardNotes():String {
		  return hazardNotes;
		}
		public function setHazardNotes(newNotes:String):void {
		  this.hazardNotes = newNotes;
		}
		public function getWeeded():Boolean {
			return weeded;
		}
		public function setWeeded(weeded:Boolean):void {
			this.weeded = weeded;
		}
	}
}
