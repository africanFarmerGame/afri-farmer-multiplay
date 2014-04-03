package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;

public class FieldHazardHistory extends BaseObject {
	private Integer id;
	private Field field;
	private CropHazardEffect cropHazardEffect;
	private Integer mitigated;
	private SeasonDetail seasonDetail;
	
	public final static int MITIGATED = 1;
	
	public FieldHazardHistory(){
		this.addOptionalParam("Id");
	}
	
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getId() {
		return id;
	}
	public void setField(Field field) {
		this.field = field;
	}
	public Field getField() {
		return field;
	}
	public void setCropHazardEffect(CropHazardEffect cropHazardEffect) {
		this.cropHazardEffect = cropHazardEffect;
	}
	public CropHazardEffect getCropHazardEffect() {
		return cropHazardEffect;
	}
	public void setMitigated(Integer mitigated) {
		this.mitigated = mitigated;
	}
	public Integer getMitigated() {
		return mitigated;
	}
	public void setSeasonDetail(SeasonDetail seasonDetail) {
		this.seasonDetail = seasonDetail;
	}
	public SeasonDetail getSeasonDetail() {
		return seasonDetail;
	}
	
}
