package uk.ac.sussex.modeltest;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;

import uk.ac.sussex.model.*;

public class HazardFactoryTest {

	@Test
	public void testFetchCropHazards() {
		HazardFactory hf = new HazardFactory();
		List<CropHazard> cropHazards = null;
		try {
			cropHazards = hf.fetchCropHazards();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to retrieve crophazards");
		}
		assertNotNull(cropHazards);
		assertEquals(7, cropHazards.size());
	}
	@Test
	public void testFetchCropHazardEffect() {
		HazardFactory hf = new HazardFactory();
		Asset crop = fetchAsset(2);
		CropHazard armyWorms = null;
		CropHazard leafBlight = null;
		try{
			armyWorms = (CropHazard) hf.fetchSingleObject(1);
			leafBlight = (CropHazard) hf.fetchSingleObject(7);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Unable to get the hazards");
		}
		CropHazardEffect che1 = null;
		try {
			che1 = hf.fetchCropHazardEffect(armyWorms, crop, Field.EARLY_PLANTING, 1);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't fetch first effect");
		}
		assertNotNull(che1);
		
		CropHazardEffect che2 = null;
		try {
			che2 = hf.fetchCropHazardEffect(leafBlight, crop, Field.LATE_PLANTING, 2);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't fetch second effect");
		}
		assertNull(che2);
	}
	@Test
	public void testCreateFieldHazardHistory(){
		HazardFactory hf = new HazardFactory();
		Asset crop = fetchAsset(2);
		CropHazard armyWorms = null;
		CropHazardEffect armyWormsEffect = null;
		try {
			armyWorms = (CropHazard) hf.fetchSingleObject(1);
			armyWormsEffect = hf.fetchCropHazardEffect(armyWorms, crop, Field.EARLY_PLANTING, 1);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Could't get the hazard effect");
		}
		assertNotNull(armyWormsEffect);
		SeasonDetail currentSeason = new SeasonDetail();
		currentSeason.setId(2);
		Field field= new Field();
		field.setId(3);
		
		FieldHazardHistory fhh = new FieldHazardHistory();
		fhh.setCropHazardEffect(armyWormsEffect);
		fhh.setField(field);
		fhh.setMitigated(1);
		fhh.setSeasonDetail(currentSeason);
		try {
			fhh.save();
		} catch (Exception e) {
			e.printStackTrace();
			fail("couldn't save");
		}
	}
	@Test
	public void testFetchFieldHazard(){
		HazardFactory hf = new HazardFactory();
		Field field = fetchField(3);
		SeasonDetail seasonDetail = fetchSD(4);
		FieldHazardHistory fhh = null;
		try {
			fhh = hf.fetchCurrentFieldHazard(field, seasonDetail);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		assertNotNull(fhh);
		
	}
	@Test
	public void testFetchCropHazardEffectById(){
		HazardFactory hf = new HazardFactory();
		CropHazardEffect effect = null;
		try {
			effect = hf.fetchCropHazardEffect(1);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get it.");
		}
		assertNotNull(effect);
	}
	@Test
	public void testFetchCropHazard(){
		HazardFactory hf = new HazardFactory();
		CropHazard hazard = null;
		try {
			hazard = hf.fetchCropHazard(1);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Failed to fetch");
		}
		assertNotNull(hazard);
	}
	private Asset fetchAsset(Integer assetId){
		AssetFactory af = new AssetFactory();
		Asset asset = null;
		try {
			asset = af.fetchAsset(assetId);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get the asset");
		}
		return asset;
	}
	private Field fetchField(Integer fieldId){
		FieldFactory ff = new FieldFactory();
		Field field = null;
		try {
			field = ff.getFieldById(18);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get field");
		}
		return field;
	}
	private SeasonDetail fetchSD(Integer seasonid){
		SeasonDetailFactory sdf = new SeasonDetailFactory();
		SeasonDetail seasonDetail = null;
		try {
			seasonDetail = sdf.fetchSeasonDetail(seasonid);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Couldn't get seasondetail");
		}
		return seasonDetail;
	}
}
