package com.spring.mapper;

import java.util.ArrayList;
import com.spring.community.FaqVO;

public interface FaqMapper 
{
	public ArrayList<FaqVO> getFaqList();
	public void faqInsert(FaqVO vo);	
	public int getMaxNum();	
	public void faqModify(FaqVO vo);
	public void faqDelete(int num);
}
