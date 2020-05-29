package com.spring.order;

import java.util.ArrayList;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.AddressMapper;

@Service
public class AddressServiceImpl implements AddressService {

	@Autowired
	private SqlSession sqlSession;

	@Override
	public ArrayList<AddressVO> getAddressList(String member_id) {
		ArrayList<AddressVO> addressList = null;
		try {
			AddressMapper addressMapper = sqlSession.getMapper(AddressMapper.class);
			addressList = addressMapper.getAddressList(member_id);
		} catch(Exception e) {
			System.out.println("주소 리스트 검색 실패" + e.getMessage());
		}
		
		return addressList;
	}
	
	@Override
	public AddressVO searchAddress(int address_num) {
		AddressVO avo = null;
		
		try {
			AddressMapper addressMapper = sqlSession.getMapper(AddressMapper.class);
			avo = addressMapper.searchAddress(address_num);
		} catch(Exception e) {
			System.out.println("주소 리스트 선택 실패" + e.getMessage());
		}
		
		return avo;
	}

	@Override
	public int insertAddress(AddressVO avo) {
		int res = 0;
		try {
			AddressMapper addressMapper = sqlSession.getMapper(AddressMapper.class);
			res = addressMapper.insertAddress(avo);
		} catch(Exception e) {
			System.out.println("신규 배송지 입력 실패 " + e.getMessage());
		}
		
		return res; 
	}

	@Override
	public int deleteAddress(int address_num) {
		int res = 0;
		try {
			AddressMapper addressMapper = sqlSession.getMapper(AddressMapper.class);
			res = addressMapper.deleteAddress(address_num);
		} catch(Exception e) {
			System.out.println("배송지 삭제 실패 " + e.getMessage());
		}
		
		return res; 
	}

	@Override
	public int updateAddress(AddressVO avo) {
		int res = 0;
		try {
			AddressMapper addressMapper = sqlSession.getMapper(AddressMapper.class);
			res = addressMapper.updateAddress(avo);
		} catch(Exception e) {
			System.out.println("배송지 수정 실패 " + e.getMessage());
		}
		
		return res; 
	}

	@Override
	public int getAddressCount(AddressVO avo) {
		int cnt = 0; 
		try {
			AddressMapper addressMapper = sqlSession.getMapper(AddressMapper.class);
			cnt = addressMapper.getAddressCount(avo);
		} catch(Exception e) {
			System.out.println("주소 리스트 갯수 검색 실패" + e.getMessage());
		}
		
		return cnt;
	}
	
	

}
