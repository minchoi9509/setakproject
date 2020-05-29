package com.spring.mapper;

import java.util.HashMap;
import java.util.List;

import com.spring.setak.WashingVO;

public interface Admin_WashMapper {
	List<Object> getWashList();
	int updateWash(WashingVO params);
	int deleteWash(int wash);
	List<Object> washSearch(HashMap<String, Object> map);
}
