package com.spring.community;

import java.util.List;

import com.spring.community.CommentVO;

public interface CommentService 
{
	List<CommentVO> commentList(CommentVO vo);
	int commentInsert(CommentVO vo);	
	int commentDelete(CommentVO vo);
	int commentUpdate(CommentVO vo);
	
	List<CommentVO> ad_commentList(CommentVO vo);
	
	
	
}
