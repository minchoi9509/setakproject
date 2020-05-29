package com.spring.setak;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.Admin_KeepMapper;
import com.spring.mapper.Admin_MendingMapper;
import com.spring.mapper.Admin_WashMapper;

@Service("Admin_MendingKeepService")
public class Admin_MendingKeepServiceImpl implements Admin_MendingKeepService{
	
	@Autowired
	private SqlSession sqlSession;
	
	//세탁
	@Override
	public List<Object> getWashList(){
		List<Object> result = null;
		Admin_WashMapper washMapper = sqlSession.getMapper(Admin_WashMapper.class);
		result = washMapper.getWashList();
		
		return result;
	}
	
	@Override
	public int updateWash(WashingVO params){
		Admin_WashMapper washMapper = sqlSession.getMapper(Admin_WashMapper.class);
		int res = washMapper.updateWash(params);
		return res;
	}
	
	@Override
	public int deleteWash(int wash) {
		Admin_WashMapper washMapper = sqlSession.getMapper(Admin_WashMapper.class);
		int res = washMapper.deleteWash(wash);
		return res;
	}
	
	@Override
	public List<Object> washSearch(HashMap<String, Object> map){
		List<Object> washlist = null;
		Admin_WashMapper washMapper = sqlSession.getMapper(Admin_WashMapper.class);
		washlist = washMapper.washSearch(map);
		
		return washlist;
	}
	
	//수선
	@Override
	public List<Object> getMendingList(){
		List<Object> result = null;
		Admin_MendingMapper mendingMapper = sqlSession.getMapper(Admin_MendingMapper.class);
		result = mendingMapper.getMendingList();
		
		return result;
	}	
	
	@Override
	public int updateMending(MendingVO params){
		Admin_MendingMapper mendingMapper = sqlSession.getMapper(Admin_MendingMapper.class);
		int res = mendingMapper.updateMending(params);
		return res;
	}
	
	@Override
	public int deleteMending(int mending) {
		Admin_MendingMapper mendingMapper = sqlSession.getMapper(Admin_MendingMapper.class);
		int res = mendingMapper.deleteMending(mending);
		return res;
	}
	
	@Override
	public List<Object> mendingSearch(HashMap<String, Object> map){
		List<Object> mendinglist = null;
		Admin_MendingMapper mendingMapper = sqlSession.getMapper(Admin_MendingMapper.class);
		mendinglist = mendingMapper.mendingSearch(map);
		
		return mendinglist;
	}
	
	@Override
	public List<Object> mendingLoadImg(HashMap<String, Object> map){
		List<Object> imglist = null;
		Admin_MendingMapper mendingMapper = sqlSession.getMapper(Admin_MendingMapper.class);
		imglist = mendingMapper.mendingLoadImg(map);
		
		return imglist;
	}
	
	@Override
	public void deleteMendingImg(String repair_file){
		Admin_MendingMapper mendingMapper = sqlSession.getMapper(Admin_MendingMapper.class);
		mendingMapper.deleteMendingImg(repair_file);
	}
	
	@Override
	public int MendingImg(HashMap<String, Object> map) {
		Admin_MendingMapper mendingMapper = sqlSession.getMapper(Admin_MendingMapper.class);
		int res = mendingMapper.MendingImg(map);
		return res;
	}
	
	//보관
	@Override
	public List<Object> getKeepList(){
		List<Object> result = null;
		Admin_KeepMapper keepMapper = sqlSession.getMapper(Admin_KeepMapper.class);
		result = keepMapper.getKeepList();
		
		return result;
	}
	
	@Override
	public int updateKeep(KeepVO params){
		Admin_KeepMapper keepMapper = sqlSession.getMapper(Admin_KeepMapper.class);
		int res = keepMapper.updateKeep(params);
		return res;
	}
	
	@Override
	public int keepImg(HashMap<String, Object> map) {
		Admin_KeepMapper keepMapper = sqlSession.getMapper(Admin_KeepMapper.class);
		int res = keepMapper.keepImg(map);
		return res;
	}

	@Override
	public void deleteImg(String keep_path){
		Admin_KeepMapper keepMapper = sqlSession.getMapper(Admin_KeepMapper.class);
		keepMapper.deleteImg(keep_path);
	}
	
	@Override
	public List<Object> loadImg(HashMap<String, Object> map){
		List<Object> imglist = null;
		Admin_KeepMapper keepMapper = sqlSession.getMapper(Admin_KeepMapper.class);
		imglist = keepMapper.loadImg(map);
		
		return imglist;
	}

	@Override
	public int deleteKeep(int keep) {
		Admin_KeepMapper keepMapper = sqlSession.getMapper(Admin_KeepMapper.class);
		int res = keepMapper.deleteKeep(keep);
		return res;
	}
	
	@Override
	public List<Object> keepSerach(HashMap<String, Object> map){
		List<Object> keeplist = null;
		Admin_KeepMapper keepMapper = sqlSession.getMapper(Admin_KeepMapper.class);
		keeplist = keepMapper.keepSerach(map);
		
		return keeplist;
	}
}
