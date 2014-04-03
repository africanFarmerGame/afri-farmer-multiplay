/**
Copyright 2014 Future Agricultures Consortium  This file is part of the African Farmer Game - Multiplayer version.AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model;

import uk.ac.sussex.model.base.BaseObject;

public class Proposal extends BaseObject {
	private Integer id;
	private PlayerChar proposer;
	private Hearth proposerHearth;
	private AllChars target;
	private Hearth currentHearth;
	private Hearth targetHearth;
	private Integer deleted;
	private Integer status;
	
	public static int PENDING = 0;
	public static int ACCEPTED = 1;
	public static int DECLINED = 2;
	public static int RETRACTED = 3;
	
	public Proposal() {
		super();
		this.addOptionalParam("Id");
		this.addOptionalParam("ProposerHearth");
		this.addOptionalParam("TargetHearth");
		this.addOptionalParam("CurrentHearth");
		this.setDeleted(0);
		this.setStatus(PENDING);
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getId() {
		return id;
	}

	public void setProposer(PlayerChar proposer) {
		this.proposer = proposer;
	}

	public PlayerChar getProposer() {
		return proposer;
	}

	public void setProposerHearth(Hearth proposerHearth) {
		this.proposerHearth = proposerHearth;
	}

	public Hearth getProposerHearth() {
		return proposerHearth;
	}

	public void setTarget(AllChars target) {
		this.target = target;
	}

	public AllChars getTarget() {
		return target;
	}

	public void setCurrentHearth(Hearth currentHearth) {
		this.currentHearth = currentHearth;
	}

	public Hearth getCurrentHearth() {
		return currentHearth;
	}

	public void setTargetHearth(Hearth targetHearth) {
		this.targetHearth = targetHearth;
	}

	public Hearth getTargetHearth() {
		return targetHearth;
	}

	public void setDeleted(int deleted) {
		this.deleted = deleted;
	}

	public int getDeleted() {
		return deleted;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public int getStatus() {
		return status;
	}
}
