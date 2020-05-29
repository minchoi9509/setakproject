package com.spring.community;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public interface QnaService 
{
	// 게시판 리스트
	public int getListCount();
	public ArrayList<HashMap<String, Object>> getQnaList(HashMap<String, Object> map);

	// 게시판 글 작성
	public ArrayList<Long> getOrderList(String member_id);
	public int insertQna(QnaVO qvo); 
	
	// 게시판 상세보기
	public HashMap<String, Object> getDetail(QnaVO qvo);
	
	// 게시판 수정
	public int updateQna(QnaVO qvo);	
	
	// 게시판 삭제
	public int deleteQna(QnaVO qvo);
	
	// 덧글 리스트
	public ArrayList<ReplyVO> getReplyList(QnaVO qvo);
	
	// 덧글 입력
	public int insertReply(ReplyVO rvo); 
	
	// 덧글 수정
	public int updateReply(ReplyVO rvo);
	
	// 덧글 삭제
	public int deleteReply(ReplyVO rvo);
	
	// 덧글 대댓글 입력
	public int insertReReply(ReplyVO rvo);
	
	// 덧글 갯수 
	public int getReplyCount(ReplyVO rvo);
	
	public String qnaPassChk(int num) throws Exception;
	public String getMemberName (String name);
	

	//관리자의 권한 (추가 , 수정 , 삭제 )
	public List<Object> ad_qnalist();	
	public int ad_qnaModify(QnaVO vo); 	
	public int getMaxNum()throws Exception ;
	
	//기응
	public ArrayList<QnaVO> selectQnalist(HashMap<String, Object> map);
}
