package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;

public class CropHazardEffect extends BaseObject {
	private Integer id;
	private CropHazard cropHazard;
	private Asset crop;
	private Integer planting;
	private Integer cropAge;
	private Integer reduction;
	private Integer mitigatedRed;
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getId() {
		return id;
	}
	public void setCropHazard(CropHazard cropHazard) {
		this.cropHazard = cropHazard;
	}
	public CropHazard getCropHazard() {
		return cropHazard;
	}
	public void setCrop(Asset crop) {
		this.crop = crop;
	}
	public Asset getCrop() {
		return crop;
	}
	public void setPlanting(Integer planting) {
		this.planting = planting;
	}
	public Integer getPlanting() {
		return planting;
	}
	public void setCropAge(Integer cropAge) {
		this.cropAge = cropAge;
	}
	public Integer getCropAge() {
		return cropAge;
	}
	public void setReduction(Integer reduction) {
		this.reduction = reduction;
	}
	public Integer getReduction() {
		return reduction;
	}
	public void setMitigatedRed(Integer mitigatedRed) {
		this.mitigatedRed = mitigatedRed;
	}
	public Integer getMitigatedRed() {
		return mitigatedRed;
	}
}
