package com.spring.community;

import java.util.List;


import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.community.CommentVO;
import com.spring.mapper.CommentMapper;

@Service("commentService")
public class CommentServiceImpl implements CommentService
{
	@Autowired private SqlSession sqlSession;

	@Override
	public List<CommentVO> commentList(CommentVO vo) 
	{
		
		CommentMapper commentMapper = sqlSession.getMapper(CommentMapper.class);		 
		List<CommentVO> list = null;
		list =commentMapper.commentList(vo.getQna_num()); 
		return list; 
	}

	@Override
	public int commentInsert(CommentVO vo) 
	{
		CommentMapper commentMapper = sqlSession.getMapper(CommentMapper.class);		
		int co_count = commentMapper.cntListCount();
		System.out.println("현 댓글의 갯수"+co_count);
		//((listcount - ((nowpage-1) * 10))- i)
		int qnaseq=0;	
		if (co_count!=0)
		{
			qnaseq = commentMapper.maxNum()+1;
		}
		else
			qnaseq = 1;
		
		
		System.out.println("업데이트된 댓글의 수="+qnaseq);
		vo.setQna_seq(qnaseq);
		System.out.println("DB에 업데이트된 댓글의 수="+vo.getQna_seq());
		System.out.println("유지되어야할 원글의 번호="+vo.getQna_num());
		System.out.println("DB에 업데이트된 내용="+vo.getQna_content());
		System.out.println("작성자 누구냐="+vo.getMember_id());
		int res = commentMapper.commentInsert(vo);
		System.out.println("인설트하고 뭐 들어감? ="+res);
		return res;
	}

	@Override
	public int commentDelete(CommentVO vo) 
	{
		int res = 0;
		CommentMapper commentMapper = sqlSession.getMapper(CommentMapper.class);
		res = commentMapper.commentDelete(vo);	
		System.out.println("Im,삭,여기까지"+ res);
		return res;
	}

	@Override
	public int commentUpdate(CommentVO vo) 
	{
		int res = 0;
		CommentMapper commentMapper = sqlSession.getMapper(CommentMapper.class);
		res = commentMapper.commentUpdate(vo);
		return res;
	}

	@Override
	public List<CommentVO> ad_commentList(CommentVO vo) {
		CommentMapper commentMapper = sqlSession.getMapper(CommentMapper.class);				
		List<CommentVO> list = commentMapper.ad_commentList(vo); 
		return list; 
	}

	

	/*
	 * @Override public ArrayList<CommentVO> getCommentList(CommentVO vo) {
	 * ArrayList<CommentVO> list = new ArrayList<CommentVO>(); CommentMapper
	 * commentMapper = sqlSession.getMapper(CommentMapper.class);
	 * System.out.println("Impl원글번호="+vo.getQNA_NUM()); list =
	 * commentMapper.getCommentList(vo.getQNA_NUM()); return list; }
	 */
	
	
	
}
