/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
