package com.spring.order;

import java.util.ArrayList;

public interface AddressService {
	
	public ArrayList<AddressVO> getAddressList(String member_id);
	public AddressVO searchAddress(int address_num); 
	public int insertAddress(AddressVO avo); 
	public int deleteAddress(int address_num);
	public int updateAddress(AddressVO avo);
	public int getAddressCount(AddressVO avo);
}
