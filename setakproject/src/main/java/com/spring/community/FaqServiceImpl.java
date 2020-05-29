package com.spring.community;

import java.util.ArrayList;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.spring.mapper.FaqMapper;

@Service("faqSeevice")
public class FaqServiceImpl implements FaqService 
{
	@Autowired(required = false) private SqlSession sqlSession;
	
	@Override public  ArrayList<FaqVO> getFaqList () throws Exception
	{
		FaqMapper faqMapper = sqlSession.getMapper(FaqMapper.class);
		ArrayList<FaqVO> vo  = new  ArrayList<FaqVO>();
		try
		{
			vo = faqMapper.getFaqList();
			return vo;
		}
		catch (Exception e)
		{
			throw new Exception("faq db에 뿌리기  실패", e);
		}
	}

	@Override
	public void faqInsert(FaqVO vo) {
		FaqMapper faqMapper = sqlSession.getMapper(FaqMapper.class);
		int num = faqMapper.getMaxNum()+1;
		System.out.println(num);
		vo.setFaq_num(num);		
		faqMapper.faqInsert(vo);
		
	}

	@Override
	public int getMaxNum() {
		FaqMapper faqMapper = sqlSession.getMapper(FaqMapper.class);
		int num = faqMapper.getMaxNum();
		return num;
	}

	@Override
	public void faqModify(FaqVO vo) {
		FaqMapper faqMapper = sqlSession.getMapper(FaqMapper.class);
		faqMapper.faqModify(vo);
	}

	@Override
	public void faqDelete(int num) {
		FaqMapper faqMapper = sqlSession.getMapper(FaqMapper.class);
		faqMapper.faqDelete(num);
		
	}

	
}
