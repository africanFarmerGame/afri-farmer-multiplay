/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

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
