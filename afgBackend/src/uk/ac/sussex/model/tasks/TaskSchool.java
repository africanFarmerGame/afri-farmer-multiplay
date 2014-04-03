/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.tasks;

import java.util.HashSet;
import java.util.Set;

import uk.ac.sussex.model.Asset;
import uk.ac.sussex.model.AssetFactory;
import uk.ac.sussex.model.AssetOwner;
import uk.ac.sussex.model.AssetOwnerFactory;
import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.NPC;
import uk.ac.sussex.model.NPCFactory;
import uk.ac.sussex.utilities.Logger;

public class TaskSchool extends Task {
	public static String TASKTYPE =  "TASK_SCHOOL";
	public static String DISPLAYNAME = "Attend School";
	
	private AssetOwner vouchersOwner = null;
	
	public TaskSchool(){
		super();
		this.setTaskType(TASKTYPE);
		this.setAssetAmount(1);
	}
	@Override
	public String getDisplayName() {
		return DISPLAYNAME;
	}

	@Override
	public void execute() {
		//Just adds another session of school to the child's list. 
		Boolean actorAvailable = false;
		try {
			actorAvailable = this.confirmActorAvailability(this, null);
		} catch (Exception e1) {
			this.setStatus(ERROR);
			this.setNotes("There was a problem confirming the availability of the person you sent to school.");
			Logger.ErrorLog("TaskSchool.execute", "Problem confirming actor availability: " + e1.getMessage());
		}
		if(actorAvailable){
			//Check their age.
			NPCFactory npcf = new NPCFactory();
			NPC child = null;
			try {
				child = npcf.fetchNPC(this.getActor().getId());
			} catch (Exception e) {
				String message = "Unable to fetch child " + this.getActor().getId() + ": " + e.getMessage();
				Logger.ErrorLog("TaskSchool.execute", message);
			}
			if(child!=null){
				if(!child.isAdult()){
					Integer childSchool = child.getSchool();
					if(childSchool == null){
						childSchool=0;
					}
					int fullYear = childSchool%4;
					if(fullYear!=0 || enoughVouchers()){
						child.setSchool(childSchool+1);
						try {
							child.save();
							if(fullYear==0){
								decrementVouchers();
							}
							this.setStatus(COMPLETED);
							this.setNotes(child.getDisplayName() + " has attended school.");
						} catch (Exception e) {
							String message = "Unable to save records: " + e.getMessage();
							Logger.ErrorLog("TaskSchool.execute", message);
							this.setStatus(ERROR);
							this.setNotes("There was a backend problem executing this task. Sorry about that.");
						}
					} else {
						this.setStatus(ERROR);
						this.setNotes("You didn't own enough vouchers for this child to attend school.");
					}
				} else {
					this.setStatus(ERROR);
					this.setNotes("This person is really too old to go to school.");
				}
			} else {
				this.setStatus(ERROR);
				this.setNotes("There was a problem with the child.");
			}
		} else {
			this.setStatus(ERROR);
			this.setNotes("The child you tried to send to school was busy on other tasks.");
		}
		try {
			this.save();
		} catch (Exception e) {
			String errorMessage = "Problem saving task id " + this.getId() + ": " + e.getMessage();
			Logger.ErrorLog("TaskSchool.execute", errorMessage);
		}
	}

	@Override
	public Set<TaskOption> fetchPossibleLocations(Hearth household) {
		//The household is the only possible location for this one. 
		TaskOption to = new TaskOption();
		to.setName(household.getName());
		to.setValue(household.getId());
		to.setType(household.getType());
		Set<TaskOption> kids = this.fetchPossibleActors(household);
		if(kids == null || kids.size() < 1){
			to.setStatus(TaskOption.INVALID);
			to.setNotes("You don't have any children of the right age to go to school");
		} else {
			to.setStatus(TaskOption.VALID);
		}
		Set<TaskOption> locations = new HashSet<TaskOption>();
		locations.add(to);
		return locations;
	}

	@Override
	public Set<TaskOption> fetchPossibleActors(Hearth household) {
		Set<TaskOption> actors = this.fetchChildrenOptions(household);
		return actors;
	}

	@Override
	public Set<TaskOption> fetchPossibleAssets(Hearth household) {
		//Only school vouchers enable school attendance.
		TaskList tl = fetchHouseholdTasklist(household);
		
		AssetFactory af = new AssetFactory();
		Asset schoolVoucher = null;
		try {
			schoolVoucher = af.fetchAsset(13);
		} catch (Exception e2) {
			String message = "Problem getting school voucher for household " + household.getId().toString() + ": " + e2.getMessage();
			Logger.ErrorLog("TaskSchool.fetchPossibleAssets", message);
			return null;
		}
		TaskOption to = new TaskOption();
		to.setValue(schoolVoucher.getId());
		to.setName(schoolVoucher.getName());
		to.setType(schoolVoucher.getType());
		
		AssetOwnerFactory aof = new AssetOwnerFactory();
		AssetOwner schoolVoucherOwner = null;
		Integer pendingAmount;
		try {
			schoolVoucherOwner = aof.fetchSpecificAsset(household, schoolVoucher);
			pendingAmount = tl.countPendingAssetAmount(household, schoolVoucher);
			if(schoolVoucherOwner != null && schoolVoucherOwner.getAmount()>=(pendingAmount + 1)){
				to.setStatus(TaskOption.VALID);
			} else if (to.getStatus() == null) {
				to.setStatus(TaskOption.INVALID);
				to.setNotes("You don't own enough vouchers to send another child to school");
			}

		} catch (Exception e1) {
			to.setStatus(TaskOption.WARNING);
			to.setNotes("Problem checking the number of school vouchers you own.");
			String message = "Problem getting the school voucher ownership for household " + household.getId().toString() + ": " + e1.getMessage();
			Logger.ErrorLog("TaskSchool.fetchPossibleAssets", message);
		}
		Set<TaskOption> assets = new HashSet<TaskOption>();
		assets.add(to);
		return assets;
	}
	
	private Boolean enoughVouchers(){
		AssetOwnerFactory aof = new AssetOwnerFactory();
		
		try {
			vouchersOwner = aof.fetchSpecificAsset(getHousehold(), getAsset());
		} catch (Exception e) {
			String message = "Problem checking vouchers: " + e.getMessage();
			Logger.ErrorLog("TaskSchool.enoughVouchers", message);
		}
		if(vouchersOwner!=null && vouchersOwner.getAmount()>0){
			return true;
		} else {
			return false;
		}
	}
	private void decrementVouchers() throws Exception{
		if(vouchersOwner!=null){
			vouchersOwner.setAmount(vouchersOwner.getAmount() - this.getAssetAmount());
			vouchersOwner.save();
		}
	}
	
}
