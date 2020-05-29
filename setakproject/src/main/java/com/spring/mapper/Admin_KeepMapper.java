package com.spring.mapper;

import java.util.HashMap;
import java.util.List;

import com.spring.setak.KeepVO;

public interface Admin_KeepMapper {
	List<Object> getKeepList();
	int updateKeep(KeepVO params);
	int keepImg(HashMap<String, Object> map);
	void deleteImg(String keep_path);
	List<Object> loadImg(HashMap<String, Object> map);
	int deleteKeep(int keep);
	List<Object> keepSerach(HashMap<String, Object> map);
}
