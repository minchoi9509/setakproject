package com.spring.community;

import java.util.ArrayList;
import java.util.List;


public interface NoticeService 
{
	//회원이 보는 공지사항
	public int getListCount() throws Exception;
	public ArrayList<NoticeVO> getNoticeList(int page, int limit) throws Exception;	
	public NoticeVO getDetail(NoticeVO vo) throws Exception;
	
	//관리자의 권한 (추가 , 수정 , 삭제 )
	public int noticeInsert(NoticeVO vo) throws Exception;	
	public int noticeModify(NoticeVO vo) throws Exception;
	public int noticeDelete(NoticeVO vo) throws Exception;
	public List<Object> ad_noticeList();
	

}
