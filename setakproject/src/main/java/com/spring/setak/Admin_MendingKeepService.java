package com.spring.setak;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface Admin_MendingKeepService {
	List<Object> getWashList();
	int updateWash(WashingVO params);
	int deleteWash(int wash);
	List<Object> washSearch(HashMap<String, Object> map);
	
	List<Object> getMendingList();
	int updateMending(MendingVO params);
	int deleteMending(int mending);
	List<Object> mendingSearch(HashMap<String, Object> map);
	List<Object> mendingLoadImg(HashMap<String, Object> map);
	void deleteMendingImg(String repair_file);
	int MendingImg(HashMap<String, Object> map);
	
	List<Object> getKeepList();
	int updateKeep(KeepVO params);
	int keepImg(HashMap<String, Object> map);
	void deleteImg(String keep_path);
	List<Object> loadImg(HashMap<String, Object> map);
	int deleteKeep(int keep);
	List<Object> keepSerach(HashMap<String, Object> map);
}
