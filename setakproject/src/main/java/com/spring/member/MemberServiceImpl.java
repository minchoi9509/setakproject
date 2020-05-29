package com.spring.member;

import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.MemberMapper;

@Service
public class MemberServiceImpl implements MemberService{
	
	@Autowired
	private SqlSession sqlsession;
	
	//아이디 확인(중복여부)
	@Override 
	public int member_id(MemberVO mo) {
		int res = 0;
		MemberMapper mapper = sqlsession.getMapper(MemberMapper.class);
		String id = mapper.member_id(mo);
		
		try {
			if(id != null) {
				String dbpassid = id;
				
				if(dbpassid.equals(mo.getMember_id())) {
					res = 1; //아이디중복
					}
				}
			} catch (Exception e) {
				System.out.println("아이디 중복 확인 실패" + e.getMessage());
				 res = -1;
			}
			 return res;
	}
	
	//회원가입
	@Override
	public int member_insert(MemberVO mo) {
		 int res = 0;
		 try {
			 MemberMapper mapper = sqlsession.getMapper(MemberMapper.class);
			 mapper.member_insert(mo);
			
		 } catch(Exception e) {
				System.out.println("멤버 추가 실패" + e.getMessage());
				res = 0;
		 }
		 
		 return res;
	}
	
	//비밀번호 확인
	@Override
	public int member_password(MemberVO mo) {
		MemberMapper mapper = sqlsession.getMapper(MemberMapper.class);
		int res = 0;
		String passwd = mapper.member_password(mo);
	
		try {
			if(passwd != null) {
				String dbpasswd = passwd;
				if(dbpasswd.equals(mo.getMember_password())) {
					res = 1; //비밀번호 일치
				}
			}
		} catch (Exception e) {
			System.out.println("비밀번호 일치 실패" + e.getMessage());
			 res = -1;
		}
		 return res;
	}
	
	@Override
	public int member_password2(HashMap<String, Object> map) {
		MemberMapper mapper = sqlsession.getMapper(MemberMapper.class);
		int res = 0;
		String passwd = mapper.member_password2(map);
		String writepw = (String) map.get("member_password");
		try {
			if(passwd != null) {
				String dbpasswd = passwd;
				if(dbpasswd.equals(writepw)) {
					res = 1; //비밀번호 일치
				}
			}
		} catch (Exception e) {
			System.out.println("비밀번호 일치 실패" + e.getMessage());
			 res = -1;
		}
		 return res;
	}
	
	
	// 회원정보 출력
		@Override
		public MemberVO member_list(MemberVO mo) {
			 MemberVO mvo = null;
			 try {
				 MemberMapper mapper = sqlsession.getMapper(MemberMapper.class);
				 mvo = mapper.member_list(mo);
			 } catch(Exception e) {
					System.out.println("멤버 리스트 검색 실패" + e.getMessage());
			 }
			 
			 return mvo;
		}
	
	// 회원정보 수정
	@Override
	public int member_update(MemberVO mo) {
		int res = 0;
		try {
			MemberMapper mapper = sqlsession.getMapper(MemberMapper.class);
			mapper.member_update(mo);
			res = 1;
		} catch(Exception e) {
			System.out.println("멤버 수정 실패" + e.getMessage());
			 res = 0;
		}
		 return res;
	}
	
	
	
	// 멤버 이름
		@Override
		public MemberVO name(String member_id) {
			MemberVO mo = null;
			try {
				MemberMapper mapper = sqlsession.getMapper(MemberMapper.class);
				mo = mapper.name(member_id);
			} catch (Exception e) {
				System.out.println("멤버이름 못찾앗어요"+e.getMessage());
			}
			return mo;
			
		}
		
	//로그인 연동시 회원가입
		@Override
		public int linkage(MemberVO mo) {
		int res = 1;
			try {
				MemberMapper mapper = sqlsession.getMapper(MemberMapper.class);
				mapper.linkage(mo);
						
			} catch(Exception e) {
				System.out.println("네이버 로그인 회원가입 실패" + e.getMessage());
				res = 0;
			}
					 
				return res;
			}
		
	//아이디 보여주기
	@Override
	public String show_id(HashMap<String, Object> map)	{
		String dbid = "";
		try {
			MemberMapper mapper = sqlsession.getMapper(MemberMapper.class);
			dbid=mapper.show_id(map);
	  } catch(Exception e) {
			System.out.println("아이디 보여주기 실패" + e.getMessage());
	 }
		return dbid;
	}
	
	
	// 비밀번호 찾기- 변경하기 버튼
		@Override
		public int chk_you(HashMap<String, Object> map) {
			int res = 0;
			
			MemberMapper mapper = sqlsession.getMapper(MemberMapper.class);
			String id = mapper.chk_you(map);
		
			try {
				if(id != null) {
					String dbid = id;
					if(dbid.equals(map.get("member_id"))) {
						res = 1; //비밀번호 일치
					}
				}
			} catch (Exception e) {
				System.out.println("비밀번호 일치 실패" + e.getMessage());
				 res = -1;
			}
			 return res;
			
		}

	//비밀번호 변경
	@Override
	public int change_pw(HashMap<String, Object> map) {
		int res = 0;
		try {
			MemberMapper mapper = sqlsession.getMapper(MemberMapper.class);
			mapper.change_pw(map);
			res = 1;
		} catch(Exception e) {
			System.out.println("비밀번호 변경 실패" + e.getMessage());
			 res = 0;
		}
		 return res;
		
	}
		
		
	//회원삭제
	@Override
	public int member_delete(String member_id) {
		int res = 0;
		try {
				MemberMapper mapper = sqlsession.getMapper(MemberMapper.class);
				mapper.member_delete(member_id);
				res = 1;
			} catch(Exception e) {
				System.out.println("멤버 삭제 실패" + e.getMessage());
				res = 0;
			}
			 return res;
		}
}