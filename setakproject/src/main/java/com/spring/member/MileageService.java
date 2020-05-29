package com.spring.member;

import java.util.ArrayList;
import java.util.HashMap;

public interface MileageService {

	public int getSum(String member_id);
	public int useMileage(MileageVO mvo); 
	
	//기응
	public int totSum(String member_id);
	public int useSum(String member_id);
	public ArrayList<MileageVO> getMileagelist(HashMap<String, Object> map);
	public int getListCount(String member_id);
}
