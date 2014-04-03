package uk.ac.sussex.model.seasons;

public class Weather {
	private String id;
	private String name;
	//private Set<WeatherCropReduction> cropReductions;
	public Weather(String newId, String name){
		this.id = newId;
		this.name = name;
	}
	public String getId(){
		return id;
	}
	public String getName(){
		return name;
	}
}
