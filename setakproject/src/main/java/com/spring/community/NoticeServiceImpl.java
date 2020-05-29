package com.spring.community;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import com.spring.mapper.NoticeMapper;


@Service("noticeService")
public class NoticeServiceImpl implements NoticeService
{
	@Autowired(required = false) private SqlSession sqlSession;
	
	@Override public int getListCount() throws Exception
	{
		int count=0;
		NoticeMapper noticeMapper = sqlSession.getMapper(NoticeMapper.class);
		try
		{
			count  = noticeMapper.getListCount();
		}
		catch(Exception e)
		{
			System.out.println("카운트 실패 " + e.getMessage());	
		}
				
		return count;

	}

	@Override public ArrayList<NoticeVO> getNoticeList(int startRow, int endRow)  throws Exception
	{
		ArrayList<NoticeVO> list = new ArrayList<NoticeVO>();
		//HashMap<String, Integer> vo = new HashMap<String, Integer>();
		
		try
		{	
			
			NoticeMapper noticeMapper = sqlSession.getMapper(NoticeMapper.class);
			list = noticeMapper.getNoticeList(startRow, endRow);
			return list;			
		}
		catch(Exception e)
		{
			throw new Exception("오류남 ㅇㅇ.", e);
		}
	
	}
	
	@Override public NoticeVO getDetail(NoticeVO vo) throws Exception 
	{
		NoticeMapper noticeMapper = sqlSession.getMapper(NoticeMapper.class);
		NoticeVO noticevo= new NoticeVO();
		try
		{						
			noticevo = noticeMapper.getDetail(vo.getNotice_num());
			
			
			return noticevo;
		}
		catch (Exception e)
		{
			throw new Exception("상세보기 실패", e);
		}
		
		
	}

	@Override public int noticeInsert(NoticeVO vo) throws Exception
	{
		NoticeMapper noticeMapper = sqlSession.getMapper(NoticeMapper.class);		
		int num = 0;
		
		if (noticeMapper.getListCount()>0)
		{
			num = noticeMapper.getMaxNum()+1;
		}
		else
		{
			num = 1;
		}
		vo.setNotice_num(num);
		int res = noticeMapper.noticeInsert(vo);		
		return res;
	}

	@Override public int noticeModify(NoticeVO vo) throws Exception 
	{
		int res = -1;
		NoticeMapper boardMapper = sqlSession.getMapper(NoticeMapper.class);
		res = boardMapper.noticeModify(vo);
		return res;
	}

	@Override public int noticeDelete(NoticeVO vo) throws Exception 
	{	
		int res = 0;
		NoticeMapper noticeMapper = sqlSession.getMapper(NoticeMapper.class);
		
		res =noticeMapper.noticeDelete(vo.getNotice_num());
		return res;

	}

	@Override
	public List<Object> ad_noticeList() {
		List<Object> result = null;
		NoticeMapper noticeMapper = sqlSession.getMapper(NoticeMapper.class);
		result = noticeMapper.ad_noticeList();
		
		return result;
	}

}
