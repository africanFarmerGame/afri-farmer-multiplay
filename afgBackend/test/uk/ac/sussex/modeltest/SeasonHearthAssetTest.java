package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import org.junit.Test;

import uk.ac.sussex.model.Asset;
import uk.ac.sussex.model.AssetFactory;
import uk.ac.sussex.model.Hearth;
import uk.ac.sussex.model.HearthFactory;
import uk.ac.sussex.model.SeasonDetail;
import uk.ac.sussex.model.SeasonDetailFactory;
import uk.ac.sussex.model.SeasonHearthAsset;

public class SeasonHearthAssetTest {

	@Test
	public void testSave() {
		SeasonHearthAsset sha = new SeasonHearthAsset();
		try {
			sha.save();
			fail("Unexpected success saving.");
		} catch (Exception e) {
			e.printStackTrace();
			String message = e.getMessage();
			assertTrue(message.contains("SeasonHearthAsset|Amount|Null||"));
			assertTrue(message.contains("SeasonHearthAsset|Season|Null||"));
			assertTrue(message.contains("SeasonHearthAsset|Hearth|Null||"));
			assertTrue(message.contains("SeasonHearthAsset|Asset|Null||"));
		}
		SeasonDetail sd = fetchSeasonDetail(5);
		Hearth hearth = fetchHearth(78); 
		Asset cash = fetchAsset(8);
		sha.setAmount(3.5);
		sha.setAsset(cash);
		sha.setHearth(hearth);
		sha.setSeason(sd);
		try {
			sha.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't save.");
		}
		assertNotNull(sha.getId());
	}
	private SeasonDetail fetchSeasonDetail(Integer id) {
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		SeasonDetail sd = null;
		try {
			sd = sdf.fetchSeasonDetail(id);
		} catch (Exception e){
			e.printStackTrace();
			fail("Problem fetching seasondetail " + id);
		}
		return sd;
	}
	private Hearth fetchHearth(Integer hearthId){
		HearthFactory hf = new HearthFactory();
		Hearth hearth = null;
		try {
			hearth = hf.fetchHearth(hearthId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unexpected problem fetching hearth " + hearthId);
		}
		return hearth;
	}
	private Asset fetchAsset(Integer assetId) {
		AssetFactory af = new AssetFactory();
		Asset asset = null;
		try {
			asset = af.fetchAsset(assetId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Problem getting asset " + assetId);
		}
		return asset;
	}
}
