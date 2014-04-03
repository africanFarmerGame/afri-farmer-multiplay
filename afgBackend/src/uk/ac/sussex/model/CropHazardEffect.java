/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
