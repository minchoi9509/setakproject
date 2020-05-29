package com.spring.mypage;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.MypageMapper;
import com.spring.member.MemberVO;
import com.spring.order.OrderListVO;
import com.spring.order.OrderVO;
import com.spring.setak.KeepVO;
import com.spring.setak.MendingVO;
import com.spring.setak.WashingVO;

@Service("mypageService")
public class MypageServiceImpl implements MypageService {
	
	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public ArrayList<OrderVO> getOrderlist(HashMap<String, Object> map){
		MypageMapper mypageMapper = sqlSession.getMapper(MypageMapper.class);
		ArrayList<OrderVO> orderlist = new ArrayList<OrderVO>();
		
		orderlist = mypageMapper.getOrderlist(map);

		return orderlist;
	}
	
	
	@Override
	public ArrayList<OrderListVO> getOrdernumlist(HashMap<String, Object> map){
		MypageMapper mypageMapper = sqlSession.getMapper(MypageMapper.class);
		ArrayList<OrderListVO> ordernumlist = new ArrayList<OrderListVO>();
		
		ordernumlist = mypageMapper.getOrdernumlist(map);
		return ordernumlist;
	}
	
	@Override
	public int getOrdernumcount(String member_id) {
		MypageMapper mypageMapper = sqlSession.getMapper(MypageMapper.class);
		int res = mypageMapper.getOrdercount(member_id);
		
		return res;
	}
	
	@Override
	public ArrayList<KeepVO> selectMykeeplist(long order_num) {
		MypageMapper mypageMapper = sqlSession.getMapper(MypageMapper.class);
		ArrayList<KeepVO> keeplist = new ArrayList<KeepVO>();
		
		keeplist = mypageMapper.selectMykeeplist(order_num);
		return keeplist;
	}
	
	@Override
	public int selectMykeep(long order_num) {
		MypageMapper mypageMapper = sqlSession.getMapper(MypageMapper.class);
		int keepVO = 0;
		
		
		keepVO = mypageMapper.selectMykeep(order_num);
		
		return keepVO;
	}
	
	
	@Override
	public KeepVO getKeepSeq(int keep_seq) {
		MypageMapper mypageMapper = sqlSession.getMapper(MypageMapper.class);
		KeepVO keepVO = new KeepVO();
		keepVO = mypageMapper.getKeepSeq(keep_seq);
		
		return keepVO;
	}
	
	
	@Override
	public int getOrdercount(String member_id) {
		MypageMapper mypageMapper = sqlSession.getMapper(MypageMapper.class);
		int orderVO = mypageMapper.getOrdercount(member_id);
		
		return orderVO;
	}
	
	@Override
	public int getKeepcount() {
		MypageMapper mypageMapper = sqlSession.getMapper(MypageMapper.class);
		int keepVO = mypageMapper.getKeepcount();
		
		return keepVO;
	}
	
	
	@Override
	public String selectOrderId(String member_id) {
		MypageMapper mypageMapper = sqlSession.getMapper(MypageMapper.class);
		String orderVO = mypageMapper.selectOrderId(member_id);
		
		return orderVO;
	}
	
	@Override
	public ArrayList<MendingVO> selectMending(long order_num) {
		MypageMapper mypageMapper = sqlSession.getMapper(MypageMapper.class);
		ArrayList<MendingVO> mendingVO = new ArrayList<MendingVO>();
		
		mendingVO = mypageMapper.selectMending(order_num);
		
		return mendingVO;
	}
	
	@Override
	public OrderVO selectOrder(long order_num) {
		MypageMapper mypageMapper = sqlSession.getMapper(MypageMapper.class);
		OrderVO orderVO = new OrderVO();
		
		orderVO = mypageMapper.selectOrder(order_num);
		
		return orderVO;
	}
	
	@Override
	public ArrayList<KeepVO> selectKeep(long order_num) {
		MypageMapper mypageMapper = sqlSession.getMapper(MypageMapper.class);
		ArrayList<KeepVO> keepVO = new ArrayList<KeepVO>();
			
		keepVO = mypageMapper.selectKeep(order_num);
		
		return keepVO;
	}
	
	@Override
	public ArrayList<WashingVO> selectWashing(long order_num) {
		MypageMapper mypageMapper = sqlSession.getMapper(MypageMapper.class);
		ArrayList<WashingVO> washVO = new ArrayList<WashingVO>();
		
		washVO = mypageMapper.selectWashing(order_num);
		
		return washVO;
	}
	
	//보관연장
	@Override
	public int updateKeepMonth(HashMap<String, Object> map) {
		int res = 0;
		MypageMapper mypageMapper = sqlSession.getMapper(MypageMapper.class);
		
		res = mypageMapper.updateKeepMonth(map);
	
		return res;
	}
	
	@Override
	public int all_Return(HashMap<String, Object> map) {
		int res = 0;
		MypageMapper mypageMapper = sqlSession.getMapper(MypageMapper.class);
		
		res = mypageMapper.all_Return(map);
		
		return res;
	}
	
	@Override
	public int part_Return_now(HashMap<String, Object> map) {
		int res = 0;
		MypageMapper mypageMapper = sqlSession.getMapper(MypageMapper.class);
		
		res = mypageMapper.part_Return_now(map);
		
		return res;
	}
	

	//리턴
	@Override
	public int part_Return(KeepReturnVO krvo) {
		int res = 0;
		try {
		MypageMapper mypageMapper = sqlSession.getMapper(MypageMapper.class);
		res = mypageMapper.part_Return(krvo);
		
		}catch(Exception e) {
			System.out.println("반환입력 실패" + e.getMessage());
		}
		return res;
	}
	
	@Override
	public MemberVO getMember(String member_id) {
		MemberVO mvo = null; 
		try {
			MypageMapper mypageMapper = sqlSession.getMapper(MypageMapper.class);
			mvo = mypageMapper.getMember(member_id);
		} catch(Exception e) {
			System.out.println("멤버 정보 검색 실패 " + e.getMessage());
		}
		
		return mvo; 		
		
	}

	@Override
	public ArrayList<KeepPhotoVO> selectPhoto(long order_num){
		MypageMapper mypageMapper = sqlSession.getMapper(MypageMapper.class);
		ArrayList<KeepPhotoVO> kpvo = new ArrayList<KeepPhotoVO>();
		
		kpvo = mypageMapper.selectPhoto(order_num);
		
		return kpvo;
	}

	public int updateReview(HashMap<String, Object> map) {
		MypageMapper mypageMapper = sqlSession.getMapper(MypageMapper.class);
		int res = 0;
		res = mypageMapper.updateReview(map);
		
		return res;
	}
	
	@Override
	public int getQnaCount(String member_id) {
		MypageMapper mypageMapper = sqlSession.getMapper(MypageMapper.class);
		int res = 0;
		res = mypageMapper.getQnaCount(member_id);
		
		return res;
	}
}


