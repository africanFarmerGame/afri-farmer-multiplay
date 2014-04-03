package uk.ac.sussex.handlertest;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.handlers.HomeMultiEnum;
import uk.ac.sussex.handlers.HomeMultiHandler;

import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.SFSExtension;

public class HomeMultiHandlerTest {

	@Test
	public void testGetMemberDetails() {
		fail("Not yet implemented");
		ISFSObject params = SFSObject.newInstance();
		params.putUtfString(SFSExtension.MULTIHANDLER_REQUEST_ID, HomeMultiEnum.GET_MEMBER_DETAILS.toString());
		params.putInt("hearthId", 1);
	
		
		@SuppressWarnings("unused")
		HomeMultiHandler hmh = new HomeMultiHandler();
		//hmh.handleClientRequest(user, params) ;
	}

}
