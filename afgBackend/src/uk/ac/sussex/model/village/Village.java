/**
This file is part of the African Farmer Game - Multiplayer version.

AFGAfrican Farmer Game - Multiplayer version is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

AFG-African Farmer Game - Multiplayer version is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.	
**/

package uk.ac.sussex.model.village;

import java.util.Iterator;
import java.util.Set;

public abstract class Village {
	protected Set<VillageFamilies> villageFamilies;
	protected Set<VillageFarms> villageFarms;
	private int maxFamilies;
	private int minFamilies;
	
	/**
	 * The village can support a range of family numbers, but needs to know the max and min.
	 * @param minimumFamilies
	 * @param maximumFamilies
	 */
	public Village(int minimumFamilies, int maximumFamilies){
		this.setupFamilies();
		this.setupFarms();
		this.setMaxFamilies(maximumFamilies);
		this.setMinFamilies(minimumFamilies);
	}
	abstract public Integer calculateProportionMen(Integer totalParticipants);
	abstract protected void setupFamilies();
	abstract protected void setupFarms();
	
	public VillageFamilies getFamilies(int totalFamilies) {
		Boolean notFound = true;
		Iterator<VillageFamilies> iterator = villageFamilies.iterator();
		VillageFamilies families = null;
		while(notFound && iterator.hasNext()){
			families = iterator.next();
			notFound = (families.getTotalFamilies()!=totalFamilies); 
		}
		return families;
	}
	public VillageFarms getFarms(int totalFarms) {
		Boolean notFound = true;
		Iterator<VillageFarms> iterator = villageFarms.iterator();
		VillageFarms farms = null;
		while(notFound && iterator.hasNext()) {
			farms = iterator.next();
			notFound = (farms.getTotalFarms() != totalFarms);
		}
		return farms;
	}
	/**
	 * The maximum number of families that this village can support.
	 * @param maxFamilies
	 */
	private void setMaxFamilies(int maxFamilies) {
		this.maxFamilies = maxFamilies;
	}
	/**
	 * @return the maximum number of families that the village can support.
	 */
	public int getMaxFamilies() {
		return maxFamilies;
	}
	/**
	 * The minimum number of families that this village can support.
	 * @param minFamilies
	 */
	private void setMinFamilies(int minFamilies) {
		this.minFamilies = minFamilies;
	}
	/**
	 * @return the minimum number of families that this village can support.
	 */
	public int getMinFamilies() {
		return minFamilies;
	}
	/**
	 * This fetches the smallest farm available in the village for a given number of farms. 
	 * @param totalFarms
	 * @return
	 */
	public VillageFarm getSmallestFarm(int totalFarms) {
		VillageFarms farms = this.getFarms(totalFarms);
		return farms.fetchSmallestFarm();
	}
	/**
	 * This calculates the number of fields for sale or rent, which start the game owned by the 
	 * game manager. These are limited, as village land would be. Could be overridden to create a 
	 * different game type.
	 * @param totalFarms
	 * @return The number of extra fields for the game manager.
	 */
	public int calculateGMFields(int totalFarms) {
		return totalFarms*2; //Default extra fields are set to quite a low number per family. 
	}
}
