package com.spring.community;

import java.util.ArrayList;



public interface FaqService 
{
	public ArrayList<FaqVO> getFaqList ()throws Exception;
	public void faqInsert(FaqVO vo);
	public int getMaxNum();	
	public void faqModify(FaqVO vo);
	public void faqDelete(int num);
	
	
}
