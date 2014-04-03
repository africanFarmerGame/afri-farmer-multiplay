package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;

public class FieldHistory extends BaseObject {
	private Integer id;
	private Field field;
	private Integer gameYear;
	private Integer plantingTime;
	private Asset crop;
	private Integer weeded;
	private Integer fertilised;
	private PlayerChar owner;
	private Hearth hearth;
	private Integer yield;
	private String fieldName;
	
	public static int WEEDED_YES = 1;
	public static int WEEDED_NO = 0;
	public static int FERTILISED_YES = 1;
	public static int FERTILISED_NO = 0;
	
	public FieldHistory() {
		super();
		this.addOptionalParam("Id");
		this.addOptionalParam("Crop");
		this.addOptionalParam("PlantingTime");
		this.addOptionalParam("Owner");
		this.addOptionalParam("Hearth");
		this.setFertilised(FERTILISED_NO);
		this.setWeeded(WEEDED_NO);
		this.setYield(0);
	}
	/**
	 * @param id the id to set
	 */
	public void setId(Integer id) {
		this.id = id;
	}
	/**
	 * @return the Id
	 */
	public Integer getId() {
		return id;
	}
	/**
	 * @param field the field to set
	 */
	public void setField(Field field) {
		this.field = field;
	}
	/**
	 * @return the field
	 */
	public Field getField() {
		return field;
	}
	/**
	 * @param gameYear the gameYear to set
	 */
	public void setGameYear(Integer gameYear) {
		this.gameYear = gameYear;
	}
	/**
	 * @return the gameYear
	 */
	public Integer getGameYear() {
		return gameYear;
	}
	/**
	 * @param plantingTime the plantingTime to set
	 */
	public void setPlantingTime(Integer plantingTime) {
		this.plantingTime = plantingTime;
	}
	/**
	 * @return the plantingTime
	 */
	public Integer getPlantingTime() {
		return plantingTime;
	}
	/**
	 * @param crop the crop to set
	 */
	public void setCrop(Asset crop) {
		this.crop = crop;
	}
	/**
	 * @return the crop
	 */
	public Asset getCrop() {
		return crop;
	}
	/**
	 * @param weeded the weeded to set
	 */
	public void setWeeded(Integer weeded) {
		this.weeded = weeded;
	}
	/**
	 * @return the weeded
	 */
	public Integer getWeeded() {
		return weeded;
	}
	/**
	 * @param fertilised the fertilised to set
	 */
	public void setFertilised(Integer fertilised) {
		this.fertilised = fertilised;
	}
	/**
	 * @return the fertilised
	 */
	public Integer getFertilised() {
		return fertilised;
	}
	/**
	 * @param owner the owner to set
	 */
	public void setOwner(PlayerChar owner) {
		this.owner = owner;
	}
	/**
	 * @return the owner
	 */
	public PlayerChar getOwner() {
		return owner;
	}
	/**
	 * @param hearth the hearth to set
	 */
	public void setHearth(Hearth hearth) {
		this.hearth = hearth;
	}
	/**
	 * @return the hearth
	 */
	public Hearth getHearth() {
		return hearth;
	}
	/**
	 * @param yield the yield to set
	 */
	public void setYield(Integer yield) {
		this.yield = yield;
	}
	/**
	 * @return the yield
	 */
	public Integer getYield() {
		return yield;
	}
	/**
	 * @param fieldName the fieldName to set
	 */
	public void setFieldName(String fieldName) {
		this.fieldName = fieldName;
	}
	/**
	 * @return the fieldName
	 */
	public String getFieldName() {
		return fieldName;
	}

}
