package com.spring.api;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.IPCountMapper;

@Service
public class IPCountServiceImpl implements IPCountService {

	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public int getIPList(String member_ip) {
		IPCountMapper icm = sqlSession.getMapper(IPCountMapper.class);
		int ipchk = icm.getIPList(member_ip);
		
		return ipchk;
	}

	@Override
	public int countIP(String member_ip) {
		IPCountMapper icm = sqlSession.getMapper(IPCountMapper.class);
		int countip = icm.countIP(member_ip);
		
		return countip;
	}

	@Override
	public void insertIP(String member_ip) {
		IPCountMapper icm = sqlSession.getMapper(IPCountMapper.class);
		icm.insertIP(member_ip);

	}

	@Override
	public void plusIPCount(String member_ip) {
		IPCountMapper icm = sqlSession.getMapper(IPCountMapper.class);
		icm.plusIPCount(member_ip);

	}

}
