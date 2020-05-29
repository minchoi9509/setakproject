package com.spring.admin_chart;

import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.Admin_chart;

@Service
public class AdminChartServiceImpl implements AdminChartService {
	
	@Autowired
	private SqlSession sqlSession;

/*세탁, 수선, 보관 그래프*/

	// 세탁건수-하루단위
	@Override
	public int wash_count(HashMap<String, Object> map) {
		int cnt = 0;  
		try {
			Admin_chart mapper = sqlSession.getMapper(Admin_chart.class);
			cnt = mapper.wash_count(map);
		}catch(Exception e) {
			System.out.println("세탁건수 검색실패 " + e.getMessage());
		}
		
		return cnt; 
	}
	
	// 수선건수-하루단위
		@Override
		public int repair_count(HashMap<String, Object> map) {
			int cnt = 0;  
			try {
				Admin_chart mapper = sqlSession.getMapper(Admin_chart.class);
				cnt = mapper.repair_count(map);
			}catch(Exception e) {
				System.out.println("수선건수 검색실패 " + e.getMessage());
			}
			
			return cnt; 
		}
	
	// 보관건수-하루단위
	@Override
	public int keep_count(HashMap<String, Object> map) {
			int cnt = 0;  
			try {
				Admin_chart mapper = sqlSession.getMapper(Admin_chart.class);
				cnt = mapper.keep_count(map);
			}catch(Exception e) {
				System.out.println("보관건수 검색실패 " + e.getMessage());
			}
			
			return cnt; 
		}
	
	// 세탁건수-한달단위
		public	int wash_count_month(HashMap<String, Object> map) {
			int cnt = 0;  
			try {
				Admin_chart mapper = sqlSession.getMapper(Admin_chart.class);
				cnt = mapper.wash_count_month(map);
			}catch(Exception e) {
				System.out.println("세탁건수-한달단위 검색실패 " + e.getMessage());
			}
			
			return cnt; 
		}

		// 수선건수-한달단위
		public	int repair_count_month(HashMap<String, Object> map) {
			int cnt = 0;  
			try {
				Admin_chart mapper = sqlSession.getMapper(Admin_chart.class);
				cnt = mapper.repair_count_month(map);
			}catch(Exception e) {
				System.out.println("수선건수-한달단위 검색실패 " + e.getMessage());
			}
			
			return cnt; 
		}

		// 보관건수-한달단위
		public	int keep_count_month(HashMap<String, Object> map) {
			int cnt = 0;  
			try {
				Admin_chart mapper = sqlSession.getMapper(Admin_chart.class);
				cnt = mapper.keep_count_month(map);
			}catch(Exception e) {
				System.out.println("보관건수-한달단위 검색실패 " + e.getMessage());
			}
			
			return cnt; 
		}
		
/*수익 그래프*/
		//세탁, 수선, 보관 수익금액 
		public int profit_ssb(HashMap<String, Object> map) {
			Integer cnt = 0;  
			try {
				Admin_chart mapper = sqlSession.getMapper(Admin_chart.class);
				cnt = mapper.profit_ssb(map);
					if(cnt == null) {
						cnt = 0;
					}
			}catch(Exception e) {
				System.out.println("세,수,보 수익 금액 실패 " + e.getMessage());
			}
			
			return cnt; 
		}
		
		//정기결제 수익금액 
		public int profit_sub(HashMap<String, Object> map) {
			Integer cnt = 0;  
			try {
				Admin_chart mapper = sqlSession.getMapper(Admin_chart.class);
				cnt = mapper.profit_sub(map);
					if(cnt == null) {
						cnt = 0;
					}
			}catch(Exception e) {
				System.out.println("정기결제 수익 금액 실패 " + e.getMessage());
			}
			
			return cnt; 
		}
		
}
