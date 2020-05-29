package com.spring.mapper;

import java.util.ArrayList;
import java.util.HashMap;

import com.spring.member.MileageVO;

public interface MileageMapper {
	
	int getSum(String member_id); 
	int useMileage(MileageVO mvo); 
	

	//기응 
	int totSum(String member_id);
	int useSum(String member_id);
	ArrayList<MileageVO> getMileagelist(HashMap<String, Object> map);
	int getListCount(String member_id);
}
