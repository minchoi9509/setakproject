package com.spring.setak;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.MendingKeepMapper;
import com.spring.order.KeepCartVO;
import com.spring.order.MendingCartVO;
import com.spring.order.WashingCartVO;

@Service
public class MendingKeepServiceImpl implements MendingKeepService{
	
	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public int insertMending(MendingVO mending) {
		MendingKeepMapper mendingkeepmapper = sqlSession.getMapper(MendingKeepMapper.class);
		int result = mendingkeepmapper.insertMending(mending);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("repair_seq", mending.getRepair_seq());
		
		return result;
	}
	
	@Override
	public void insertMendingCart(MendingCartVO mendingcart) {
		MendingKeepMapper mendingkeepmapper = sqlSession.getMapper(MendingKeepMapper.class);
		mendingkeepmapper.insertMendingCart(mendingcart);
	}
	
	@Override
	public int insertKeep(KeepVO keep) {
		MendingKeepMapper mendingkeepmapper = sqlSession.getMapper(MendingKeepMapper.class);
		
		Date today = new Date();
		SimpleDateFormat date = new SimpleDateFormat("yyyy/MM/dd");

		Calendar start_cal = Calendar.getInstance();
		Calendar end_cal = Calendar.getInstance();
		start_cal.setTime(today);
		start_cal.add(Calendar.DATE, 1);
		end_cal.add(Calendar.DATE, 1);
		
		if(keep.getKeep_month()==1) {
			end_cal.add(Calendar.MONTH,1);
		} else if(keep.getKeep_month()==3) {
			end_cal.add(Calendar.MONTH,3);
		} else if(keep.getKeep_month()==6) {
			end_cal.add(Calendar.MONTH,6);
		}
		
		keep.setKeep_start(date.format(start_cal.getTime()));
		keep.setKeep_end(date.format(end_cal.getTime()));
		
		int result = mendingkeepmapper.insertKeep(keep);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("keep_seq", keep.getKeep_seq());
		
		return result;
	}
	
	@Override
	public void insertKeepCart(KeepCartVO keepcart) {
		MendingKeepMapper mendingkeepmapper = sqlSession.getMapper(MendingKeepMapper.class);
		mendingkeepmapper.insertKeepCart(keepcart);
	}
	
	@Override
	public int insertWash(WashingVO washing) {
		MendingKeepMapper mendingkeepmapper = sqlSession.getMapper(MendingKeepMapper.class);
		int result = mendingkeepmapper.insertWash(washing);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("wash_seq", washing.getWash_seq());
		
		return result;
	}
	
	@Override
	public void insertWashingCart(WashingCartVO washingcart) {
		MendingKeepMapper mendingkeepmapper = sqlSession.getMapper(MendingKeepMapper.class);
		mendingkeepmapper.insertWashingCart(washingcart);
	}
}
