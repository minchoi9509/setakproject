package com.spring.community;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.spring.mapper.QnaMapper;

@Service("qnaService")
public class QnaServiceImpl implements QnaService {
	@Autowired(required = false)
	private SqlSession sqlSession;

	@Override
	public int getListCount() {
		int count = 0;
		QnaMapper qnaMapper = sqlSession.getMapper(QnaMapper.class);
		try {
			count = qnaMapper.getListCount();

		} catch (Exception e) {
			System.out.println("QnA 개수 검색 실패 " + e.getMessage());
		}

		return count;

	}

	@Override
	public ArrayList<HashMap<String, Object>> getQnaList(HashMap<String, Object> map) {
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		try {
			QnaMapper qnaMapper = sqlSession.getMapper(QnaMapper.class);
			list = qnaMapper.getQnaList(map);
		} catch (Exception e) {
			System.out.println("QnA 리스트 검색 실패 " + e.getMessage());
		}
		
		return list;

	}

	@Override
	public ArrayList<Long> getOrderList (String member_id) {
		ArrayList<Long> list = new ArrayList<Long>();
		try {
			QnaMapper qnaMapper = sqlSession.getMapper(QnaMapper.class);
			list = qnaMapper.getOrderList(member_id);
		} catch (Exception e) {
			System.out.println("QnA 주문 번호 리스트 검색 실패 " + e.getMessage());
		}
		
		return list; 
	}
	
	@Override
	public int insertQna(QnaVO qvo) {
		QnaMapper qnaMapper = sqlSession.getMapper(QnaMapper.class);
		int res = 0; 
		try {
			res = qnaMapper.insertQna(qvo);
		} catch (Exception e) {
			System.out.println("QnA 원글 등록 실패 " + e.getMessage());
		}
		return res; 
	}

	@Override
	public HashMap<String, Object> getDetail(QnaVO qvo) {
		QnaMapper qnaMapper = sqlSession.getMapper(QnaMapper.class);
		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map = qnaMapper.getDetail(qvo);
		} catch (Exception e) {
			System.out.println("QnA 상세보기 실패 " + e.getMessage());
		}
		return map;
	}
	
	@Override
	public int updateQna(QnaVO qvo) {
		QnaMapper qnaMapper = sqlSession.getMapper(QnaMapper.class);
		int res = 0;
		try {
			res = qnaMapper.updateQna(qvo);

		} catch (Exception e) {
			System.out.println("QnA 게시글 수정 실패 " + e.getMessage());
		}
		return res;
	}

	@Override
	public int deleteQna(QnaVO qvo) {

		QnaMapper qnaMapper = sqlSession.getMapper(QnaMapper.class);
		int res = 0;
		try {
			res = qnaMapper.deleteQna(qvo);

		} catch (Exception e) {
			System.out.println("QnA 게시글 삭제 실패 " + e.getMessage());
		}
		return res;
	}
	

	@Override
	public ArrayList<ReplyVO> getReplyList(QnaVO qvo) {
		QnaMapper qnaMapper = sqlSession.getMapper(QnaMapper.class);
		ArrayList<ReplyVO> list = new ArrayList<ReplyVO>(); 
		try {
			list = qnaMapper.getReplyList(qvo);

		} catch (Exception e) {
			System.out.println("QnA 게시글 댓글 리스트 불러오기 실패 " + e.getMessage());
		}
		return list;
	}
	
	@Override
	public int insertReply(ReplyVO rvo) {
		QnaMapper qnaMapper = sqlSession.getMapper(QnaMapper.class);
		int res = 0; 
		try {
			res = qnaMapper.insertReply(rvo);

		} catch (Exception e) {
			System.out.println("QnA 게시글 댓글 입력 실패 " + e.getMessage());
		}
		return res;
	}
	
	@Override
	public int updateReply(ReplyVO rvo) {
		QnaMapper qnaMapper = sqlSession.getMapper(QnaMapper.class);
		int res = 0; 
		try {
			res = qnaMapper.updateReply(rvo);
			
		} catch (Exception e) {
			System.out.println("QnA 게시글 수정 실패 " + e.getMessage());
		}
		return res;
	}	
	
	@Override
	public int deleteReply(ReplyVO rvo) {
		QnaMapper qnaMapper = sqlSession.getMapper(QnaMapper.class);
		int res = 0; 
		try {
			res = qnaMapper.deleteReply(rvo);
			
		} catch (Exception e) {
			System.out.println("QnA 게시글 삭제 실패 " + e.getMessage());
		}
		return res;
	}	
	
	@Override
	public int insertReReply(ReplyVO rvo) {
		QnaMapper qnaMapper = sqlSession.getMapper(QnaMapper.class);
		int res = 0; 
		try {
			res = qnaMapper.insertReReply(rvo);
			
		} catch (Exception e) {
			System.out.println("QnA 게시글 대댓글 입력 실패 " + e.getMessage());
		}
		return res;
	}	
	
	@Override
	public int getReplyCount(ReplyVO rvo) {
		QnaMapper qnaMapper = sqlSession.getMapper(QnaMapper.class);
		int cnt = 0; 
		try {
			cnt = qnaMapper.getReplyCount(rvo);
			
		} catch (Exception e) {
			System.out.println("QnA 게시글 개수 검색 실패 " + e.getMessage());
		}
		return cnt;
	}	
	

	@Override
	public String getMemberName(String name) {
		QnaMapper qnaMapper = sqlSession.getMapper(QnaMapper.class);
		String member_name = qnaMapper.getMemberName(name);
		return member_name;
	}


	@Override
	public String qnaPassChk(int num) throws Exception {
		QnaMapper qnaMapper = sqlSession.getMapper(QnaMapper.class);
		String res = qnaMapper.qnaPassChk(num);
		return res;
	}

	@Override
	public int getMaxNum() throws Exception {
		int res = 0;
		int maxnum = 0;
		QnaMapper qnaMapper = sqlSession.getMapper(QnaMapper.class);
		try {

			res = qnaMapper.getMaxNum();

		} catch (Exception e) {
			throw new Exception("최댓값 구하기  실패", e);
		}
		return res;

	}

	@Override
	public List<Object> ad_qnalist() {
		QnaMapper qnaMapper = sqlSession.getMapper(QnaMapper.class);
		List<Object> list = qnaMapper.ad_qnalist();
		return list;
	}

	@Override
	public int ad_qnaModify(QnaVO vo) {
		QnaMapper qnaMapper = sqlSession.getMapper(QnaMapper.class);
		int res = qnaMapper.ad_qnaModify(vo);
		return res;
	}

	// 기응
	@Override
	public ArrayList<QnaVO> selectQnalist(HashMap<String, Object> map) {
		ArrayList<QnaVO> qnalist = null;

		QnaMapper qnaMapper = sqlSession.getMapper(QnaMapper.class);

		qnalist = qnaMapper.selectQnalist(map);
		return qnalist;
	}



}