package uk.ac.sussex.model.valueObjects {
  
  public class VillageOverview {
    private var name:String;
    private var numAdults:int;
    private var numKids:int;
    private var households:int;
    public function VillageOverview(){
      
    }
    public function getName():String {
      return name;
    }
    public function setName(newName:String):void {
      this.name = newName;
    }
    public function getNumAdults():int {
      return numAdults;
    }
    public function setNumAdults(numberOfAdults:int):void {
      this.numAdults = numberOfAdults;
    }
    public function getNumKids():int {
      return numKids;
    }
    public function setNumKids(numberOfKids:int):void {
      this.numKids = numberOfKids;
    }
    public function getHouseholds():int {
      return households;
    }
    public function setHouseholds(numberOfHouseholds:int):void {
      this.households = numberOfHouseholds;
    }
  }
}