package uk.ac.sussex.model.valueObjects.requestParams {
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import uk.ac.sussex.model.valueObjects.Proposal;
	import uk.ac.sussex.model.valueObjects.requestParams.DataParam;
	
	/**
	 * @author em97
	 */
	public class DataParamProposal extends DataParam {
		public static const PROPOSER_ID:String = "ProposerId";
		public static const PROPOSER_NAME:String = "ProposerName";
		public static const TARGET_ID:String = "TargetId";
		public static const TARGET_NAME:String = "TargetName";
		public static const PROPOSER_HEARTH_ID:String = "ProposerHearthId";
		public static const CURRENT_HEARTH_ID:String = "CurrentHearthId";
		public static const CURRENT_HEARTH_NAME:String = "CurrentHearthName";
		public static const TARGET_HEARTH_ID:String = "TargetHearthId";
		public static const TARGET_HEARTH_NAME:String = "TargetHearthName";
		public static const PROPOSAL_ID:String = "Id";
		public static const STATUS:String = "Status";
		public static const DELETED:String = "Deleted";
		
		public function DataParamProposal(paramName : String) {
			super(paramName);
		}
		override public function getParamValue() {
			var value:Proposal = this.paramValue as Proposal;
			return value;
		}
		override public function setParamValue(paramValue) {
			var value:Proposal = paramValue as Proposal;
			this.paramValue = value;
		}
		override public function addToServerParam(existingObject:SFSObject):SFSObject {
			var prop:Proposal = this.getParamValue() as Proposal;
			if(prop.getCurrentHearthId()!=0){
				existingObject.putInt(CURRENT_HEARTH_ID, prop.getCurrentHearthId());
				existingObject.putUtfString(CURRENT_HEARTH_NAME, prop.getCurrentHearthName());
			} else {
				existingObject.putNull(CURRENT_HEARTH_ID);
				existingObject.putNull(CURRENT_HEARTH_NAME);
			}
			existingObject.putInt(PROPOSAL_ID, prop.getId());
			if(prop.getProposerHearthId()!=0){
				existingObject.putInt(PROPOSER_HEARTH_ID, prop.getProposerHearthId());
			} else {
				existingObject.putNull(PROPOSER_HEARTH_ID);
			}
			existingObject.putInt(PROPOSER_ID, prop.getProposerId());
			existingObject.putUtfString(PROPOSER_NAME, prop.getProposerName());
			existingObject.putInt(TARGET_HEARTH_ID, prop.getTargetHearthId());
			existingObject.putUtfString(TARGET_HEARTH_NAME, prop.getTargetHearthName());
			existingObject.putInt(TARGET_ID, prop.getTargetId());
			existingObject.putUtfString(TARGET_NAME, prop.getTargetName());
			existingObject.putInt(STATUS, prop.getStatus());
			existingObject.putInt(DELETED, prop.getDeleted()?1:0);
			return existingObject;
		}
		override public function translateFromServerParam(existingObject:SFSObject):SFSObject {
			var pcObj:SFSObject = existingObject.getSFSObject(this.getParamName()) as SFSObject;
			var pc:Proposal = DataParamProposal.translateFromSFStoClass(pcObj);
			this.setParamValue(pc);
			return existingObject;
		}
		public static function translateFromSFStoClass(propObj:SFSObject):Proposal{
			var proposal:Proposal = new Proposal();
			
			proposal.setCurrentHearthId(propObj.getInt(CURRENT_HEARTH_ID));
			proposal.setCurrentHearthName(propObj.getUtfString(CURRENT_HEARTH_NAME));
			proposal.setId(propObj.getInt(PROPOSAL_ID));
			proposal.setProposerHearthId(propObj.getInt(PROPOSER_HEARTH_ID));
			proposal.setProposerId(propObj.getInt(PROPOSER_ID));
			proposal.setProposerName(propObj.getUtfString(PROPOSER_NAME));
			proposal.setTargetHearthId(propObj.getInt(DataParamProposal.TARGET_HEARTH_ID));
			proposal.setTargetHearthName(propObj.getUtfString(TARGET_HEARTH_NAME));
			proposal.setTargetId(propObj.getInt(TARGET_ID));
			proposal.setTargetName(propObj.getUtfString(TARGET_NAME));
			proposal.setStatus(propObj.getInt(STATUS));
			proposal.setDeleted((propObj.getInt(DELETED)==1));
			return proposal;
		}
		
	}
}
