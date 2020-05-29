package com.spring.mapper;

import java.util.HashMap;
import java.util.List;

import com.spring.setak.KeepVO;
import com.spring.setak.MendingVO;

public interface Admin_MendingMapper {
	List<Object> getMendingList();
	int updateMending(MendingVO params);
	int deleteMending(int mending);
	List<Object> mendingSearch(HashMap<String, Object> map);
	List<Object> mendingLoadImg(HashMap<String, Object> map);
	void deleteMendingImg(String repair_file);
	int MendingImg(HashMap<String, Object> map);
}
