package com.spring.admin_chart;

import java.util.HashMap;

public interface AdminChartService {

/*세탁, 수선, 보관 그래프*/	

	// 세탁건수-하루단위  
	public int wash_count(HashMap<String, Object> map);
	
	// 세탁건수-하루단위  
	public int repair_count(HashMap<String, Object> map);
	
	// 세탁건수-하루단위  
	public int keep_count(HashMap<String, Object> map);
		
	// 세탁건수-한달단위
	public	int wash_count_month(HashMap<String, Object> map);
	
	// 수선건수-한달단위
	public int repair_count_month(HashMap<String, Object> map);
		
	// 보관건수-한달단위
	public	int keep_count_month(HashMap<String, Object> map);	
	
/*수익 그래프*/
	//세탁, 수선, 보관 수익금액 
	public int profit_ssb(HashMap<String, Object> map);	
	
	//정기결제 수익금액 
	public int profit_sub(HashMap<String, Object> map);		
}
