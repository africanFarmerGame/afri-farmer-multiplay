package uk.ac.sussex.model.valueObjects {
	/**
	 * @author em97
	 */
	public class GameAsset {
		private var id:int;
		private var name:String;
		private var measurement:String;
		private var edible:Boolean;
		private var type:String;
		private var subtype:String;
		private var notes:String;
		
		public static const TYPE_FERTILISER:String = "FERTILISER";
		public static const TYPE_CROP:String = "CROP";
		public static const TYPE_FOOD:String = "FOOD";
		public static const TYPE_HERBICIDE:String = "HERBICIDE";
		public static const TYPE_INSECTICIDE:String = "INSECTICIDE";
		public static const TYPE_CASH:String = "CASH";
		public static const SUBTYPE_ORGANIC:String = "ORGANIC";
		public static const SUBTYPE_INORGANIC:String = "INORGANIC";
		public static const SUBTYPE_MAIZE:String = "MAIZE";
		
		public function GameAsset(){	
		}
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
		public function getMeasurement():String {
			return measurement;
		}
		public function setMeasurement(newMeasurement:String):void{
			this.measurement = newMeasurement;
		}
		public function getEdible():Boolean {
			return edible;
		}
		public function setEdible(newEdible:Boolean):void {
			edible = newEdible;
		}
		public function getType():String {
			return type;
		}
		public function setType(newType:String):void {
			this.type = newType;
		}
		public function getSubtype():String {
			return subtype;
		}
		public function setSubtype(newSubtype:String):void {
			this.subtype = newSubtype;
		}
		public function getNotes():String {
			return notes;
		}
		public function setNotes(newNotes:String):void{
			this.notes = newNotes;
		}
	}
}
