package com.spring.mapper;

import java.util.ArrayList;
import java.util.List;

import com.spring.community.NoticeVO;



public interface NoticeMapper 
{	
	
	public ArrayList<NoticeVO> getNoticeList(int startRow, int endRow);
	public int getListCount();	
	public NoticeVO getDetail(int num) throws Exception;						
	public int noticeInsert(NoticeVO vo) throws Exception;			
	public int noticeModify(NoticeVO vo)throws Exception;	
	public int noticeDelete(int num)throws Exception;	
	public int getMaxNum ()throws Exception;
	public List<Object> ad_noticeList();	
	
	


}
