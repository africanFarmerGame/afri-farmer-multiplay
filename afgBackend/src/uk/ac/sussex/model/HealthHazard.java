package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;

public class HealthHazard extends BaseObject {
	private Integer id;
	private String name;
	private String dietLevel;
	private Integer hospital; //This is the integer probability (e.g. 10 = 10% or 0.1) of the hazard causing hospitalisation.
	private Integer death; //This is the integer probability of the hazard causing death.
	private Double medicineCost;
	/**
	 * @return the id
	 */
	public Integer getId() {
		return id;
	}
	/**
	 * @param id the id to set
	 */
	public void setId(Integer id) {
		this.id = id;
	}
	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}
	/**
	 * @param name the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}
	/**
	 * @return the dietLevel
	 */
	public String getDietLevel() {
		return dietLevel;
	}
	/**
	 * @param dietLevel the dietLevel to set
	 */
	public void setDietLevel(String dietLevel) {
		this.dietLevel = dietLevel;
	}
	/**
	 * @return the hospital
	 */
	public Integer getHospital() {
		return hospital;
	}
	/**
	 * @param hospital the hospital to set
	 */
	public void setHospital(Integer hospital) {
		this.hospital = hospital;
	}
	/**
	 * @return the death
	 */
	public Integer getDeath() {
		return death;
	}
	/**
	 * @param death the death to set
	 */
	public void setDeath(Integer death) {
		this.death = death;
	}
	/**
	 * @return the medicineCost
	 */
	public Double getMedicineCost() {
		return medicineCost;
	}
	/**
	 * @param medicineCost the medicineCost to set
	 */
	public void setMedicineCost(Double medicineCost) {
		this.medicineCost = medicineCost;
	}
}
