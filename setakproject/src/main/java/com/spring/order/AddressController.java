package com.spring.order;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
public class AddressController {
	
	@Autowired
	private AddressService addressService; 
	
	// 배송지 리스트
	@RequestMapping(value = "/getAddrList.do", method=RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody 
	public List<AddressVO> getAddrList(AddressVO avo) {
		
		String member_id = avo.getMember_id();
		List<AddressVO> list = addressService.getAddressList(member_id);

		return list;
	}
	
	// 배송지 선택
	@RequestMapping(value = "/searchAddr.do", method=RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody 
	public AddressVO searchAddr(AddressVO avo) {

		int address_num = avo.getAddress_num();
		AddressVO select_avo = addressService.searchAddress(address_num);
		
		return select_avo;
		
	}
		
	
	// 신규 배송지 저장 
	@RequestMapping(value = "/AddrAddAction.do", produces="application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> addressAdd(AddressVO avo) {
		Map<String, Object> retVal = new HashMap<String, Object>();
		try {
			
			int cnt = addressService.getAddressCount(avo);
			if(cnt == 5) {
				retVal.put("res", "CNTFAIL");
				retVal.put("message", "주소지는 최대 5개까지 입력 가능합니다."); 
				
				return retVal; 
			}
			int res = addressService.insertAddress(avo);
			retVal.put("res", "OK");
		} catch(Exception e) {
			retVal.put("res", "FAIL");
			retVal.put("message", "Failure");
		}
		
		return retVal; 
	}
	
	// 배송지 수정
	@RequestMapping(value = "/AddrModifyAction.do", produces="application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> addressModify(AddressVO avo) {
		Map<String, Object> retVal = new HashMap<String, Object>();
		try {
			int res = addressService.updateAddress(avo);
			retVal.put("res", "OK");
		} catch(Exception e) {
			retVal.put("res", "FAIL");
			retVal.put("message", "Failure");
		}
		
		return retVal; 
	}
	
	// 배송지 삭제
	@RequestMapping(value = "/deleteAddr.do", produces="application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> deleteAdd(AddressVO avo) {
		int address_num = avo.getAddress_num();
		Map<String, Object> retVal = new HashMap<String, Object>();
		try {
			int res = addressService.deleteAddress(address_num);
			retVal.put("res", "OK");
		} catch(Exception e) {
			retVal.put("res", "FAIL");
			retVal.put("message", "Failure");
		}	
			return retVal; 
	}
		
}
