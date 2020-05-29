package com.spring.mapper;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.spring.community.QnaVO;
import com.spring.community.ReplyVO;

public interface QnaMapper 
{

	public int getListCount();	
	public ArrayList<HashMap<String, Object>> getQnaList(HashMap<String, Object> map);	
	public ArrayList<Long> getOrderList (String member_id); 
	public int insertQna(QnaVO qvo); 
	public HashMap<String, Object> getDetail(QnaVO qvo);		
	public int updateQna(QnaVO qvo);
	public int deleteQna(QnaVO qvo);
	
	public ArrayList<ReplyVO> getReplyList(QnaVO qvo); 
	public int insertReply(ReplyVO rvo); 
	public int updateReply(ReplyVO rvo); 
	public int deleteReply(ReplyVO rvo); 
	public int insertReReply(ReplyVO rvo); 
	public int getReplyCount(ReplyVO rvo);
	
	// 
	public int getMaxNum() throws Exception;
	public String qnaPassChk(int num) throws Exception;
	public String getMemberName (String name);
	
	public List<Object> ad_qnalist();	
	public int ad_qnaModify(QnaVO vo); 
	
	//기응
	public ArrayList<QnaVO> selectQnalist(HashMap<String, Object> map);
}