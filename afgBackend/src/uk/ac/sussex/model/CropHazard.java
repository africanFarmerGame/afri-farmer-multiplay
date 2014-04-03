package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;

public class CropHazard extends BaseObject {
	private Integer id;
	private String name;
	private Integer probability;
	private String notes;
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getId() {
		return id;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getName() {
		return name;
	}
	public void setProbability(Integer probability) {
		this.probability = probability;
	}
	public Integer getProbability() {
		return probability;
	}
	public void setNotes(String notes) {
		this.notes = notes;
	}
	public String getNotes() {
		return notes;
	}
}
