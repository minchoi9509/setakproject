package com.spring.order;

import java.util.ArrayList;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.OrderMapper;
import com.spring.member.MemberVO;
import com.spring.member.SubscribeVO;

@Service
public class OrderServiceImpl implements OrderService  {

	@Autowired
	private SqlSession sqlSession;

	@Override
	public int insertOrder(OrderVO ovo) {
		int res = 0;
		try {
			OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
			res = orderMapper.insertOrder(ovo);
		} catch(Exception e) {
			System.out.println("주문 추가 실패 " + e.getMessage());
		}
		
		return res; 
	}

	@Override
	public int deleteWashCartbyID(String member_id) {
		int res = 0;
		try {
			OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
			res = orderMapper.deleteWashCartbyID(member_id);
		}catch(Exception e) {
			System.out.println("세탁 장바구니 삭제 실패" + e.getMessage());
		}
		
		return res;
	}

	@Override
	public int deleteMendingCartbyID(String member_id) {
		int res = 0;
		try {
			OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
			res = orderMapper.deleteMendingCartbyID(member_id);
		}catch(Exception e) {
			System.out.println("수선 장바구니 삭제 실패" + e.getMessage());
		}
		
		return res;
	}

	@Override
	public int deleteKeepCartbyID(String member_id) {
		int res = 0;
		try {
			OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
			res = orderMapper.deleteKeepCartbyID(member_id);
		}catch(Exception e) {
			System.out.println("보관 장바구니 삭제 실패" + e.getMessage());
		}
		
		return res;
	}

	@Override
	public int insertOrderList(OrderListVO olv) {
		int res = 0;
		try {
			OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
			res = orderMapper.insertOrderList(olv);
		} catch(Exception e) {
			System.out.println("주문 리스트 추가 실패 " + e.getMessage());
		}
		
		return res; 
	}

	@Override
	public ArrayList<OrderListVO> getOrderList(OrderListVO olv) {
		ArrayList<OrderListVO> ordersList = null;
		try {
			OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
			ordersList = orderMapper.getOrderList(olv);
		} catch(Exception e) {
			System.out.println("주소 리스트 시퀀스 검색 실패" + e.getMessage());
		}
		
		return ordersList;
	}

	@Override
	public int getOrderPrice(OrderListVO olv) {
		int price = 0;
		try {
			OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
			price = orderMapper.getOrderPrice(olv);
		} catch(Exception e) {
			System.out.println("결제 금액 검색 실패 " + e.getMessage());
		}
		
		return price; 
	}

	@Override
	public MemberVO getMemberInfo(String member_id) {
		MemberVO mvo = null; 
		try {
			OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
			mvo = orderMapper.getMemberInfo(member_id);
		} catch(Exception e) {
			System.out.println("멤버 정보 검색 실패 " + e.getMessage());
		}
		
		return mvo; 		
	}

	@Override
	public int defaultAddrUpdate(MemberVO mvo) {
		int res = 0;
		try {
			OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
			res = orderMapper.defaultAddrUpdate(mvo);
		} catch(Exception e) {
			System.out.println("기본지 배송지 수정 실패 " + e.getMessage());
		}
		
		return res; 
	}
	
	@Override
	public int updateSubInfo(MemberVO mvo) {
		int res = 0;
		try {
			OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
			res = orderMapper.updateSubInfo(mvo);
		} catch(Exception e) {
			System.out.println("회원 정보 > 정기구독 번호 등록 실패 " + e.getMessage());
		}
		
		return res; 
	}

	@Override
	public int insertMemberSubInfo(Map<String, Object> map) {
		int res = 0;
		try {
			OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
			res = orderMapper.insertMemberSubInfo(map);
		} catch(Exception e) {
			System.out.println("회원 정기구독 정보 등록 실패 " + e.getMessage());
		}
		
		return res; 
	}

	@Override
	public int insertSubHistory(MemberVO mvo) {
		int res = 0;
		try {
			OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
			res = orderMapper.insertSubHistory(mvo);
		} catch(Exception e) {
			System.out.println("회원 정기구독 결제 정보 등록 실패 " + e.getMessage());
		}
		
		return res; 
	}

	@Override
	public int getCouponNum(MemberVO mvo) {
		int cnt = 0; 
		try {
			OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
			cnt = orderMapper.getCouponNum(mvo);
		} catch(Exception e) {
			System.out.println("쿠폰 갯수 검색 실패 " + e.getMessage());
		}
		
		return cnt; 
	}

	@Override
	public int insertCoupon(MemberVO mvo) {
		int res = 0;
		try {
			OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
			res = orderMapper.insertCoupon(mvo);
		} catch(Exception e) {
			System.out.println("쿠폰 등록 실패 " + e.getMessage());
		}
		
		return res; 
	}

	@Override
	public SubscribeVO getSubscribeInfo(MemberVO mvo) {
		SubscribeVO svo = null;
		try {
			OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
			svo = orderMapper.getSubscribeInfo(mvo);
		} catch(Exception e) {
			System.out.println("정기구독 정보 읽어오기 실패 " + e.getMessage());
		}
		
		return svo; 
	}

	@Override
	public int orderCancle(OrderVO ovo) {
		int res = 0;
		try {
			OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
			res = orderMapper.orderCancle(ovo);
		} catch(Exception e) {
			System.out.println("주문 취소 정보 등록 실패 " + e.getMessage());
		}
		
		return res; 
	}

	@Override
	public int getKeepMaxGroup(String member_id) {
		int res = 0;
		try {
			OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
			res = orderMapper.getKeepMaxGroup(member_id);
		} catch(Exception e) {
			System.out.println("보관 keep_group 검색 실패 " + e.getMessage());
		}
		
		return res; 
	}

	@Override
	public int getKeepExist(String member_id) {
		int cnt = 0;
		try {
			OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
			cnt = orderMapper.getKeepExist(member_id);
		} catch(Exception e) {
			System.out.println("보관 장바구니 유무 존재 검색 실패 " + e.getMessage());
		}
		
		return cnt;
	}

	
}
